//
//  UIView+Extension.swift
//  MusicPlayer
//
//  Created by xianshen Jiang on 2026/10/3.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
