//
//  UIDevice+Ext.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/10/16.
//  Copyright © 2020 dzcx. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isMordenPhone: Bool {
        let size = ScreenHelper.mainBounds.size
        switch size {
        /// iPhone X/Xs/11Pro
        case CGSize(width: 375, height: 812), CGSize(width: 812, height: 375):
            return true
        /// iPhone XsMax/Xr/11/11ProMax
        case CGSize(width: 414, height: 896), CGSize(width: 896, height: 414):
            return true
        default:
            return false
        }
    }
}
