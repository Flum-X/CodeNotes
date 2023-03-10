//
//  UIViewExtension.swift
//  MyWorkBook
//
//  Created by yuqing on 2023/3/10.
//

import Foundation

extension UIView {
    
    @objc func setCornerRadius(_ radius: CGFloat) {
        
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func setCornerRadius(_ radius: CGFloat,
                         borderColor: UIColor,
                         borderWidth: CGFloat) {
        
        setCornerRadius(radius)
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    /// 设置部分圆角
    @objc func setPartialCorners(corners:CACornerMask, radius:CGFloat) {
        
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        layer.masksToBounds = true
    }
    
    @objc func setPartialCorners(corners:CACornerMask,
                                 radius:CGFloat,
                                 boderColor: UIColor,
                                 boderWidth: CGFloat) {
        
        setPartialCorners(corners: corners, radius: radius)
        layer.borderColor = boderColor.cgColor
        layer.borderWidth = boderWidth
    }
}
