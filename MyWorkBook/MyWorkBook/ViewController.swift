//
//  ViewController.swift
//  MyWorkBook
//
//  Created by Flum on 2021/12/27.
//

import UIKit

class BufferTestModel: NSObject {
    var content = ""
}

class ViewController: UIViewController {

    private var objBuffer: DXBuffer<BufferTestModel>?
    
    deinit {
        objBuffer?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customSliderTest()
        
        bufferTest()
    }

    private func customSliderTest() {
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

    private func bufferTest() {
        
        let config = DXBufferConfig()
        // 接收频率 5个/s
        config.t = 1 / 5.0
        // 阈值 10
        config.bufferSize = 10
        objBuffer = DXBuffer(storage: DXQueueStorage(), config: config)
        objBuffer?.completion = { buffer in
            //处理buffer数据
            print(buffer.content)
        }
        objBuffer?.start()
        
        for index in 0 ..< 10 {
            let model = BufferTestModel()
            model.content = index.description
            objBuffer?.receive(model)
        }
    }
    
}

