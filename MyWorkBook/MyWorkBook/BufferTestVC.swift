//
//  BufferTestVC.swift
//  MyWorkBook
//
//  Created by yuqing on 2023/3/31.
//

import UIKit
import RxSwift

class BufferTestModel: NSObject {
    var content = ""
}

class BufferTestVC: BaseVC {

    private var objBuffer: DXBuffer<BufferTestModel>?
    
    private var tableView: UITableView!
    
    @ToObservable private(set) var buffer: BufferTestModel?
    
    deinit {
        objBuffer?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        customSliderTest()
//
//        bufferTest()
        
//        popupTest()
        
        toObservableTest()
    }
    
    private func customSliderTest() {
        
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
    
    private func popupTest() {
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func tapAction() {
        
        let popup = BasePopupView(contentHeight: 380)
        popup.showInView(view: view, topCorner: 25)
    }
    
    private func toObservableTest() {
        
        buffer = BufferTestModel()
        buffer?.content = "Hello World!"
        
        $buffer.subscribe(onNext: { model in
            print(model?.content ?? "")
        }).disposed(by: DisposeBag())
        
    }

}
