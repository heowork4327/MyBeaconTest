//
//  DefaultTableViewCell.swift
//  MyBeaconTest
//
//  Created by nyeong heo on 2022/11/28.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    
    static let identifier = "DefaultTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        
        lb.text = "Title"
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 16)
        
        return  lb
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.cellUISetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellUISetup(){
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
