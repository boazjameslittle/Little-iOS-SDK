//
//  TripCodesVC.swift
//  LittleSDK
//
//  Created by Boaz James on 27/09/2024.
//

import UIKit

class TripCodesVC: BaseVC {
    private let containerView: UIView = {
        let view = CardView()
        view.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .skyBlueLight
        view.alpha = 1
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let lblTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .littleLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Trip Codes".localized
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    private let btn: TextButton =  {
        let view = TextButton()
        view.setTitle("Dismiss".localized, for: .normal)
        view.setTitleColor(.themeColor, for: .normal)
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.inset = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return view
    }()
    
    private let am = SDKAllMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
    }
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.littleBlack.withAlphaComponent(0.5)
        self.view.addSubview(containerView)
        containerView.addSubview(lblTitle)
        containerView.addSubview(stackView)
        containerView.addSubview(btn)
    }
    
    override func setupSharedContraints() {
        // containerView
        NSLayoutConstraint.activate( [
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        // lblTitle
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            lblTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        ])
        
        // stackView
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 15)
        ])
        
        // btn
        NSLayoutConstraint.activate([
            btn.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor),
            btn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            btn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
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
        btn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewController)))
        self.containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dummyClick)))
    }
    
    private func setupData() {
        if !am.getTollChargeOTP().isEmpty {
            let tripCodeView = TripCodeView()
            tripCodeView.tag = 1
            tripCodeView.lblTitle.text = "Toll Code".localized
            tripCodeView.lblValue.text = am.getTollChargeOTP()
            stackView.addArrangedSubview(tripCodeView)
            
            tripCodeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showInfo)))
        }
        
        if !am.getEndTripOTP().isEmpty {
            let tripCodeView = TripCodeView()
            tripCodeView.tag = 2
            tripCodeView.lblTitle.text = "End Code".localized
            tripCodeView.lblValue.text = am.getEndTripOTP()
            stackView.addArrangedSubview(tripCodeView)
            
            tripCodeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showInfo)))
        }
        
        if !am.getParkingFeeOTP().isEmpty {
            let tripCodeView = TripCodeView()
            tripCodeView.tag = 3
            tripCodeView.lblTitle.text = "Parking".localized
            tripCodeView.lblValue.text = am.getParkingFeeOTP()
            stackView.addArrangedSubview(tripCodeView)
            
            tripCodeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showInfo)))
        }
    }
    
    @objc private func showInfo(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
                
        if tag == 1 {
            showMessageOTP(title: "Toll Charge Code:".localized + " \(am.getTollChargeOTP())", message: "Kindly give the driver this code ONLY if a toll charge was incurred at any particular point during this trip. Also make sure the amount is right.".localized)
        } else if tag == 2 {
            showMessageOTP(title: "End Trip Code:".localized + " \(am.getEndTripOTP() ?? "")", message: "An end trip code will be requested by your driver, in order to successfully END your trip. Please note that this code changes after every KM and only give to driver if he is ending at the right destination.".localized)
        } else if tag == 3 {
            showMessageOTP(title: "Parking Fee Code:".localized + " \(am.getParkingFeeOTP() ?? "")", message: "Kindly give the driver this code ONLY if a parking fee charge was incurred at any particular point during this trip. Also make sure the amount is right.".localized)
        }
        
    }
    
    private func showMessageOTP(title: String, message: String) {
        showWarningAlert(title: title, message: message)
    }
}
