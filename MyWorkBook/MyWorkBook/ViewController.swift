//
//  ViewController.swift
//  MyWorkBook
//
//  Created by Flum on 2021/12/27.
//

import UIKit

class ViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private var titles = ["BufferTest", "CustomTransitions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        initUI()
    }

    private func initUI() {
        
        tableView = UITableView()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = true
        }
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.showsVerticalScrollIndicator = false
//        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(Constant.navigationBarHeight())
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        cell.textLabel?.text = titles[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = BufferTestVC()
            vc.title = titles[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = CustomTransitionVC()
            vc.title = titles[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
}

