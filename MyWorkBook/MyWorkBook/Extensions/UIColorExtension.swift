//
//  UIColor+Extension.swift
//  MyWorkBook
//
//  Created by Flum on 2021/12/27.
//

import UIKit

// MARK: 规范色值
extension UIColor {
    
  static func rgba(_ red: Float, _ green: Float, _ blue: Float, _ alpha: Float) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0,
                   green: CGFloat(green)/255.0,
                   blue: CGFloat(blue)/255.0,
                   alpha:CGFloat(alpha))
  }
  
  static func rgb(_ red: Float, _ green: Float, _ blue: Float) -> UIColor {
    return rgba(red, green, blue, 1.0)
  }
  
  static func rgb(from hex: Int) -> UIColor {
    return rgba(Float((hex & 0xFF0000) >> 16),
                Float((hex & 0xFF00) >> 8),
                Float(hex & 0xFF), 1.0)
  }
  static func rgb(from hex: Int,alpha:CGFloat) -> UIColor {
    return rgba(Float((hex & 0xFF0000) >> 16),
                Float((hex & 0xFF00) >> 8),
                Float(hex & 0xFF), Float(alpha))
  }
  
  @objc static let mcThemeColor = rgb(from: 0x6affd0) // 主题色 MaskCam
  @objc static let themeColor = rgb(from: 0xffcc32) // 主题色 vChat
  @objc static let black33  = rgb(from: 0x333333) // 主标题文本
  @objc static let black3A  = rgb(from: 0x3A3A3A) // 普通文本
  @objc static let black54  = rgb(from: 0x545454) // 普通文本
  @objc static let black1E  = rgb(from: 0x1E1E24) // 界面背景
  @objc static let black19  = rgb(from: 0x19191E) // 界面背景
  @objc static let black22  = rgb(from: 0x222222) // 黑色字体
  @objc static let blackAA  = rgb(from: 0xAAAAAA) // 普通字体
  @objc static let black66  = rgb(from: 0x666666) // 普通字体
  @objc static let blackAlpha05  = UIColor.black.withAlphaComponent(0.5) // 半黑字体
    
  @objc static let redF8    = rgb(from: 0xF85F5F) // 红色按钮
  @objc static let redF0    = rgb(from: 0xF05E4B) // 红色字体
  @objc static let whiteF4  = rgb(from: 0xF4F4F4) // 烟白色
  @objc static let whiteF6  = rgb(from: 0xF6F6F6) // tableView背景色
  @objc static let whiteE6  = rgb(from: 0xE6E6E6) // tableView分隔线
}

extension UIColor {
    public class func RGB(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    public class func colorWithHexString (hex: String) -> UIColor {
        return colorWithHexString(hex: hex, alpha: 1)
    }
    
    public class func colorWithHexString (hex: String, alpha: CGFloat) -> UIColor {
        
        var cString: String = (hex as NSString).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.white
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    public class func creatImageWithColor(color: UIColor) -> UIImage{
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
