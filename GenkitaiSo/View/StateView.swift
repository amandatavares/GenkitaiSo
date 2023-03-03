//
//  StateView.swift
//  GenkitaiSo
//
//  Created by amanda.tavares on 03/03/23.
//

import UIKit

class StateView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(origin: CGPoint(x: self.frame.width/2-180, y:  self.frame.height/2-100), size: CGSize(width: 300, height: 100)))
        label.numberOfLines = 0
        label.textColor = UIColor.label
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.6)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
      
        self.addSubview(label)
    }
    

}
