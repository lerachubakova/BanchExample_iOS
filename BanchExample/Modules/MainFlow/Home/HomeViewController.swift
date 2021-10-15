//
//  HomeViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func tappedMenuButton()
}

class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    weak var delegate: HomeViewControllerDelegate?

    private var viewModel: HomeViewModel!
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = HomeViewModel(vc: self)
        LanguageObserver.subscribe(self)

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }
        
        configureTableView()
        setLocalizedStrings()
        viewModel.getNews()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTVCell.nib, forCellReuseIdentifier: NewsTVCell.identifier)
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }

    @objc private func refresh(_ sender: AnyObject) {
        viewModel.getNews()
    }

    func endRefresh() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//            self?.refreshControl.endRefreshing()
//        }
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }

    private func setLocalizedStrings() {
        title = LocalizeKeys.home.localized()
    }

    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
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
}
