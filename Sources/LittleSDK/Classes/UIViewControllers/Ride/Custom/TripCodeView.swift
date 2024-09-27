//
//  TripCodeView.swift
//  LittleSDK
//
//  Created by Boaz James on 27/09/2024.
//

import UIKit

class TripCodeView: CardView {
    let lblTitle: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .littleSecondaryLabelColor
        view.textAlignment = .center
        return view
    }()
    
    let lblValue: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.textColor = .littleLabelColor
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemBackground
        } else {
            self.backgroundColor = .littleCellBackgrounds
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.cornerRadius = 10
        
        self.addSubview(lblTitle)
        self.addSubview(lblValue)
        
        lblTitle.pinToView(parentView: self, constant: 10, top: false, bottom: false)
        lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).activate()
        
        lblValue.pinToView(parentView: self, constant: 15, top: false, bottom: false)
        NSLayoutConstraint.activate([
            lblValue.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 5),
            lblValue.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
    }
}


