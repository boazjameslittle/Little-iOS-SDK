//
//  File.swift
//  
//
//  Created by Boaz James on 17/07/2023.
//

import UIKit
import SDWebImage

class AlertVC: BaseVC {
    var cancelAction: (() -> Void)?
    var actionButtonClosure: (() -> Void)?
    var textSubmissionAction: ((_ text: String) -> Void)?
    var message: String!
    var messageTitle: String!
    var actionButtonText: String?
    var showCancel: Bool!
    var dismissOnTap: Bool!
    var image: String!
    var dismissText: String!
    var placeholderText = ""
    var reasonRequired = false
    
    private let containerView: UIView = {
        let view = CardView()
        view.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .littleElevatedViews
        view.alpha = 1
        return view
    }()
    
    private var lblTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textColor = .littleLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let lblMessage: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textColor = .littleLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let imgView: UIImageView =  {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.tag = -1
    
        return view
    }()
    
    private let textfield: TextFieldWithPadding = {
        let view = TextFieldWithPadding()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        return view
        
    }()
    
    private let btnCancel: UIButton =  {
        let view = UIButton()
        view.setTitle("Dismiss".localized, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.littleLabelColor, for: .normal)
        view.setTitleColor(.gray, for: .highlighted)
        view.titleLabel?.font = .systemFont(ofSize: 15)
        view.backgroundColor = .clear
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .clear
            
            config.background = backgroundConfig
            
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 15)
                return outgoing
            }
            
            view.configuration = config
        } else {
            view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        
        return view
    }()
    
    private let btnAction: UIButton =  {
        let view = UIButton()
        view.setTitle("Ok".localized.localizedUppercase, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.systemBlue, for: .normal)
        view.setTitleColor(.gray, for: .highlighted)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.backgroundColor = .clear
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
            
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .clear
            
            config.background = backgroundConfig
            
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 14)
                return outgoing
            }
            
            view.configuration = config
        } else {
            view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }
        
        return view
    }()
    
    private let buttonStackView: UIStackView =  {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 0
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = messageTitle
        lblMessage.text = message
        
        btnCancel.isHidden = !showCancel
        
        btnCancel.setTitle(dismissText, for: .normal)
        btnAction.setTitle(actionButtonText, for: .normal)
        
        btnAction.isHidden = actionButtonClosure == nil && textSubmissionAction == nil
        btnCancel.isHidden = !showCancel
        
        if !image.isEmpty {
            imgView.sd_setImage(with: URL(string: image), placeholderImage: nil)
        }
        
        textfield.placeholder = placeholderText
        textfield.isHidden = placeholderText.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeStatusBarStyle(.lightContent)
    }
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.littleBlack.withAlphaComponent(0.5)
        self.view.addSubview(containerView)
        self.containerView.addSubview(lblTitle)
        self.containerView.addSubview(lblMessage)
        self.containerView.addSubview(imgView)
        self.containerView.addSubview(textfield)
        self.containerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(btnCancel)
        buttonStackView.addArrangedSubview(btnAction)
    }
    
    override func setupSharedContraints() {
        // containerView
        NSLayoutConstraint.activate( [
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        // lblTitle
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            lblTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        ])
        
        
        // lblMessage
        NSLayoutConstraint.activate([
            lblMessage.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            lblMessage.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor),
            lblMessage.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 10)
        ])
        
        // imgView
        if image.isEmpty {
            imgView.heightAnchor.constraint(equalToConstant: 0).activate()
        } else {
            imgView.applyAspectRatio(aspectRation: 16 / 9)
        }
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            imgView.topAnchor.constraint(equalTo: lblMessage.bottomAnchor, constant: image.isEmpty ? 0 : 10),
        ])
        
        NSLayoutConstraint.activate([
            textfield.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            textfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            textfield.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: placeholderText.isEmpty ? 0 : 10),
            textfield.heightAnchor.constraint(equalToConstant: placeholderText.isEmpty ? 0 : 44)
        ])
        
        // buttonStackView
        NSLayoutConstraint.activate([
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),
            buttonStackView.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: placeholderText.isEmpty ? 0 : 10),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        // btnCancel
//        btnCancel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).activate()
        NSLayoutConstraint.activate([
            btnCancel.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        // btnAction
//        btnAction.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).activate()
        NSLayoutConstraint.activate([
            btnAction.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
    }
    
    override func setupContraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        constraints.forEach({ $0.deactivate() })
        constraints.removeAll()
        
        if traitCollection.horizontalSizeClass == .compact {
            // containerView
            constraints.append(contentsOf: [
                containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
                containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            ])
        } else {
            // containerView
            constraints.append(contentsOf: [
                containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                containerView.widthAnchor.constraint(equalToConstant: 600),
            ])
        }
        
        constraints.forEach({ $0.activate() })
    }
    
    override func setupGestures() {
        btnCancel.addTarget(self, action: #selector(didCancel), for: .touchUpInside)
        btnAction.addTarget(self, action: #selector(didAccept), for: .touchUpInside)
        
        if dismissOnTap {
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewController)))
        }
        
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dummyClick)))
    }
    
    @objc private func didAccept() {
        guard let text = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if reasonRequired && !placeholderText.isEmpty && text.isEmpty {
            showAlerts(title: "", message: String(format: "%@ is required".localized, placeholderText))
            return
        }
        
        self.dismiss(animated: true) {
            if !self.placeholderText.isEmpty {
                self.textSubmissionAction?(text)
            } else {
                self.actionButtonClosure?()
            }
        }
        
    }
    
    @objc private func didCancel() {
        self.dismiss(animated: true) {
            self.cancelAction?()
        }
        
    }
}
