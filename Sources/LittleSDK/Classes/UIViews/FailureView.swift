//
//  File.swift
//  
//
//  Created by Boaz James on 28/08/2023.
//

import UIKit

class FailureView: UIView {
    private let containerView: UIView =  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private(set) var imgView: UIImageView =  {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = getImage(named: "icon_ok_not")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let lblTitle: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.textColor = .littleLabelColor
        view.textAlignment = .center
        view.numberOfLines = 1
        view.text = "Failed".localized
        
        return view
    }()
    
    private(set) var lblMessage: UILabel =  {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 16)
        view.textColor = .littleLabelColor
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "Failed".localized
        
        return view
    }()
    
    private(set) var btn: OutlinedButton =  {
        let view = OutlinedButton(height: 38)
        view.setTitle("Back".localized, for: .normal)
        view.borderColor = .littleBlue
        view.viewCornerRadius = 19
        view.setTitleColor(.littleBlue, for: .normal)
        view.inset = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40)
        
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
        self.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemBackground
        } else {
            self.backgroundColor = .littleWhite
        }
        
        self.addSubview(containerView)
        containerView.addSubview(imgView)
        containerView.addSubview(lblTitle)
        containerView.addSubview(lblMessage)
        containerView.addSubview(btn)
        
        containerView.pinToView(parentView: self, top: false, bottom: false)
        containerView.centerOnView(parentView: self, centerX: false)
        
        imgView.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imgView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 80)
        ])
                
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 20),
            lblTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            lblTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
                
        NSLayoutConstraint.activate([
            lblMessage.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 5),
            lblMessage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            lblMessage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
        ])
                
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: lblMessage.bottomAnchor, constant: 30),
            btn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            btn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
    }
}
