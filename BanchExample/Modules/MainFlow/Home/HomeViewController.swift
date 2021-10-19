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

class HomeViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleButton: UIButton!
    @IBOutlet private weak var smallProgressView: AnimationView!
    @IBOutlet private weak var bigProgressView: AnimationView!
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

}

// MARK: - Alerts
extension HomeViewController {
    func makeMissedLinkAlert(index: Int) {
        let title = LocalizeKeys.alertTitle.localized()
        let source = viewModel.newsArray[index].source ?? LocalizeKeys.alertMissedLinkSource.localized()
        let message = LocalizeKeys.alertMissedLink.localized() + " " + source

        let alert = CustomAlertController(title: title, text: message)
        alert.addAction(title: LocalizeKeys.alertButton.localized())
        self.present(alert, animated: true, completion: nil)
    }

    func makeRequestErrorAlert() {
        let title = LocalizeKeys.alertTitle.localized()
        let message = LocalizeKeys.alertRequestError.localized()

        let alert = CustomAlertController(title: title, text: message)
        alert.addAction(title: LocalizeKeys.alertButton.localized())

        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - LanguageSubscriber
extension HomeViewController: LanguageSubscriber {
    func update() {
        self.setLocalizedStrings()
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
                    self?.tableView.isUserInteractionEnabled = true
                    self?.stopBigProgressAnimation()
                }
                return
            }

            let storyboard = UIStoryboard(name: "News", bundle: Bundle.main)
            guard let vc = storyboard.instantiateInitialViewController() as? NewsViewController else { return }
            vc.setNews(strongNews)

            self?.navigationController?.pushViewController(viewController: vc, animated: true ) { [weak self] in
                self?.tableView.isUserInteractionEnabled = true
                self?.stopBigProgressAnimation()
            }
        }
    }
}
