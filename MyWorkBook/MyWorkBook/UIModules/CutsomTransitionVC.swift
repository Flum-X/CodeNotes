//
//  CutsomTransitionVC.swift
//  MyWorkBook
//
//  Created by yuqing on 2023/3/31.
//  自定义转场动画

import UIKit

class CutsomTransitionVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.customPush()
        }
    }

    private func customPush() {
        
        let vc = BaseVC()
        vc.title = "Test"
        let transition = CATransition()
        transition.type = .push
        transition.subtype = .fromLeft
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
