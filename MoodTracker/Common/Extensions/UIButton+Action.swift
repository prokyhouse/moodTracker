//
//  UIButton+Action.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 23.09.2024.
//

import UIKit

public extension UIButton {
    @objc
    override func addActionHandler(_ handler: @escaping () -> Void, for event: UIControl.Event = .touchUpInside) {
        super.addActionHandler(handler, for: event)
    }
}

public extension UIControl {
    @objc
    func addActionHandler(_ handler: @escaping () -> Void, for event: UIControl.Event) {
        removeTarget(self, action: #selector(handleAction), for: event)
        addTarget(self, action: #selector(handleAction), for: event)
        actionHandler = handler
    }
}

private extension UIControl {
    enum AssociatedKeys {
        static var actionHandlerKey: Int = 0
    }
    var actionHandler: (() -> Void)? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.actionHandlerKey) as? (() -> Void)
        }
        set {
            guard let actionHandler = newValue else {
                return
            }
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.actionHandlerKey,
                actionHandler,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }
    @objc
    func handleAction() {
        actionHandler?()
    }
}
