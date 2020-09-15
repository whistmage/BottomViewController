//
//  UIViewControllerExtension.swift
//  BottomViewController
//
//  Created by Ivan Miroshnik on 14.09.2020.
//  Copyright © 2020 whistmage. All rights reserved.
//

import UIKit

extension UIViewController {
    
    open func present(
        _ bottomViewController: BottomViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        tabBarController?.tabBar.isHidden = true
        bottomViewController.modalPresentationStyle = .overCurrentContext
        let viewControllerToPresent = bottomViewController as UIViewController
        present(
            viewControllerToPresent,
            animated: false,
            completion: completion
        )
    }
}
