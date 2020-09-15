//
//  BottomViewController.swift
//  BottomViewController
//
//  Created by Ivan Miroshnik on 14.09.2020.
//  Copyright © 2020 whistmage. All rights reserved.
//

import UIKit

public struct BottomViewControllerConfiguration {
    var fullHeight: CGFloat
    var partialHeight: CGFloat
}

open class BottomViewController: UIViewController {

    // MARK: - Declaration of variables and constants

    let overlayView = UIView()
    let touchAnchorView = UIView()
    let contentView = UIView()

    lazy var configuration: BottomViewControllerConfiguration = {
        let topPadding: CGFloat = 20
        let defaultMaxHeight = view.frame.height - topPadding
        let configuration = BottomViewControllerConfiguration.init(
            fullHeight: defaultMaxHeight,
            partialHeight: defaultMaxHeight / 3
        )
        return configuration
    }()

    private var maxOffset: CGFloat {
        configuration.partialHeight / 4
    }
    private var previosTouchYValue: CGFloat = 0
    private var isContentHidden = true
    
    private var contentHeightConstraint: NSLayoutConstraint!
    
    // MARK: - BottomViewController methods

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showContent()
    }

    open override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, checkIsTouchHitCorrectView(touch: touch) {
            previosTouchYValue = calculateTouchYValue(touch: touch)
        }
    }
    
    open override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first, checkIsTouchHitCorrectView(touch: touch) {
            previosTouchYValue = calculateTouchYValue(touch: touch)
            endMoveContent(offset: previosTouchYValue)
        }
    }
    
    open override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first, checkIsTouchHitCorrectView(touch: touch) {
            let newTouchYValue = calculateTouchYValue(touch: touch)
            let offset = newTouchYValue - previosTouchYValue
            let newHeight = contentView.frame.height + offset
            previosTouchYValue = newTouchYValue
            moveContent(offset: newHeight)
        }
    }

    open override func dismiss(
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        hideContent(
            animated: flag,
            comletition: {
                self.presentingViewController?.tabBarController?.tabBar.isHidden = false
                super.dismiss(
                    animated: false,
                    completion: completion
                )
            }
        )
    }

    /// Override this method and call super after your code,
    /// if you need handle close ButtomViewController
    open func close(
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        dismiss(
            animated: animated,
            completion: completion
        )
    }
    
    @objc func tapOverlay() {
        close(animated: true)
    }
}

// MARK: - BottomViewController controll content view

extension BottomViewController {

    private func checkIsTouchHitCorrectView(touch: UITouch) -> Bool {
        return touch.view == contentView || touch.view == touchAnchorView
    }

    private func startViewAnimation(completion: (() -> Void)?) {
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: { finished in
                if finished {
                    completion?()
                }
            }
        )
    }

    private func calculateTouchYValue(touch: UITouch) -> CGFloat {
        let viewLocation = touch.location(in: view)
        return view.frame.height - viewLocation.y
    }

    private func moveContent(
        offset: CGFloat,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard offset <= self.configuration.fullHeight else {
            return
        }
        if offset >= self.configuration.partialHeight - maxOffset {
            contentHeightConstraint.constant = offset
            if animated {
                startViewAnimation(completion: completion)
            } else {
                completion?()
            }
        } else {
            close(animated: animated)
        }
    }
    
    private func endMoveContent(offset: CGFloat) {
        if offset > configuration.partialHeight + maxOffset {
            moveContent(
                offset: configuration.fullHeight,
                animated: true
            )
        } else {
            if offset < self.configuration.partialHeight - maxOffset  {
                close(animated: true)
            } else {
                moveContent(
                    offset: configuration.partialHeight,
                    animated: true
                )
            }
        }
    }
    
    private func showContent(animated: Bool = true) {
        if isContentHidden {
            moveContent(
                offset: configuration.partialHeight,
                animated: animated
            )
            isContentHidden = false
        }
    }
    
    private func hideContent(
        animated: Bool = true,
        comletition: @escaping (() -> Void)
    ) {
        guard !isContentHidden else {
            return
        }
        isContentHidden = true
        contentHeightConstraint.constant = 0
        if animated {
            startViewAnimation(completion: comletition)
        } else {
            comletition()
        }
    }
}

// MARK: - BottomViewController setup view

extension BottomViewController {

    private func setupView() {
        view.backgroundColor = .clear
        addSubviews()
        setupOverlayView()
        setuptContentView()
        setupTouchAnchorView()
    }
    
    private func addSubviews() {
        view.addSubview(overlayView)
        view.addSubview(contentView)
        contentView.addSubview(touchAnchorView)
    }
    
    private func setupOverlayView() {
        let tap = UITapGestureRecognizer.init(
             target: self,
             action: #selector(tapOverlay)
         )
         overlayView.addGestureRecognizer(tap)
         overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.20)
         makeOverlayViewConstraints()
    }
    
    private func setuptContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.layer.masksToBounds = true
        makeContentViewConstraints()
    }
    
    private func setupTouchAnchorView() {
        touchAnchorView.backgroundColor = .gray
        makeTouchAnchorViewConstraints()
    }
}

// MARK: - BottomViewController make contstraints

extension BottomViewController {
    
    private func makeOverlayViewConstraints() {
        overlayView.makeConstraintAlignmentToParrentView(
            alignment: .top
        )
        overlayView.makeConstraintAlignmentToParrentView(
            alignment: .bottom
        )
        overlayView.makeConstraintAlignmentToParrentView(
            alignment: .left
        )
        overlayView.makeConstraintAlignmentToParrentView(
            alignment: .right
        )
    }

    private func makeContentViewConstraints() {
        contentHeightConstraint = contentView.makeHeightConstraint(
            value: 0
        )
        contentView.makeConstraintAlignmentToParrentView(
            alignment: .bottom
        )
        contentView.makeConstraintAlignmentToParrentView(
            alignment: .left
        )
        contentView.makeConstraintAlignmentToParrentView(
            alignment: .right
        )
    }

    private func makeTouchAnchorViewConstraints() {
        touchAnchorView.makeHeightConstraint(
            value: 4
        )
        touchAnchorView.makeWidthConstraint(
            value: 64
        )
        touchAnchorView.makeConstraintAlignmentToParrentView(
            alignment: .centerX
        )
        touchAnchorView.makeConstraint(
            alignment: .top,
            toView: contentView,
            offset: 8
        )
    }
}
