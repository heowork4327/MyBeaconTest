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
    
    private lazy var minewConnectButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Minew 연결시도", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(self.minewConnectAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    var iBeacon: MinewBeacon? = nil
    var minewManager: MinewBeaconManager = MinewBeaconManager.sharedInstance()
    //    var minewManager: MinewBeaconManager = MinewBeaconManager.sharedInstance()
    var minewBeaconConnection: MinewBeaconConnection!
    var minewBeaconSetting: MinewBeaconSetting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        minewInit()
    }
    
    private func initUI(){
        view.backgroundColor = .white
        view.addSubview(headerBackButton)
        view.addSubview(minewConnectButton)
        
        headerBackButton.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(15)
        }
        
        minewConnectButton.snp.makeConstraints { make in
            make.top.equalTo(headerBackButton.snp.bottom).offset(100)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    private func minewInit(){
                minewManager.delegate = self
    }
}

extension MinewTestViewController {
    
    @objc private func viewCloseAction(_ sender: UIButton){
        if let navi = self.navigationController {
            navi.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func minewConnectAction(_ sender: UIButton){
        debugLog()
        //        minewManager.stopScan()
        //        minewManager.startScan([], backgroundSupport: <#T##Bool#>)
        //        minewManager.startScan(["2959035C-D67F-47F5-82C9-08FB76E039C1","asdfasdf-asdf-asdf-asdf-asdfasdfasdf"], backgroundSupport: true)
        minewManager.startScan()
        
    }
}


extension MinewTestViewController: MinewBeaconManagerDelegate {
    
    func minewBeaconManager(_ manager: MinewBeaconManager!, appear beacons: [MinewBeacon]!) {
        debugLog()
    }
    
    func minewBeaconManager(_ manager: MinewBeaconManager!, disappear beacons: [MinewBeacon]!) {
        debugLog()
    }
    
    func minewBeaconManager(_ manager: MinewBeaconManager!, didUpdate state: BluetoothState) {
        debugLog()
    }
    
    func minewBeaconManager(_ manager: MinewBeaconManager!, didRangeBeacons beacons: [MinewBeacon]!) {
        debugLog(beacons.count,beacons.first?.name,beacons.first?.uuid,":major:",beacons.first?.major,":minor:",beacons.first?.minor)
    }
}
