//
//  UIImage+Extension.swift
//  MyWorkBook
//
//  Created by Flum on 2021/12/27.
//

import Foundation
import UIKit

public enum DXImageGradientDirection {
    /// 水平从左到右
    case horizontal
    /// 垂直从上到下
    case vertical
    /// 左上到右下
    case leftOblique
    /// 右上到左下
    case rightOblique
    /// 自定义
    case other(CGPoint, CGPoint)
    
    public func point(size: CGSize) -> (CGPoint, CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0))
        case .vertical:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height))
        case .leftOblique:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
        case .rightOblique:
            return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
        case .other(let stat, let end):
            return (stat, end)
        }
    }
}

extension UIImage {
    
    // MARK: 2.4、生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// 生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    static func gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations:[CGFloat]? = nil, direction: DXImageGradientDirection = .horizontal) -> UIImage? {
        return gradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }
    
    // MARK: 2.5、生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// 生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - radius: 圆角
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 带圆角的渐变的图片
    static func gradient(_ colors: [UIColor],
                         size: CGSize = CGSize(width: 10, height: 10),
                         radius: CGFloat,
                         locations:[CGFloat]? = nil,
                         direction: DXImageGradientDirection = .horizontal) -> UIImage? {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return image(with: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map{$0.cgColor} as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    
    ///根据纯色返回图片
    static func image(with color: UIColor?) -> UIImage {
        return UIImage.image(with: color, size: CGSize(width: 1, height: 1))
    }
    
    
    static func image(with color: UIColor?, size: CGSize) -> UIImage {
        var img = UIImage()
        
        if let color = color {
            var rect = CGRect.zero
            rect.size = size
            
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
            
            if let imgFromContext = UIGraphicsGetImageFromCurrentImageContext() {
                img = imgFromContext
            }
            
            UIGraphicsEndImageContext()
        }
        
        return img
    }
  
    static func image(with color: UIColor?, size: CGSize,radius: CGFloat,corner:UIRectCorner) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        
        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize.init(width: radius, height: radius))
        ctx?.addPath(path.cgPath)
        ctx?.setFillColor(color!.cgColor)
        ctx?.fillPath()
        
        let image  = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    static func image(with color: UIColor?, size: CGSize,radius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor((color?.cgColor)!)
        ctx?.setStrokeColor(UIColor.clear.cgColor)
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath.init(roundedRect: rect, cornerRadius: radius)
        ctx?.addPath(path.cgPath)
        ctx?.drawPath(using: .fillStroke)
        let image  = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 生成指定尺寸的图片
    /// - Parameter size: 图片尺寸
    /// - Returns: <#description#>
    func scaleToSize(_ targetSize: CGSize) -> UIImage? {
        let width = size.width
        let height = size.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor:CGFloat = 0
        var scaleWidth = targetWidth
        var scaleHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0, y: 0)
        
        if width != targetWidth || height != targetHeight {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            scaleWidth = width * scaleFactor
            scaleHeight = height * scaleFactor
            
            ///center the image
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaleHeight) * 0.5
            } else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaleWidth) * 0.5
            }
        }
        
        /// 裁剪框向下取整是为了防止图片裁剪后出现白边的bug
        let newSize = CGSize(width: floor(targetWidth), height: floor(targetHeight))
        UIGraphicsBeginImageContext(newSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaleWidth
        thumbnailRect.size.height = scaleHeight
        self.draw(in: thumbnailRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    
    /// 按需求生成指定尺寸的正方形图片
    /// - Returns: <#description#>
    func scaleToSquareImage() -> UIImage? {
        var tempSize = CGSize(width: 0, height: 0)
        if size.width > 1000 {
            tempSize = CGSize(width: 1000, height: 1000)
        } else if size.width < 200 {
            tempSize = CGSize(width: 200, height: 200)
        } else {
            tempSize = CGSize(width: size.width, height: size.width)
        }
        return scaleToSize(tempSize)
    }
    
    /**
     *功能: 压缩图片质量 https://github.com/Silence-GitHub/CompressImageDemo
     * -image: 待压缩的图片
     * -maxLength: 压缩后图片的最大size
     **/
    static func compressImageQuality(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
//        guard var data = UIImageJPEGRepresentation(image, compression),
//            data.count > maxLength else {
//                return image
//        }
      guard var data = image.jpegData(compressionQuality: compression),
        data.count > maxLength else {
          return image
      }
        debugPrint("Before compressing quality, image size =", data.count / 1024, "KB")
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
//          data = UIImageJPEGRepresentation(image, compression)!
          data = image.jpegData(compressionQuality: compression)!
            debugPrint("Compression =", compression)
            debugPrint("In compressing quality loop, image size =", data.count / 1024, "KB")
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        debugPrint("After compressing quality, image size =", data.count / 1024, "KB")
        return UIImage(data: data)!
    }
    
    
    /**
     *功能: 压缩图片尺寸 https://github.com/Silence-GitHub/CompressImageDemo
     * -image: 待压缩的图片
     * -maxLength: 压缩后图片的最大size
     **/
    static func compressImageSize(_ image: UIImage, toByte maxLength: Int) -> UIImage {
//        guard var data = UIImageJPEGRepresentation(image, 1) else {
//            return image
//        }
      guard var data = image.jpegData(compressionQuality: 1) else {
        return image
      }
        debugPrint("Before compressing size, image size =", data.count / 1024, "KB")
        
        var resultImage: UIImage = image
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            debugPrint("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
//          data = UIImageJPEGRepresentation(resultImage, 1)!
          data = resultImage.jpegData(compressionQuality: 1)!
            debugPrint("In compressing size loop, image size =", data.count / 1024, "KB")
        }
        debugPrint("After compressing size loop, image size =", data.count / 1024, "KB")
        return resultImage
    }
    
    
    /**
     *功能: 混合压缩图片的质量及尺寸 https://github.com/Silence-GitHub/CompressImageDemo
     * -image: 待压缩的图片
     * -maxLength: 压缩后图片的最大size
     **/
    static func compressImage(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
//        guard var data = UIImageJPEGRepresentation(image, compression),
//            data.count > maxLength else {
//                return image
//        }
      guard var data = image.jpegData(compressionQuality: compression),
        data.count > maxLength else {
          return image
      }

        debugPrint("Before compressing quality, image size =", data.count / 1024, "KB")
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
//            data = UIImageJPEGRepresentation(image, compression)!
          data = image.jpegData(compressionQuality: compression)!
            debugPrint("Compression =", compression)
            debugPrint("In compressing quality loop, image size =", data.count / 1024, "KB")
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        debugPrint("After compressing quality, image size =", data.count / 1024, "KB")
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength { return resultImage }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            debugPrint("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
          //data = UIImageJPEGRepresentation(resultImage, compression)!
          data = resultImage.jpegData(compressionQuality: compression)!
            debugPrint("In compressing size loop, image size =", data.count / 1024, "KB")
        }
        debugPrint("After compressing size loop, image size =", data.count / 1024, "KB")
        return resultImage
    }
    
    func thumbnail(aSize: CGSize) -> UIImage? {
        var newimage: UIImage?
        UIGraphicsBeginImageContext(aSize)
        self.draw(in: CGRect.init(x: 0, y: 0, width: aSize.width, height: aSize.height))
        newimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newimage
    }
  
}


extension UIImage {
  
  /**
   *  读取图片中的二维码
   *  @param image 图片
   *  @return 图片中的二维码数据集合 CIQRCodeFeature对象
   */
  @objc static func readQRCode(from image: UIImage) -> [CIQRCodeFeature]? {
    // 创建一个CIImage对象
    let context = CIContext.init(options: [CIContextOption.useSoftwareRenderer: true])//软件渲染
    let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])//二维码识别
    guard let ciImage = CIImage.init(image: image) else {
      return nil
    }
    
    if let features = detector?.features(in: ciImage) as? [CIQRCodeFeature] {
      for feature in features {
        debugPrint("msg = ", feature.messageString ?? "") // 打印二维码中的信息
      }
      return features
    }
    return nil
  }
  
  //根据url获取网络图片
  @objc static func getImageFromUrl(_ urlStr: String) -> UIImage? {
    
    guard !urlStr.isEmpty else {
      return nil
    }
    
    let imgUrl = URL(string: urlStr)
    
    do {
      let data = try Data.init(contentsOf: imgUrl!)
      let image = UIImage(data: data)
      return image
    } catch let error as NSError {
      DLog(error)
      return nil
    }
    
  }
    
    /// 获取视图的截屏图片
    /// - Parameter view: <#view description#>
    /// - Returns: <#description#>
    @objc static func getScreenShotImage(_ view: UIView?)->UIImage? {
        
        guard let view = view else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
  
}
