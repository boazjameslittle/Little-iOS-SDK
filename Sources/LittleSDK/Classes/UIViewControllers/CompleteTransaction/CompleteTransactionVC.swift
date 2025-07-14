//
//  CompleteTransactionVC.swift
//  LittleSDK
//
//  Created by Boaz James on 08/04/2025.
//

import UIKit

class CompleteTransactionVC: BaseVC {
    private let hc = SDKHandleCalls()
    private let littleHandleCalls = LittleHandleCalls()
    private let am = SDKAllMethods()
    
    var transactionRef = ""
        
    var proceedAction: ((_ toWhere: ToWhere) -> Void)?
    
    private var toWhere: ToWhere = .deliveries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPendingTransaction()
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.backgroundColor = .clear
    }
    
    override func dismissViewController() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LITTLE_SDK_CLOSED"), object: nil, userInfo: nil)
        
        navigationController?.dismiss(animated: true)
    }
    
    private func getPendingTransaction() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadPendingTransaction),name:NSNotification.Name(rawValue: "GetSDKPendingTransactionsSimple"), object: nil)
        
        showLoadingView()
        
        printVal(object: "getPendingTransaction transactionRef: \(transactionRef)")
        
        var params = SDKUtils.commonJsonTags(formId: "GetSDKPendingTransactions")
        params["TrxInfo"] = [
            "TrxRef": transactionRef
        ]
        
        let dataToSend = (try? SDKUtils.dictionaryToJson(from: params)) ?? ""
        
        littleHandleCalls.makeServerCall(sb: dataToSend, method: "GetSDKPendingTransactionsSimple", switchnum: SDKConstants.REMOVEARRAYRESPONSE)
    }
    
    @objc private func loadPendingTransaction(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name(rawValue: "GetSDKPendingTransactionsSimple"), object: nil)
        
        if let userInfo = notification.userInfo, let data = userInfo["data"] as? Data {
            do {
                let response = try JSONDecoder().decode(PendingTransactionResponse.self, from: data)
                if response.status == "000" {
                    if let trxDetails = response.trxDetails?.first, let status = trxDetails.status, status.equalsIgnoringCase("PENDING") {
                        completeTransaction(requestBody: trxDetails.transactionRequest ?? "")
                    } else {
                        hideLoadingView()
                        self.showMessageAlert(message: "No pending transaction".localized)
                    }
                } else {
                    hideLoadingView()
                    self.showMessageAlert(message: response.message ??  "\n\("Ooops, something went wrong.".localized)\n")
                }
                
            } catch (let error) {
                hideLoadingView()
                showMyGeneralErrorAlert()
                printVal(object: "error: \(error.localizedDescription)")
            }
        } else {
            hideLoadingView()
            showMyGeneralErrorAlert()
        }
        
    }
    
    private func completeTransaction(requestBody: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadCompleteTransaction),name:NSNotification.Name(rawValue: "CompleteTransaction"), object: nil)
        
        printVal(object: "CompleteTransaction request: \(requestBody)")
                
        if requestBody.containsIgnoringCase("MOVIETICKETS") {
            toWhere = .movies
        } else if requestBody.containsIgnoringCase("RESTAURANTDELIVERYITEMS") {
            toWhere = .deliveries
        }
                
        hc.makeServerCall(sb: requestBody, method: "CompleteTransaction", switchnum: SDKConstants.REMOVEARRAYRESPONSE)
    }
    
    @objc private func loadCompleteTransaction(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name(rawValue: "CompleteTransaction"), object: nil)
        
        hideLoadingView()
        
        if let userInfo = notification.userInfo, let data = userInfo["data"] as? Data {
            do {
                let response = try JSONDecoder().decode(OrderResponseElement.self, from: data)
                if response.status == "000" {
                    var message = response.message ?? ""
                    
                    if message.isEmpty {
                        if toWhere == .deliveries {
                            message = "Order placed successfully".localized
                        } else {
                            message = "Ticket(s) booked successfully".localized
                        }
                    }
                    
                    self.showWarningAlert(message: message, dismissOnTap: false, showCancel: false) {
                        self.am.saveFromConfirmOrder(data: true)
                        self.proceedAction?(self.toWhere)
                    }
                } else {
                    self.showMessageAlert(message: response.message ??  "\n\("Ooops, something went wrong.".localized)\n")
                }
                
            } catch (let error) {
                showMyGeneralErrorAlert()
                printVal(object: "error: \(error.localizedDescription)")
            }
        } else {
            showMyGeneralErrorAlert()
        }
        
    }
    
    private func showMyGeneralErrorAlert() {
        self.showWarningAlert(message: "Something went wrong.".localized, dismissOnTap: false, showCancel: false) {
            self.dismissViewController()
        }
    }
    
    private func showMessageAlert(message: String) {
        self.showWarningAlert(message: message, dismissOnTap: false, showCancel: false) {
            self.dismissViewController()
        }
    }
}
