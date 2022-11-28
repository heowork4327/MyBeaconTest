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
    
    private var listCount = 0
    
    var beaconRegion : CLBeaconRegion!
    var beaconPeripheralData : NSDictionary!
    var peripheralManager : CBPeripheralManager!
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }

    private func initUI(){
        self.view.addSubview(self.listTableView)
        self.view.addSubview(self.setUpButton)
        
        self.listTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        self.setUpButton.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaInsets).inset(20)
            make.height.equalTo(35)
        }
    }
    
    @objc private func setupButtonAction(_ sender: UIButton){
        debugLog()
        
        startScanningForBeaconRegion(beaconRegion: getBeaconRegion(), beaconIdentity: getBeaconIdentity())
        
    }
    
    func getBeaconRegion() -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(uuid: UUID(uuidString: "e2c56db5-dffb-48d2-b060-d0f5a71096e0")!, identifier: "SomeThing")
        return beaconRegion
    }
    
    func getBeaconIdentity() -> CLBeaconIdentityConstraint{
        let identity = CLBeaconIdentityConstraint(uuid: UUID(uuidString: "e2c56db5-dffb-48d2-b060-d0f5a71096e0")!)
        return identity
    }
    
    func startScanningForBeaconRegion(beaconRegion: CLBeaconRegion, beaconIdentity: CLBeaconIdentityConstraint) {
        debugLog("beaconRegion = \n",beaconRegion,"beaconIdentity = \n",beaconIdentity)
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: beaconIdentity)
    }
    
}

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

extension MainViewController: CBPeripheralManagerDelegate, CLLocationManagerDelegate{
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn) {
               peripheralManager .startAdvertising(beaconPeripheralData as? [String : Any])
               print("Powered On")
           } else {
               peripheralManager .stopAdvertising()
               print("Not Powered On, or some other error")
           }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let beacon = beacons.last
        
        if beacons.count > 0 {
            
            debugLog("UUID = \(String(describing: beacon?.uuid))")
            debugLog("Major = \(String(describing: beacon?.major.stringValue))")
            debugLog("Minor = \(String(describing: beacon?.minor.stringValue))")
            debugLog("Accuracy = \(String(describing: beacon?.accuracy))")
            
            debugLog("RSSI = \(String(describing: beacon?.rssi))")
            
            if beacon?.proximity == CLProximity.unknown {
                debugLog("Unknown Proximity")
            } else if beacon?.proximity == CLProximity.immediate {
                debugLog("Immediate Proximity")
            } else if beacon?.proximity == CLProximity.near {
                debugLog("Near Proximity")
            } else if beacon?.proximity == CLProximity.far {
                debugLog("Far Proximity")
            }
            
            
        } else {
            debugLog("noop")
        }
        
        debugLog("Ranging")
    }
}
