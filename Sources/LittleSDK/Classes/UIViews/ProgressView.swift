//
//  ProgressView.swift
//  LittleSDK
//
//  Created by Boaz James on 08/04/2025.
//

import UIKit

@IBDesignable
class ProgressView: UIView {
    var title = "" {
        didSet {
            self.lblTitle.text = title
            if title.isEmpty {
                self.hideTitle()
            } else {
                self.showTitle()
            }
        }
    }
    
    private var container: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .themeColor
        return view
    }()
    
    private var lblTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .littleWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.style = .whiteLarge
        return indicatorView
    }()
    
    private var blurView: UIView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
            view.effect = blurEffect
            return view
        } else {
            let blurEffect = UIBlurEffect(style: .extraLight)
            view.effect = blurEffect
            return view
        }
    }()
    
    private var indicatorTopConstraintAnchor: NSLayoutConstraint!
    private var indicatorBottomConstraintAnchor: NSLayoutConstraint!
    private var labelTopConstraintAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        self.addSubview(blurView)
        self.addSubview(container)
        container.addSubview(lblTitle)
        
        container.addSubview(indicatorView)
        indicatorView.startAnimating()
        
        blurView.pinToView(parentView: self)
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        labelTopConstraintAnchor = lblTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 20)
        
        NSLayoutConstraint.activate([
            labelTopConstraintAnchor,
            lblTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            lblTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15)
        ])
        
        indicatorTopConstraintAnchor = indicatorView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 15)
        indicatorBottomConstraintAnchor = indicatorView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        NSLayoutConstraint.activate([
            indicatorTopConstraintAnchor,
            indicatorView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            indicatorBottomConstraintAnchor
        ])
    }
    
    private func showTitle() {
        labelTopConstraintAnchor.constant = 20
        indicatorTopConstraintAnchor.constant = 15
        indicatorBottomConstraintAnchor.constant = -20
    }
    
    private func hideTitle() {
        labelTopConstraintAnchor.constant = 0
        indicatorTopConstraintAnchor.constant = 40
        indicatorBottomConstraintAnchor.constant = -40
    }
}
