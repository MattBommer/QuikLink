//
//  BrandColors.swift
//  RssReader
//
//  Created by Matt Bommer on 1/24/23.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    
    convenience init?(hexValue: String) {
            let start = hexValue.hasPrefix("0x") ? hexValue.index(hexValue.startIndex, offsetBy: 2) : hexValue.startIndex
            let hexCode = hexValue[start...]
            guard hexCode.count == 6 || hexCode.count == 8, var hexAsInt = Int(hexValue[start...], radix: 16) else { return nil }
            
            let toColorFloatPercentage = { (value: Int) in
                return CGFloat(value) / 255.0
            }
            
            var alpha: CGFloat = 1.0
            if hexCode.count == 8 {
                alpha = toColorFloatPercentage(0xFF & hexAsInt)
                hexAsInt = hexAsInt >> 8
            }
            
            let red = toColorFloatPercentage(((0xFF0000 & hexAsInt) >> 16))
            let green = toColorFloatPercentage(((0x00FF00 & hexAsInt) >> 8))
            let blue = toColorFloatPercentage(0x0000FF & hexAsInt)
            
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    
    
    static let brandBlue = UIColor(named: "brandblue")!
    
    static let brandPurple = UIColor(named: "brandpurple")!

    static let brandGreen = UIColor(named: "brandgreen")!

    static let brandRed = UIColor(named: "brandred")!

    static let brandWhite = UIColor(named: "brandwhite")!
    
    static let brandYellow = UIColor(named: "brandyellow")!
}

extension View {
    @ViewBuilder
    func isHidden(_ hide: Bool) -> some View {
        if hide {
            self.hidden()
        } else {
            self
        }
    }
}

extension Error {
    func displayMessage(with modalStore: ModalStore) {
        switch self {
        case is ResponseError:
            modalStore.present(view: {
                MessageView(message: localizedDescription, type: .critical)
            }, dim: false, ignoreSafeArea: false)
        default:
            print(self)
        }

    }
}
