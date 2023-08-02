//
//  File.swift
//  
//
//  Created by Boaz James on 02/08/2023.
//

import UIKit
import NVActivityIndicatorView

class MPESAPaymentView: UIViewController {

    // MARK: - Properties
    
    let am = SDKAllMethods()
    let hc = SDKHandleCalls()
    
    private let imgContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let imgStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.spacing = 20
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        return view
    }()
    
    private let imgLogo: UIImageView =  {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tag = 1
        return view
    }()
    
    var activityView: NVActivityIndicatorView!
    var lblWaiting: UILabel!
    var lblAmount: UILabel!
    var scrollView: UIScrollView!
    var contentStackView: UIStackView!
    var opt1View: UIView!
    var lblOpt1: UILabel!
    var lblInstructions1: UILabel!
    var btnResendPrompt: UIButton!
    var btnBack: UIButton!
    var opt2View: UIView!
    var lblOpt2: UILabel!
    var lblInstructions2: UILabel!
    
    var proceedAction: (() -> Void)?
    var backAction: (() -> Void)?
    var resendAction: (() -> Void)?
    
    var wallet: Balance?
    var towallet: Balance?
    
    var amount: String = "0"
    var timer : Timer?
    private var totalAmount: Double = 0
    
    var requestUniqueID = ""
    // MARK: - Init
    
    private var walletActionData = ""
    private var walletActionType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack = UIButton()
        btnBack.viewCornerRadius = 20
        btnBack.backgroundColor = .littleElevatedViews
        btnBack.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 15.0)
        btnBack.setTitle("Back".localized, for: .normal)
        btnBack.setTitleColor(.littleBlue, for: .normal)
        btnBack.borderWidth = 2
        btnBack.borderColor = .littleBlue
        btnBack.addTarget(self, action: #selector(btnBackPressed(_:)), for: .touchUpInside)
        
        view.addSubview(btnBack)
        
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        btnBack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        btnBack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setupScrollPage()
        configureUI()
        
        let balance = towallet?.balance ?? 0
        totalAmount = (Double(amount) ?? 0)
        
        lblAmount.text = SDKUtils.currencyFormatWithoutZero(totalAmount, currencyCode: am.getGLOBALCURRENCY() ?? "KES")
        
        opt2View.isHidden = true
        
        if let walletAction = wallet?.walletAction?.first, let walletActionType = walletAction.actionType {
            self.walletActionType = walletActionType
            walletActionData = walletAction.actionData ?? ""
            if walletActionType.equalsIgnoringCase(SDKConstants.WALLET_ACTION_TYPE_FORM_ID) {
                btnResendPrompt.setTitle("Resend Prompt".localized, for: .normal)
                lblInstructions1.text = nil
                
                if wallet?.walletID?.equalsIgnoringCase("MPESA") == true {
                    opt2View.isHidden = false
                    lblOpt1.text = "Option 1".localized
                }
                
                loadWalletCall()
            } else if walletActionType.equalsIgnoringCase(SDKConstants.WALLET_ACTION_TYPE_DIAL) {
                btnResendPrompt.setTitle("Redial USSD".localized, for: .normal)
                lblInstructions1.text = "Kindly dial the USSD prompted below to complete transaction".localized
                dialUssd()
                addExternalRequest()
            }
        }
        
        if let paymentURL = wallet?.walletAction?.first?.paymentURL {
            imgLogo.isHidden = false
            imgLogo.sd_setImage(with: URL(string: paymentURL)) { _,_,_,_  in
                
            }
        } else {
            imgLogo.isHidden = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopPaymentStatusTimer()
    }
    
    deinit {
        stopPaymentStatusTimer()
    }
    
    // MARK: - Visual Setup
    
    func configureUI() {
        
        view.backgroundColor = .littleElevatedViews
        
        contentStackView.addArrangedSubview(imgContainerView)
        imgContainerView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).activate()
        
        imgContainerView.addSubview(imgStackView)
        
        imgStackView.pinToView(parentView: imgContainerView, constant: 50, top: false, bottom: false)
        NSLayoutConstraint.activate([
            imgStackView.topAnchor.constraint(equalTo: imgContainerView.topAnchor, constant: 10),
            imgStackView.bottomAnchor.constraint(equalTo: imgContainerView.bottomAnchor, constant: 0),
        ])
        
        activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.circleStrokeSpin, color:  .littleBlue)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.startAnimating()
        
        imgStackView.addArrangedSubview(activityView)
        
        imgStackView.addArrangedSubview(imgLogo)
        
        NSLayoutConstraint.activate([
            imgLogo.widthAnchor.constraint(equalTo: imgStackView.widthAnchor),
            imgLogo.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        lblWaiting = UILabel()
        lblWaiting.textColor = .littleLabelColor
        lblWaiting.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20.0)
        lblWaiting.numberOfLines = 0
        lblWaiting.textAlignment = .center
        lblWaiting.text = "Waiting for payment".localized
        lblWaiting.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        
        contentStackView.addArrangedSubview(lblWaiting)
        
        lblAmount = UILabel()
        lblAmount.textColor = .littleLabelColor
        lblAmount.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30.0)
        lblAmount.numberOfLines = 0
        lblAmount.textAlignment = .center
//        lblAmount.text = amount ?? "KES 0.00"
        lblAmount.text = "_ _"
        lblAmount.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        
        contentStackView.addArrangedSubview(lblAmount)
        
        opt1View = UIView()
        opt1View.backgroundColor = .littleElevatedViews
        opt1View.viewCornerRadius = 10
        opt1View.dropShadow()
        opt1View.heightAnchor.constraint(equalToConstant: 160).isActive = true
        opt1View.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        
        contentStackView.addArrangedSubview(opt1View)
        
        lblOpt1 = UILabel()
        lblOpt1.textColor = .littleLabelColor
        lblOpt1.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16.0)
        lblOpt1.numberOfLines = 0
        lblOpt1.textAlignment = .center
        
        opt1View.addSubview(lblOpt1)
        
        lblOpt1.translatesAutoresizingMaskIntoConstraints = false
        lblOpt1.leftAnchor.constraint(equalTo: opt1View.leftAnchor, constant: 20).isActive = true
        lblOpt1.rightAnchor.constraint(equalTo: opt1View.rightAnchor, constant: -20).isActive = true
        lblOpt1.topAnchor.constraint(equalTo: opt1View.topAnchor, constant: 20).isActive = true
        
        lblInstructions1 = UILabel()
        lblInstructions1.textColor = .lightGray
        lblInstructions1.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16.0)
        lblInstructions1.numberOfLines = 0
        lblInstructions1.textAlignment = .center
//        lblInstructions1.text = "You will receive an MPESA prompt to enter your PIN shortly.".localized
        
        opt1View.addSubview(lblInstructions1)
        
        lblInstructions1.translatesAutoresizingMaskIntoConstraints = false
        lblInstructions1.leftAnchor.constraint(equalTo: opt1View.leftAnchor, constant: 20).isActive = true
        lblInstructions1.rightAnchor.constraint(equalTo: opt1View.rightAnchor, constant: -20).isActive = true
        lblInstructions1.topAnchor.constraint(equalTo: lblOpt1.bottomAnchor, constant: 20).isActive = true
        
        btnResendPrompt = UIButton()
        btnResendPrompt.viewCornerRadius = 20
        btnResendPrompt.backgroundColor = UIColor(named: "littleBlue")
        btnResendPrompt.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 15.0)
//        btnResendPrompt.setTitle("Resend MPESA Prompt".localized, for: .normal)
        btnResendPrompt.setTitleColor(UIColor(named: "littleWhite"), for: .normal)
        btnResendPrompt.addTarget(self, action: #selector(btnResendPressed(_:)), for: .touchUpInside)
        
        opt1View.addSubview(btnResendPrompt)
        
        btnResendPrompt.translatesAutoresizingMaskIntoConstraints = false
        btnResendPrompt.leftAnchor.constraint(equalTo: opt1View.leftAnchor, constant: 20).isActive = true
        btnResendPrompt.rightAnchor.constraint(equalTo: opt1View.rightAnchor, constant: -20).isActive = true
        btnResendPrompt.topAnchor.constraint(equalTo: lblInstructions1.bottomAnchor, constant: 10).isActive = true
        btnResendPrompt.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        opt2View = UIView()
        opt2View.backgroundColor = .littleElevatedViews
        opt2View.viewCornerRadius = 10
        opt2View.dropShadow()
        opt2View.heightAnchor.constraint(equalToConstant: 200).isActive = true
        opt2View.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        
        contentStackView.addArrangedSubview(opt2View)
        
        lblOpt2 = UILabel()
        lblOpt2.textColor = .littleLabelColor
        lblOpt2.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16.0)
        lblOpt2.numberOfLines = 0
        lblOpt2.textAlignment = .center
        lblOpt2.text = "Option 2".localized
        
        opt2View.addSubview(lblOpt2)
        
        lblOpt2.translatesAutoresizingMaskIntoConstraints = false
        lblOpt2.leftAnchor.constraint(equalTo: opt2View.leftAnchor, constant: 20).isActive = true
        lblOpt2.rightAnchor.constraint(equalTo: opt2View.rightAnchor, constant: -20).isActive = true
        lblOpt2.topAnchor.constraint(equalTo: opt2View.topAnchor, constant: 20).isActive = true
        
        lblInstructions2 = UILabel()
        lblInstructions2.textColor = .lightGray
        lblInstructions2.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16.0)
        lblInstructions2.numberOfLines = 0
        lblInstructions2.textAlignment = .center
        lblInstructions2.text = "1. Go to your MPESA menu 2. Select Paybill 3. Enter Business Number 309999 4. Enter Account Number as COMMON 5. Enter the Amount 6. Enter your MPESA PIN and send".localized
        
        opt2View.addSubview(lblInstructions2)
        
        lblInstructions2.translatesAutoresizingMaskIntoConstraints = false
        lblInstructions2.leftAnchor.constraint(equalTo: opt2View.leftAnchor, constant: 20).isActive = true
        lblInstructions2.rightAnchor.constraint(equalTo: opt2View.rightAnchor, constant: -20).isActive = true
        lblInstructions2.topAnchor.constraint(equalTo: lblOpt2.bottomAnchor, constant: 20).isActive = true
    }
    
    func setupScrollPage() {
            
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)

        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: btnBack.topAnchor, constant: -20).isActive = true

        contentStackView = UIStackView()
        contentStackView.axis  = NSLayoutConstraint.Axis.vertical
        contentStackView.distribution  = UIStackView.Distribution.equalSpacing
        contentStackView.alignment = UIStackView.Alignment.center
        contentStackView.spacing = 20

        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentStackView)

        contentStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
    }
    
    // MARK: - Handlers
    
    @objc func btnResendPressed(_ sender: UIButton) {
        if walletActionType.equalsIgnoringCase(SDKConstants.WALLET_ACTION_TYPE_FORM_ID) {
            loadWalletCall()
        } else if walletActionType.equalsIgnoringCase(SDKConstants.WALLET_ACTION_TYPE_DIAL) {
            dialUssd()
        }
    }
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.backAction?()
        }
    }
    
    private func dialUssd() {
        proceedCall(phone: walletActionData)
    }
    
    func loadWalletCall() {
        
        stopPaymentStatusTimer()
        
        self.view.createLoadingNormal()
        
        resendAction?()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadLoadNewWallet),name:NSNotification.Name(rawValue: "LOADWALLETJSONData"), object: nil)
        
        var params = SDKUtils.commonJsonTags(formId: walletActionData, uniqueId: requestUniqueID)
        params["LOADWALLET"] = [
            "WalletID": wallet?.walletID ?? "",
            "WalletUniqueID": wallet?.walletUniqueID ?? "",
            "Amount": totalAmount,
            "ToWalletName": towallet?.walletName ?? "",
            "ToWalletID": towallet?.walletID ?? ""
        ] as [String : Any]
        
        hc.makeServerCall(sb: params.toJsonString(), method: "LOADWALLETJSONData", switchnum: SDKConstants.REMOVEARRAYRESPONSE)
    }
    
    @objc func loadLoadNewWallet(_ notification: NSNotification) {
        self.view.removeAnimation()
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "LOADWALLETJSONData"), object: nil)
        
        if let userInfo = notification.userInfo, let data = userInfo["data"] as? Data {
            do {
                let response = try JSONDecoder().decode(CommonResponseData.self, from: data)
                if response.status == "000" {
                    lblInstructions1.text = response.message
                    addExternalRequest()
                } else {
                    let message = response.message ?? ""
                    self.showWarningAlert(message: message.isEmpty ? "Something went wrong.".localized : message, dismissOnTap: false, actionButtonText: "Dismiss".localized, showCancel: false) {
                        self.dismiss(animated: true) {
                            self.backAction?()
                        }
                    }
                }
            } catch (let error) {
                self.showGeneralErrorAlert()
                printVal(object: "error: \(error.localizedDescription)")
            }
        }
    }
    
    private func addExternalRequest() {
        
        view.createLoadingNormal()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadAddExternalRequest),name:NSNotification.Name(rawValue: "AddExternalRequestSimple"), object: nil)
                
        var params = SDKUtils.commonJsonTags(formId: "ADDEXTERNALREQUESTS", uniqueId: requestUniqueID)
        
        let subParams: [String: Any] = [
            "Amount": totalAmount,
            "Message": "",
            "FormID": "",
            "UniqueID": requestUniqueID,
            "ActionType": walletActionType,
            "ActionData": walletActionData,
            "WalletID": wallet?.walletID ?? "",
            "WalletName": wallet?.walletName ?? "",
            "WalletUniqueID": wallet?.walletUniqueID ?? ""
        ]
        
        params["AddExternalRequests"] = subParams
                        
        hc.makeServerCall(sb: params.toJsonString(), method: "AddExternalRequestSimple", switchnum: SDKConstants.REMOVEARRAYRESPONSE)
    }
    
    @objc private func loadAddExternalRequest(_ notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "AddExternalRequestSimple"), object: nil)
        view.removeAnimation()
                
        if let userInfo = notification.userInfo, let data = userInfo["data"] as? Data {
            do {
                let response = try JSONDecoder().decode(CommonResponseData.self, from: data)
                if response.status == "000" {
                   startPaymentStatusTimer()
                } else {
                    let message = response.message ?? ""
                    self.showWarningAlert(message: message.isEmpty ? "Something went wrong.".localized : message, dismissOnTap: false, actionButtonText: "Dismiss".localized, showCancel: false) {
                        self.dismiss(animated: true) {
                            self.backAction?()
                        }
                    }
                }
            } catch (let error) {
                self.showGeneralErrorAlert()
                printVal(object: "error: \(error.localizedDescription)")
            }
        }
        
    }
    
    @objc private func externalRequest() {
                
        NotificationCenter.default.addObserver(self, selector: #selector(loadExternalRequest),name:NSNotification.Name(rawValue: "ExternalRequestSimple"), object: nil)
                
        var params = SDKUtils.commonJsonTags(formId: "EXTERNALREQUESTS", uniqueId: requestUniqueID)
        
        let subParams: [String: Any] = [
            "Amount": totalAmount,
            "Message": "",
            "FormID": "",
            "UniqueID": requestUniqueID,
            "ActionType": walletActionType,
            "ActionData": walletActionData,
            "WalletID": wallet?.walletID ?? "",
            "WalletName": wallet?.walletName ?? "",
            "WalletUniqueID": wallet?.walletUniqueID ?? ""
        ]
        
        params["ExternalRequests"] = subParams
                        
        hc.makeServerCall(sb: params.toJsonString(), method: "ExternalRequestSimple", switchnum: SDKConstants.REMOVEARRAYRESPONSE)
    }
    
    @objc private func loadExternalRequest(_ notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "ExternalRequestSimple"), object: nil)
        view.removeAnimation()
                
        if let userInfo = notification.userInfo, let data = userInfo["data"] as? Data {
            do {
                let response = try JSONDecoder().decode(CommonResponseData.self, from: data)
                if response.status == "000" {
                    self.dismiss(animated: true) {
                        self.proceedAction?()
                    }
                }
            } catch (let error) {
                printVal(object: "error: \(error.localizedDescription)")
            }
        }
        
    }
    
    private func startPaymentStatusTimer() {
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(externalRequest), userInfo: nil, repeats: true)
    }
    
    private func stopPaymentStatusTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

}
