//
//  UIViewControllerExtension.swift
//  BottomViewController
//
//  Created by Ivan Miroshnik on 14.09.2020.
//  Copyright © 2020 whistmage. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Present BottomViewController. Work as add child at ViewController.
    func present(
        _ viewControllerToPresent: BottomViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        tabBarController?.tabBar.isHidden = true
        addChild(viewControllerToPresent)
        viewControllerToPresent.didMove(toParent: self)
        view.addSubview(viewControllerToPresent.view)
        viewControllerToPresent.view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: view.frame.height
        )
    }
}
