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
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .black
        
        title = "Home"

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(tappedMenuButton))

    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }

}
