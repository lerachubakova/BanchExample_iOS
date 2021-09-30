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

        title = "Home"

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }
        
    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }

}
