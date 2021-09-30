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

    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        title = "Home"
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(tappedMenuButton))
    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }

}
