//
//  BasePopupView.swift
//  Novelit
//
//  Created by huanglixin on 2023/2/20.
//  通用底部弹出组件

import UIKit

let kScreenHeight = UIScreen.main.bounds.height

class BasePopupView: UIView {

    var bgV = UIView()
    var contentV = UIView()
    private var contentH: CGFloat = 0
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction))
        return pan
    }()
    required init(contentHeight: CGFloat) {
        super.init(frame: .zero)
        self.contentH = contentHeight
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initUI() {
        
        bgV.backgroundColor = .black.withAlphaComponent(0.5)
        bgV.alpha = 0
        addSubview(bgV)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        bgV.addGestureRecognizer(tap)
        
        contentV.backgroundColor = .white
        addSubview(contentV)
        
        bgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(kScreenHeight)
            make.height.equalTo(contentH)
        }
        contentV.addGestureRecognizer(panGesture)
    }
    
    @objc func tapAction() {
        dismiss()
    }
    
    @objc func showInView(view: UIView? = nil, topCorner: CGFloat = 0) {
        
        var inView = UIView()
        if let view = view {
            inView = view
        } else {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            inView = window
        }
        
        if topCorner > 0 {
            contentV.setPartialCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: topCorner)
        }
        
        inView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        inView.layoutIfNeeded()
        
        contentV.snp.updateConstraints { make in
            make.top.equalTo(kScreenHeight - contentH)
        }
        UIView.animate(withDuration: 0.3) {
            self.bgV.alpha = 1.0
            inView.layoutIfNeeded()
        }
    }
    
    @objc func dismiss() {
        
        contentV.snp.updateConstraints { make in
            make.top.equalTo(kScreenHeight)
        }
        UIView.animate(withDuration: 0.3) {
            self.bgV.alpha = 0.0
            self.superview?.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc func panAction(pan: UIPanGestureRecognizer) {
        let point = panGesture.translation(in: self)
        if panGesture.state == .ended || panGesture.state == .cancelled {
            if contentV.frame.origin.y >= kScreenHeight - contentH + 40 {
                dismiss()
            }else {
                contentV.snp.updateConstraints { make in
                    make.top.equalTo(kScreenHeight - contentH)
                }
            }
        }else {
            let frame = contentV.frame
            var offy = point.y+frame.origin.y
            offy = max(kScreenHeight-contentH, offy)
            contentV.snp.updateConstraints { make in
                make.top.equalTo(offy)
            }
            
        }
        panGesture.setTranslation(.zero, in: self)
    }
    
}
