//
//  UINavigationControllerExtensions.swift
//  BanchExample
//
//  Created by User on 19.10.21.
//

import UIKit

extension UINavigationController {

    public func pushViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
