//
//  KeyboardAvoidable.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/3/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit


protocol KeyboardAvoidable: class {

    func addKeyboardObservers(forConstraints constraints: [NSLayoutConstraint])
    
    func addKeyboardObservers(forCustomBlock block: @escaping (CGFloat) -> Void)
    
    func addKeyboardObservers(forConstraints constraints: [NSLayoutConstraint]?,
                              customBlock block: ((CGFloat) -> Void)?)
    
    func removeKeyboardObservers()
}

fileprivate var KeyboardShowObserverObjectKey: UInt8 = 1
fileprivate var KeyboardHideObserverObjectKey: UInt8 = 2
fileprivate var ConstraintsDictionaryKey: UInt8 = 3

extension KeyboardAvoidable where Self: UIViewController {
    
    private var keyboardShowObserverObject: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &KeyboardShowObserverObjectKey) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(self, &KeyboardShowObserverObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var keyboardHideObserverObject: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &KeyboardHideObserverObjectKey) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(self, &KeyboardHideObserverObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var constraintsAndValues: [NSLayoutConstraint: CGFloat]? {
        get {
            return objc_getAssociatedObject(self, &ConstraintsDictionaryKey) as? [NSLayoutConstraint: CGFloat]
        }
        set {
            objc_setAssociatedObject(self, &ConstraintsDictionaryKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Public methods
    
    func addKeyboardObservers(forConstraints constraints: [NSLayoutConstraint]) {
        addKeyboardObservers(forConstraints: constraints, customBlock: nil)
    }
    
    func addKeyboardObservers(forCustomBlock block: @escaping (CGFloat) -> Void) {
        addKeyboardObservers(forConstraints: nil, customBlock: block)
    }
    
    func addKeyboardObservers(forConstraints constraints: [NSLayoutConstraint]?,
                              customBlock block: ((CGFloat) -> Void)?)
    {
        removeKeyboardObservers()
        if let constraints = constraints {
            constraintsAndValues = constraints.reduce([NSLayoutConstraint: CGFloat]()) {
                (result, constraint) -> [NSLayoutConstraint: CGFloat] in
                
                var result = result
                result[constraint] = constraint.constant
                return result
            }
        }
        
        keyboardShowObserverObject = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow,
                                                                            object: nil,
                                                                            queue: nil)
        { [weak self] notification in
            guard let notificationParameters = self?.getKeyboardShowParameters(fromNotification: notification) else {
                return
            }
            
            if let block = block {
                block(notificationParameters.height)
                return
            }
            
            self?.animateLayout(parameters: notificationParameters, animations: {
                self?.constraintsAndValues?.forEach {
                    if #available(iOS 11.0, *) {
                        $0.key.constant =
                            notificationParameters.height + $0.value - ( self?.view.safeAreaInsets.bottom ?? 0 )
                    } else {
                        $0.key.constant = notificationParameters.height + $0.value
                    }
                    
                }
            })
        }
        
        keyboardHideObserverObject = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide,
                                                                            object: nil,
                                                                            queue: nil)
        { [weak self] notification in
            guard let notificationParameters = self?.getKeyboardShowParameters(fromNotification: notification) else {
                
                return
            }
            if let block = block {
                block(notificationParameters.height)
                return
            }
            
            self?.animateLayout(parameters: notificationParameters, animations: {
                self?.constraintsAndValues?.forEach {
                    $0.key.constant = $0.value
                }
            })
        }
    }
    
    func removeKeyboardObservers() {
        if let keyboardShowObserverObject = keyboardShowObserverObject {
            NotificationCenter.default.removeObserver(keyboardShowObserverObject)
        }
        if let keyboardHideObserverObject = keyboardHideObserverObject {
            NotificationCenter.default.removeObserver(keyboardHideObserverObject)
        }
        keyboardShowObserverObject = nil
        keyboardHideObserverObject = nil
        constraintsAndValues = nil
    }
    
    // MARK: - Private methods
    
    typealias KeyboardNotificationParameters = (height: CGFloat,
        duration: TimeInterval,
        animationOptions: UIViewAnimationOptions)
    
    private func getKeyboardShowParameters(fromNotification notification: Notification)
        -> KeyboardNotificationParameters? {
        guard let info = notification.userInfo,
            let heightValue = info[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let durationValue = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let animationCurveValue = info[UIKeyboardAnimationCurveUserInfoKey] as? UInt  else
        {
            return nil
        }
        
        return (heightValue.size.height, durationValue, UIViewAnimationOptions(rawValue: animationCurveValue << 16))
    }
    
    private func animateLayout(parameters: KeyboardNotificationParameters, animations: @escaping () -> Void) {
        UIView.animate(withDuration: parameters.duration,
                       delay: 0,
                       options: [parameters.animationOptions, .beginFromCurrentState],
                       animations: {
                        animations()
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
