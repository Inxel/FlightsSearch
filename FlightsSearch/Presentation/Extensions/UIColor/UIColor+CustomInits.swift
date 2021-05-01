//
//  UIColor+CustomInits.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 02.05.2021.
//

import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: Int) {
        self.init(r: r, g: g, b: b, a: CGFloat(a) / 255)
    }
    
}
