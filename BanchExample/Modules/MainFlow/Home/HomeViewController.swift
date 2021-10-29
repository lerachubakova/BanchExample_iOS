//
//  HomeViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import Lottie
import SafariServices
import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func tappedMenuButton()
}

final class HomeViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleButton: UIButton!
    @IBOutlet private weak var smallProgressView: AnimationView!
    @IBOutlet private weak var bigProgressView: AnimationView!
    @IBOutlet private weak var gearButton: UIButton!

    // MARK: - Public Properties
    weak var delegate: HomeViewControllerDelegate?

    // MARK: - Private Properties
    private var viewModel: HomeViewModel!
    private let refreshControl = UIRefreshControl()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = HomeViewModel(vc: self)
        LanguageObserver.subscribe(self)

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }

        configureTableView()
        configureAnimationViews()
        setFilter()
        setLocalizedStrings()

        startSmallProgressAnimation()
        viewModel.getNews()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTable()
    }

    // MARK: - Setup
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        tableView.register(NewsTVCell.nib, forCellReuseIdentifier: NewsTVCell.identifier)
        refreshControl.addTarget(self, action: #selector(startRefresh(_:)), for: .valueChanged)
    }

    private func configureAnimationViews() {
        bigProgressView.loopMode = .loop
        bigProgressView.animationSpeed = 0.75

        smallProgressView.loopMode = .loop
        smallProgressView.animationSpeed = 0.75
    }

    // MARK: - Logic
    func blockTableView(isBlocked: Bool) {
        tableView.isUserInteractionEnabled = !isBlocked
    }

    private func setLocalizedStrings() {
        titleButton.setTitle(LocalizeKeys.home.localized(), for: .normal)
        navigationItem.backButtonTitle = LocalizeKeys.home.localized()

        let row = userDefaults.integer(forKey: UserDefaultsKeys.filter)
        gearButton.setTitle(FiltersViewController.getTitleForPickerView(for: row), for: .normal)
    }

    private func setFilter() {
        let row = userDefaults.integer(forKey: UserDefaultsKeys.filter)
        viewModel.setFilter(filter:  NewsFilter.allCases[row])
        gearButton.setTitle(FiltersViewController.getTitleForPickerView(for: row), for: .normal)
    }

    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    @objc private func startRefresh(_ sender: AnyObject) {
        viewModel.getNews()
    }

    func endRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }

    private func startBigProgressAnimation() {
        bigProgressView.isHidden = false
        bigProgressView.play()
    }

    private func stopBigProgressAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.bigProgressView.isHidden = true
            self?.bigProgressView.stop()
        }
    }

    func startSmallProgressAnimation() {
        blockTableView(isBlocked: true)
        smallProgressView.isHidden = false
        smallProgressView.play()
    }

    func stopSmallProgressAnimation() {
        blockTableView(isBlocked: false)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.smallProgressView.isHidden = true
            self?.smallProgressView.stop()
        }
    }

    // MARK: - @IBActions
    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }

    @IBAction private func tappedTitleButton(_ sender: Any) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    @IBAction private func tappedGearButton(_ sender: Any) {
        self.present(FiltersViewController(delegate: self), animated: true, completion: nil)
    }
}

// MARK: - Alerts
extension HomeViewController {
    func makeMissedLinkAlert(index: Int) {
        let title = LocalizeKeys.Alerts.alertTitle.localized()
        let source = viewModel.newsArray[index].source ?? LocalizeKeys.Alerts.alertMissedLinkSource.localized()
        let message = LocalizeKeys.Alerts.alertMissedLink.localized() + " " + source

        let alert = CustomAlertController(title: title, text: message)
        alert.addAction(title: LocalizeKeys.Alerts.alertButton.localized())
        self.present(alert, animated: true, completion: nil)
    }

    func makeRequestErrorAlert() {
        let title = LocalizeKeys.Alerts.alertTitle.localized()
        let message = LocalizeKeys.Alerts.alertRequestError.localized()

        let alert = CustomAlertController(title: title, text: message)
        alert.addAction(title: LocalizeKeys.Alerts.alertButton.localized())

        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - LanguageSubscriber
extension HomeViewController: LanguageSubscriber {
    func updateLanguage() {
        self.setLocalizedStrings()
    }
}

// MARK: - FiltersSubscriber
extension HomeViewController: FiltersSubscriber {
    func updateFilter() {
        self.setFilter()
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsTVCell.identifier) as? NewsTVCell else {
            return UITableViewCell()
        }
        
        newsCell.configure(by: viewModel.newsArray[indexPath.item])
        return newsCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        blockTableView(isBlocked: true)
        startBigProgressAnimation()
        tableView.deselectRow(at: indexPath, animated: true)
        CoreDataManager.makeAsViewed(news: viewModel.newsArray[indexPath.item])

        guard let strongURL = viewModel.newsArray[indexPath.item].link else {
            makeMissedLinkAlert(index: indexPath.item)
            return
        }

        NetworkManager().makeNewsRequestByLink(url: strongURL) {[weak self] news in
            guard let strongNews = news else {
                let safariVC = SFSafariViewController(url: strongURL)
                self?.present(safariVC, animated: true) { [weak self] in
                    self?.blockTableView(isBlocked: false)
                    self?.stopBigProgressAnimation()
                }
                return
            }

            let storyboard = UIStoryboard(name: "News", bundle: Bundle.main)
            guard let vc = storyboard.instantiateInitialViewController() as? NewsViewController else { return }
            vc.setNews(strongNews)

            self?.navigationController?.pushViewController(viewController: vc, animated: true ) { [weak self] in
                self?.blockTableView(isBlocked: false)
                self?.stopBigProgressAnimation()
            }
        }
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let news = self.viewModel.newsArray[indexPath.item]
        let cell = tableView.cellForRow(at: indexPath) as? NewsTVCell

        let unreadAction = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completionHandler) in
            CoreDataManager.changeIntrestingStatus(news: news)
            cell?.changeInterestingStatus()
            completionHandler(true)
            DispatchQueue.main.asyncAfter(deadline: (.now() + 0.6)) {
                self?.viewModel.updateByCoreData()
            }
        }

        unreadAction.image = news.isInteresting ? UIImage(systemName: "eye.slash.fill") : UIImage(systemName: "eye.fill")
        unreadAction.backgroundColor = news.isInteresting ? .systemGray : .systemGreen

        let trashAction = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, completionHandler) in
            CoreDataManager.changeDeletedStatus(news: news)
            cell?.changeDeletedStatus()
            completionHandler(true)
            DispatchQueue.main.asyncAfter(deadline: (.now() + 0.6)) {
                self?.viewModel.updateByCoreData()
            }
        }

        trashAction.image = news.wasDeleted ? UIImage(systemName: "trash.slash.fill") : UIImage(systemName: "trash.fill")
        trashAction.backgroundColor = news.wasDeleted ?.systemGray2 : .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [trashAction, unreadAction])

        return configuration
    }
}
