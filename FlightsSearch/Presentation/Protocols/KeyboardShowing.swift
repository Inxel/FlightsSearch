//
//  KeyboardShowing.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 27.04.2021.
//

import UIKit

protocol KeyboardShowing {
    func keyboardWillShow(keyboardHeight: CGFloat, with animationDuration: Double)
    func keyboardWillHide(with animationDuration: Double)
}

extension KeyboardShowing where Self: UIViewController {
    
    func addObserverKeyboardNotificatons() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard
                let self = self,
                let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            else { return }
            
            self.keyboardWillShow(keyboardHeight: keyboardSize.height, with: animationDuration)
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard
                let self = self,
                let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            else { return }
            
            self.keyboardWillHide(with: animationDuration)
        }
    }
    
    func removeObserverKeyboardNotificatons() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

