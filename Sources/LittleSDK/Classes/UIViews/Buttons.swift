//
//  File.swift
//  
//
//  Created by Boaz James on 28/08/2023.
//

import UIKit

class OutlinedButton: UIButton {
    
    var inset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) {
        didSet {
            if #available(iOS 15.0, *) {
                var config = self.configuration
                config?.contentInsets = inset
                
                self.configuration = config
            } else {
                self.contentEdgeInsets = UIEdgeInsets(top: inset.top, left: inset.leading, bottom: inset.trailing, right: inset.trailing)
            }
        }
    }
    
    private var height: CGFloat = 50
    
    var font = UIFont.systemFont(ofSize: 16) {
        didSet {
            if #available(iOS 15.0, *) {
                var config = self.configuration
                config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = self.font
                    return outgoing
                }
                
                self.configuration = config
            } else {
                self.titleLabel?.font = font
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    init(height: CGFloat) {
        self.height = height
        super.init(frame: .zero)
        setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.setTitleColor(.themeColor, for: .normal)
        self.setTitleColor(.darkGray, for: .highlighted)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).activate()
        self.layer.borderColor = UIColor.themeColor.cgColor
        self.layer.borderWidth = 1
        
        if #available(iOS 15.0, *) {
            
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .clear
            
            var config = UIButton.Configuration.plain()
            config.imagePlacement = .leading
            config.imagePadding = 5
            config.background = backgroundConfig
            
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = self.font
                return outgoing
            }
            
            config.contentInsets = inset
            
            self.configuration = config
        } else {
            self.titleLabel?.font = font
            self.contentEdgeInsets = UIEdgeInsets(top: inset.top, left: inset.leading, bottom: inset.trailing, right: inset.trailing)
        }
    }
}
