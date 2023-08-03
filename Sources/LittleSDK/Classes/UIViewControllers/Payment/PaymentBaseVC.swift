//
//  File.swift
//  
//
//  Created by Boaz James on 02/08/2023.
//

import UIKit

public class PaymentBaseVC: BaseVC {
    private var am = SDKAllMethods()
    var pin = ""
    
    var paymentUniqueID = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    
    private var hc = SDKHandleCalls()
    
    var myWallets = [Balance]()
    var mySelectedWallet: Balance?
    
    private var paymentPopUpVC: MPESAPaymentView?
    
    var commonWalletUniqueID = ""
    
    var isCorporate = false
    
    final func openPaymentPopUp(amount: Double) {
        generateUniqueId()
        commonWalletUniqueID = ""
        
//        myWallets.filter({ $0.walletUniqueID == am.getWalletUniqueID()}).first
        if let commonWallet = mySelectedWallet {
            paymentPopUpVC = MPESAPaymentView()
            
            guard let paymentPopUpVC = paymentPopUpVC else { return }
            paymentPopUpVC.requestUniqueID = paymentUniqueID
            paymentPopUpVC.amount = String(format: "%.0f", amount)
            paymentPopUpVC.wallet = mySelectedWallet
            paymentPopUpVC.towallet = commonWallet
            if #available(iOS 13.0, *) {
                paymentPopUpVC.isModalInPresentation = true
            }
            paymentPopUpVC.proceedAction = { commonWalletUniqueID in
                self.commonWalletUniqueID = commonWalletUniqueID
                self.onPaymentSuccessful(wallet: commonWallet)
            }
            
            paymentPopUpVC.resendAction = {
                self.generateUniqueId()
                paymentPopUpVC.requestUniqueID = self.paymentUniqueID
            }
            self.present(paymentPopUpVC, animated: true, completion: nil)
        }
    }
    
    func shouldOpenPaymentPopup() -> Bool {
        return mySelectedWallet?.walletAction?.first?.actionType != nil
    }
    
    func onPaymentSuccessful(wallet: Balance) {
        mySelectedWallet = wallet
    }
    
    func generateUniqueId() {
        paymentUniqueID = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
    
    func commonPaymentJsonParams(formId: String, subParamsKey: String = "", subParams: [String: Any] = [String: Any]()) -> [String: Any]  {
        var params = SDKUtils.commonJsonTags(formId: formId, uniqueId: paymentUniqueID)
        
        if !subParamsKey.isEmpty {
            params[subParamsKey] = paymentJsonParams(params: subParams)
        }
        
        return params
    }
    
    private func paymentJsonParams(params: [String: Any]) -> [String: Any] {
        var myParams = params
        myParams["WalletName"] = mySelectedWallet?.walletName ?? ""
        myParams["PaymentMode"] = isCorporate ? "CORPORATE" : (mySelectedWallet?.walletName ?? "")
        myParams["WalletUniqueID"] = isCorporate ? "" : (mySelectedWallet?.walletUniqueID ?? "")
        myParams["WalletID"] = mySelectedWallet?.walletUniqueID ?? ""
        
        return myParams
    }
}
