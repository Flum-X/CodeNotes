//
//  CutsomTransitionVC.swift
//  MyWorkBook
//
//  Created by yuqing on 2023/3/31.
//  自定义转场动画

import UIKit

class CustomTransitionVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self.customPush1()
            self.customPush2()
        }
        
    }
    
    /// 使用CATransition实现自定义转场动画效果
    private func customPush1() {
        
        let vc = BaseVC()
        vc.title = "Test"
        let transition = CATransition()
        transition.type = .push
        transition.subtype = .fromLeft
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// UIViewControllerAnimatedTransitioning & UINavigationControllerDelegate
    private func customPush2() {
        
        let vc = BaseVC()
        vc.title = "customPush2"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
