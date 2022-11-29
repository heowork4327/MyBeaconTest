//
//  MinewTestViewController.swift
//  MyBeaconTest
//
//  Created by nyeong heo on 2022/11/29.
//

import UIKit

class MinewTestViewController: UIViewController {
    
    private lazy var headerBackButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("View Close", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(self.viewCloseAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    @objc private func viewCloseAction(_ sender: UIButton){
        if let navi = self.navigationController {
            navi.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
    }
    
    private func initUI(){
        view.backgroundColor = .white
        view.addSubview(headerBackButton)
        
        headerBackButton.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(15)
        }
    }
}
