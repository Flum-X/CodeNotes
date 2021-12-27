//
//  ViewController.swift
//  MyWorkBook
//
//  Created by Flum on 2021/12/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }

    private func initUI() {
        view.backgroundColor = .white
        
        let slider = CustomSlider()
        slider.height = 12
        slider.maximumTrackTintColor = .black.withAlphaComponent(0.1)
        let gradientImg = UIImage.gradient([UIColor.rgb(from: 0x47daff), UIColor.rgb(from: 0x6affd0)], size: CGSize(width: 300, height: 12), radius: 6, locations: [0, 1], direction: .horizontal)
        slider.setMinimumTrackImage(gradientImg, for: .normal)
        view.addSubview(slider)
        
        slider.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.center.equalToSuperview()
        }
    }

}

