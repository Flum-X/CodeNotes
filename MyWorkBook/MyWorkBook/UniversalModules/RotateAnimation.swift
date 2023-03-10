//
//  RotateAnimation.swift
//  MyWorkBook
//
//  Created by yuqing on 2023/3/10.
//  旋转动画组件

import Foundation

//设置逆时针和顺时针旋转的枚举
@objc
enum Direction: Int {
    case DirectionRight = 0 //顺时针
    case DirectionLeft  //逆时针
}

class RotateAnimation: NSObject {
    
    @objc static func setAnimation(control: UIView, direction: Direction) {
        setAnimation(control: control, direction: direction, duration: 2.0)
    }
    
    @objc static func setAnimation(control: UIView, direction: Direction, duration: Double) {
        // y是根据y轴旋转，x是根据x轴旋转，z是根据z轴旋转

        // 如果是y, 则transform.rotation.y,如果是x,则transform.rotation.x, 如果是z,则transform.rotation.z
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        // 这里  M_PI * 2.0  为顺时针旋转，如果想要逆时针旋转可以写成  M_PI * -2.0
        if(direction == .DirectionRight) {
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        } else {
            rotationAnimation.toValue = NSNumber(value: Double.pi * -2.0)
        }
        rotationAnimation.duration = duration
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.fillMode = .forwards
        control.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}
