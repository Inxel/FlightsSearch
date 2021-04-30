//
//  AlertShowing.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 01.05.2021.
//

import UIKit

protocol AlertShowing: class {}

extension AlertShowing where Self: UIViewController {
    
    func showAlert(
        title: String? = nil,
        message: String? = nil,
        defaultButtonTitle: String? = nil,
        cancelButtonTitle: String? = nil,
        alertHandler: TypeHandler<UIAlertAction>? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let buttonTitle = defaultButtonTitle {
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: alertHandler))
        }
        
        if let cancelTitle = cancelButtonTitle {
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        }
        
        present(alert, animated: true)
    }
    
}
