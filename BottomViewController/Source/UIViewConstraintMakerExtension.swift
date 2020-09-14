//
//  BottomViewControllerConfigurator.swift
//  BottomViewController
//
//  Created by Ivan Miroshnik on 14.09.2020.
//  Copyright © 2020 whistmage. All rights reserved.
//

import UIKit

/* MARK: Constraint Maker
   Сделано для локального использования, по аналогии со SnapKit.
*/
internal extension UIView {
    
    @discardableResult func makeConstraint(
        alignment: NSLayoutConstraint.Attribute,
        toView destinationView: UIView,
        offset: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(
            item: self,
            attribute: alignment,
            relatedBy: .equal,
            toItem: destinationView,
            attribute: alignment,
            multiplier: 1.0,
            constant: offset
        )
        constraint.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return constraint
    }
    
    @discardableResult func makeConstraintAlignmentToParrentView(
        alignment: NSLayoutConstraint.Attribute,
        offset: CGFloat = 0
    ) -> NSLayoutConstraint {
        guard let parentView = superview else {
            let message = "[Error][BottomViewController] Missing superview to create alignment constraint"
            assertionFailure(message)
            abort()
        }
        let constraint = makeConstraint(
            alignment: alignment,
            toView: parentView,
            offset: offset
        )
        return constraint
    }
    
    
    @discardableResult func makeHeightConstraint(
        value: CGFloat
    ) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: value
        )
        constraint.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return constraint
    }
    
    @discardableResult func makeWidthConstraint(
        value: CGFloat
    ) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: value
        )
        constraint.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return constraint
    }
}
