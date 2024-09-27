//
//  Button .swift
//  LittleSDK
//
//  Created by Boaz James on 27/09/2024.
//

import Foundation
import UIKit

class TextButton: UIButton {
    
    var font = UIFont.systemFont(ofSize: 16, weight: .medium) {
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
    
    var inset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15) {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        if #available(iOS 15.0, *) {
            self.setTitleColor(.tintColor, for: .normal)
        } else {
            self.setTitleColor(.themeColor, for: .normal)
        }
        self.setTitleColor(.darkGray, for: .highlighted)
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 15.0, *) {
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .clear
            
            var config = UIButton.Configuration.plain()
            config.contentInsets = inset
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = self.font
                return outgoing
            }
            
            config.background = backgroundConfig
            
            self.configuration = config
        } else {
            self.titleLabel?.font = font
            self.contentEdgeInsets = UIEdgeInsets(top: inset.top, left: inset.leading, bottom: inset.trailing, right: inset.trailing)
        }
    }
}
