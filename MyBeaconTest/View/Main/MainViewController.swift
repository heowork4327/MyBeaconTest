//
//  ViewController.swift
//  MyBeaconTest
//
//  Created by nyeong heo on 2022/11/28.
//

import UIKit
import CoreLocation
import CoreBluetooth
import SnapKit

class MainViewController: UIViewController {
    
    private lazy var listTableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.identifier)
        tv.layer.borderWidth = 2
        tv.layer.borderColor = UIColor.red.cgColor
        return tv
    }()
    
    private lazy var setUpButton: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("iBeacon Set Up", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(self.setupButtonAction(_:)), for: .touchUpInside)
        return btn
        
    }()
    
    private lazy var locationSetButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Location Set Up", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(self.locationSetAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var minewViewButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Minew SDK View Call", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(self.minewViewCallAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    private var listCount = 0
    
    /* 테스트용 uuid */
    //    let uuid = UUID(uuidString: "e2c56db5-dffb-48d2-b060-d0f5a71096e0")!
    //    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let uuid = UUID(uuidString: "2959035C-D67F-47F5-82C9-08FB76E039C1")!
    
    
    /* 비콘을 확인 할때 필요*/
    var beaconRegion : CLBeaconRegion!
    var locationManager : CLLocationManager!
    
    
    /* 아이폰으로 아이비콘 테스트 할시 */
    var beaconPeripheralData: NSDictionary!
    
    var peripheralManager : CBPeripheralManager!
    
    var localBeacon: CLBeaconRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        
        self.view.backgroundColor = .gray
    }
    
    private func initUI(){
        self.view.addSubview(self.listTableView)
        self.view.addSubview(self.setUpButton)
        self.view.addSubview(self.locationSetButton)
        self.view.addSubview(minewViewButton)
        self.listTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(100)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
        
        self.setUpButton.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(35)
        }
        
        locationSetButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(setUpButton.snp.right).inset(-20)
            make.height.equalTo(35)
        }
        
        minewViewButton.snp.makeConstraints { make in
            make.top.equalTo(locationSetButton.snp.top)
            make.left.equalTo(locationSetButton.snp.right).offset(20)
        }
    }
    
    func getBeaconRegion() -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "a")
        return beaconRegion
    }
    
    func getBeaconIdentity() -> CLBeaconIdentityConstraint{
        let identity = CLBeaconIdentityConstraint(uuid: uuid)
        return identity
    }
    
    func startScanningForBeaconRegion(beaconRegion: CLBeaconRegion, beaconIdentity: CLBeaconIdentityConstraint) {
        debugLog("beaconRegion = \n",beaconRegion,"beaconIdentity = \n",beaconIdentity)
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: beaconIdentity)
        
    }
    
}

// button Action
extension MainViewController {
    
    @objc private func locationSetAction(_ sender: UIButton){
        //        locationManager = CLLocationManager.init()
        //        locationManager.delegate = self
        //        locationManager.requestLocation()
        //        locationManager.requestWhenInUseAuthorization()
        
        //        self.peripheralManagerDidUpdateState(self.peripheralManager)
        
        initLocalBeacon()
    }
    
    @objc private func setupButtonAction(_ sender: UIButton){
        debugLog()
        startScanningForBeaconRegion(beaconRegion: getBeaconRegion(), beaconIdentity: getBeaconIdentity())
    }
    
    @objc private func minewViewCallAction(_ sender: UIButton){
        let vc = MinewTestViewController()
        
        if let navi = self.navigationController {
            navi.pushViewController(vc, animated: true)
        } else {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            
            self.present(vc, animated: true)
        }
    }
    
}

//감지된 비콘의 정보를 뛰어줄 테이블
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as? DefaultTableViewCell {
            
            return cell
        }
        return UITableViewCell()
    }
}

//위치딜리게이트
extension MainViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanningForBeaconRegion(beaconRegion: getBeaconRegion(), beaconIdentity: getBeaconIdentity())
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        let beacon = beacons.last
        
        if beacons.count > 0 {
            
            debugLog("UUID = \(String(describing: beacon?.uuid))","Major = \(String(describing: beacon?.major.stringValue))","Minor = \(String(describing: beacon?.minor.stringValue))","Accuracy = \(String(describing: beacon?.accuracy))","RSSI = \(String(describing: beacon?.rssi))")
            
            if beacon?.proximity == CLProximity.unknown {
                debugLog("Unknown Proximity")
            } else if beacon?.proximity == CLProximity.immediate {
                debugLog("Immediate Proximity")
            } else if beacon?.proximity == CLProximity.near {
                debugLog("Near Proximity")
            } else if beacon?.proximity == CLProximity.far {
                debugLog("Far Proximity")
            }
            
            debugLog("=======================================================\n\n\n\n 비콘 감지된 갯수 = \(beacons.count)")
        } else {
            debugLog("noop")
        }
    }
}

// 아이폰 디바이스를 아이비콘으로 활용하여 테스트
extension MainViewController: CBPeripheralManagerDelegate{
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
        
    }
    private func initLocalBeacon() {
        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        let localBeaconUUID = "2959035C-D67F-47F5-82C9-08FB76E039C1"
        let localBeaconMajor: CLBeaconMajorValue = 0123
        let localBeaconMinor: CLBeaconMinorValue = 0456
        
        
        let uuid = UUID(uuidString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "idenKey")
        
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn) {
            debugLog(beaconPeripheralData.allKeys)
            peripheralManager .startAdvertising(beaconPeripheralData as? [String : Any])
            debugLog("Powered On")
        } else {
            peripheralManager .stopAdvertising()
            debugLog("Not Powered On, or some other error")
        }
    }
}
