//
//  UIViewController+SafeArea.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit

extension UIViewController {
    
    final var bottomSafeAreaInset: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
}
