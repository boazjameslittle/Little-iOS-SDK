//
//  LittleSDK.swift
//  LittleSDK
//
//  Created by Gabriel John on 10/05/2021.
//

import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift

public enum ToWhere {
    case rides
    case umi
    case deliveries
    case rideHistory
    case movies
}

public enum deliveryTypes: String {
    case food = "ORDERFOOD"
    case supermarket = "SUPERMARKET"
    case groceries = "GROCERIES"
    case gas = "GAS"
    case drinks = "DRINKS"
    case medicine = "MEDICINE"
    case cakes = "CAKES"
}

public class LittleFramework {
    
    var parametersInitialized: Bool?
    var isUAT = false
    var paymentVC: UIViewController?
    private let am = SDKAllMethods()
    
    public init() {
        IQKeyboardManager.shared.enable = true
    }
    
    public func initializeThemeColor(color: UIColor) {
        
    }
    
    public func initializeSDKMapKeys(googleMapsKey: String, googlePlacesKey: String) {
        GMSServices.provideAPIKey(googleMapsKey)
        GMSPlacesClient.provideAPIKey(googlePlacesKey)
    }
    
    public func initializePaymentVC(vc: UIViewController) {
        paymentVC = vc
    }
    
    public func initializeSDKParameters(accounts: [[String: String]], additionalData: String, mobileNumber: String, packageName: String, APIKey: String, isUAT: Bool, showPaymentAuthorization: Bool, allowPaymentAccountSelection: Bool) {
        self.isUAT = isUAT
        guard let accountsArr = try? SDKUtils.dictionaryArrayToJson(from: accounts) else { return }
        am.saveSDKMobileNumber(data: mobileNumber)
        am.saveSDKPackageName(data: packageName)
        am.saveSDKAccounts(data: accountsArr)
        am.saveSDKAdditionalData(data: additionalData)
        am.saveSDKAPIKey(data: APIKey)
        am.saveIsUAT(data: isUAT)
        am.saveShowPaymentAuthorization(data: showPaymentAuthorization)
        am.saveAllowAccountSelection(data: allowPaymentAccountSelection)
//        am.saveIsFlutter(data: isFlutter)
    }
    
    public func initializeToRides(_ vc: UIViewController) {
        printVal(object: "Latest initializeToRides")
        
        
        let viewController = InitializeSDKVC()
        viewController.isUAT = self.isUAT
        viewController.toWhere = .rides
        viewController.navShown = !(vc.navigationController?.isNavigationBarHidden ?? true)
        viewController.popToRestorationID = vc
        viewController.paymentVC = paymentVC
        
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.modalTransitionStyle = .coverVertical
        navVC.modalPresentationStyle = .overFullScreen
        viewController.present(navVC, animated: true)
                
        /*let viewController = InitializeSDKVC()
        if let navigator = vc.navigationController {
            viewController.isUAT = self.isUAT
            viewController.toWhere = .rides
            viewController.navShown = !(vc.navigationController?.isNavigationBarHidden ?? true)
            viewController.popToRestorationID = vc
            viewController.paymentVC = paymentVC
            navigator.pushViewController(viewController, animated: true)
        }*/
    }
    
    public func initializeToLittlePay(_ vc: UIViewController) {
        let viewController = InitializeSDKVC()
        if let navigator = vc.navigationController {
            viewController.isUAT = self.isUAT
            viewController.toWhere = .umi
            viewController.navShown = !(vc.navigationController?.isNavigationBarHidden ?? true)
            viewController.popToRestorationID = vc
            viewController.paymentVC = paymentVC
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
    
    public func initializeToDeliveries(_ vc: UIViewController, deliveryType: deliveryTypes) {
        let viewController = InitializeSDKVC()
        if let navigator = vc.navigationController {
            viewController.isUAT = self.isUAT
            viewController.toWhere = .deliveries
            viewController.deliveryType = deliveryType
            viewController.navShown = !(vc.navigationController?.isNavigationBarHidden ?? true)
            viewController.popToRestorationID = vc
            viewController.paymentVC = paymentVC
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
    public func initializeToMovies(_ vc: UIViewController) {
        let viewController = InitializeSDKVC()
        if let navigator = vc.navigationController {
            viewController.isUAT = self.isUAT
            viewController.toWhere = .movies
            viewController.navShown = !(vc.navigationController?.isNavigationBarHidden ?? true)
            viewController.popToRestorationID = vc
            viewController.paymentVC = paymentVC
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
    /*public func initializeToRideHistory(_ vc: UIViewController) {
        let viewController = InitializeSDKVC()
        if let navigator = vc.navigationController {
            viewController.isUAT = self.isUAT
            viewController.toWhere = .rideHistory
            viewController.navShown = !(vc.navigationController?.isNavigationBarHidden ?? true)
            viewController.popToRestorationID = vc
            viewController.paymentVC = paymentVC
            navigator.pushViewController(viewController, animated: true)
        }
    }*/
        
}

