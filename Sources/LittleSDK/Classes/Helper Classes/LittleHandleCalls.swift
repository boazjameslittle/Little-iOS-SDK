//
//  File.swift
//  LittleSDK
//
//  Created by Boaz James on 07/04/2025.
//

import Foundation
import SDWebImage

class LittleHandleCalls {
    
    var DataToSend = ""
    var JsonDataToSend = ""
    var ReturnData = ""
    var callTypeName = ""
    var count = 0
    var currentTask: URLSessionTask?
    var creatingRequest: Bool = false
    let am = SDKAllMethods()
    let cn = SDKConstants()
    var data_requests = [URLSession]()
    
    var keysent = false
    
    // User cellIndex only for JSONARRAY = 64
    func makeServerCall(sb: String, method: String, switchnum: Int, cellIndex: Int? = nil, uniqueID: String = "") {
        
        count = 0
        
        let topController = UIApplication.topViewController()
        
        let unique_id = uniqueID.isEmpty ? NSUUID().uuidString : uniqueID
        
        if method == "CREATEREQUEST" || method == "CREATEREQUEST_NEW" {
            am.saveUniqueID(data: unique_id)
        }
        
        let currentLocation = am.getCurrentLocation()
        
        let carriername = SDKUtils.getCarrierName()
        
        let version = SDKUtils.getAppVersion()
        
        let netCountry = am.getCountryFilter() ?? ""
        
        var language = (Locale.current.languageCode ?? "en").lowercased()
        if language.lowercased() != "en" && language.lowercased() != "fr" {
            language = "en"
        }
        
        let deviceName = topController?.getPhoneType()
        
        let commonTags = "UNIQUEID|\(unique_id)|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|APKVERSION|\(version)|CODEBASE|APPLE|CITY|\(am.getCity().uppercased())|COUNTRY|\(am.getCountry().uppercased())|DEVICENAME|\(deviceName ?? "APPLE")|IMEI|\(am.getIMEI() ?? "")|CURRENTLL|\(currentLocation ?? "0.0,0.0")|LanguageID|\(language)|NetworkCountry|\(netCountry)|CarrierName|\(carriername ?? "")|"
        
        ReturnData = ""
        DataToSend = ""
        callTypeName = ""
        
        if method.contains("JSONData") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|JSONDATA|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|JSONDATA|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("FoodDelivery") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|FOODDELIVERY|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|FOODDELIVERY|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("Delivery") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|DELIVERY|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|DELIVERY|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("UtilityPayments") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|UTILITYPAYMENTS|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|UTILITYPAYMENTS|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("P2P") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|P2P|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|P2P|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("Movies") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|MOVIES|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|MOVIES|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("EXTERNALAPI") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|EXTERNALAPI|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|EXTERNALAPI|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("Airtime") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|AIRTIME|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|AIRTIME|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("SuperApp") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|SUPERAPP|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|SUPERAPP|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("LilliePuts") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|LILLIEPUTS|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|LILLIEPUTS|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.contains("LittleCare") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|LITTLECARE|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|LITTLECARE|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else if method.containsIgnoringCase("Simple") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|SIMPLE|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|SIMPLE|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        }  else if method.contains("IOTCLASS") {
            
            DataToSend = am.EncryptDataAESLittle(DataToSend: "FORMID|IOTCLASS|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|") as String
            JsonDataToSend = am.EncodeDataBase64(DataToSend: sb) as String
            JsonDataToSend = am.EncryptDataAESLittle(DataToSend: JsonDataToSend)
            
            printVal(object: "DataToSend\n" + DataToSend)
            printVal(object: "FORMID|IOTCLASS|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|")
            printVal(object: "JsonDataToSend\n" + JsonDataToSend)
            printVal(object: sb)
            
        } else {
            DataToSend = am.EncryptDataAESLittle(DataToSend: sb + commonTags) as String
            printVal(object: sb + commonTags)
            printVal(object: "DataToSend: \(sb + commonTags)")
        }
        
        DataToSend = CFURLCreateStringByAddingPercentEscapes(
            nil,
            DataToSend as CFString,
            nil,
            "!*'();:@&=+$,/?%#[]" as CFString,
            CFStringBuiltInEncodings.UTF8.rawValue
            ) as String
        
        JsonDataToSend = CFURLCreateStringByAddingPercentEscapes(
            nil,
            JsonDataToSend as CFString,
            nil,
            "!*'();:@&=+$,/?%#[]" as CFString,
            CFStringBuiltInEncodings.UTF8.rawValue
            ) as String
        
        callTypeName = method
                
        if SDKReachability.isConnectedToNetwork() || method == "VERIFYUSSDCODEJSONData" {
            connectToServer(switchnum: switchnum, method: method, cellIndex: cellIndex)
        } else {
            
            printVal(object: "makeServerCall network issue: \(method)")
            
            topController?.removeLoadingPage()
            topController?.view.removeAnimation()
            
            topController?.dismissSwiftAlert()
            
            let bundle = Bundle.module
            
            topController?.showWarningAlert(title: "", message: "You appear to be offline. Kindly check your Internet connection and try again.".localized, actionButtonText: "Open Settings".localized) {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        printVal(object: "Settings opened: \(success)") // Prints true
                    })
                }
            }
            
            let userInfo = ["cellIndex": cellIndex ?? 0]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: callTypeName), object: nil, userInfo: userInfo)
            
        }
        
    }
    
    func connectToServer(switchnum: Int, method: String, cellIndex: Int?){
        
        count += 1
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let string = am.DecryptDataKC(DataToSend: cn.littleLink()) as String
        
        printVal(object: "myUrl: \(string)")
        
        var request = URLRequest(url: URL(string: string)!)
                
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ISTEST"), object: nil)
        
        request.httpMethod = "POST"
        if callTypeName == "CREATEREQUEST" || callTypeName == "CREATECORPORATERIDE" {
            if callTypeName == "CREATEREQUEST" {
                creatingRequest = true
            }
            request.timeoutInterval = 120
        }
        let topController = UIApplication.topViewController()
        var postString = "DATA=\(DataToSend)"
        
        if callTypeName.contains("JSONData") {
            postString.append("&JSONData=\(JsonDataToSend)")
        } else if callTypeName.contains("FoodDelivery") {
            postString.append("&FoodDelivery=\(JsonDataToSend)")
        } else if callTypeName.contains("Delivery") {
            postString.append("&Delivery=\(JsonDataToSend)")
        } else if callTypeName.contains("SuperApp") || callTypeName.contains("UtilityPayments") || callTypeName.contains("Airtime") || callTypeName.contains("P2P") || callTypeName.contains("Movies") || callTypeName.contains("EXTERNALAPI") || callTypeName.contains("LilliePuts") || callTypeName.contains("LittleCare") || callTypeName.contains("IOTCLASS") {
            postString.append("&JSONData=\(JsonDataToSend)")
        } else if callTypeName.containsIgnoringCase("Simple") {
            postString.append("&JSONData=\(JsonDataToSend)")
        }
        printVal(object: "PostString: \(postString)")
        
//        let session = URLSession(configuration: URLSessionConfiguration.ephemeral,delegate: NSURLSessionPinningDelegate(),delegateQueue: nil)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        do {
            request.httpBody = postString.data(using: .utf8)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                do {
                    guard let data = data, error == nil else {
                        DispatchQueue.main.async(execute: {
                            // printVal(object: "error=\(String(describing: error))")
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.handleTimeouts(switchnum: switchnum, cellIndex: cellIndex)
                        })
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        // printVal(object: "statusCode should be 200, but is \(httpStatus.statusCode)")
                        // printVal(object: "response = \(String(describing: response))")
                        DispatchQueue.main.async(execute: {
                            self.handleTimeouts(switchnum: switchnum, cellIndex: cellIndex)
                            topController?.removeLoadingPage()
                            topController?.view.removeAnimation()
                            UIWindow.keyWindow?.removeAnimation()
                        })
                    }
                    DispatchQueue.main.async(execute: {
                        let responseString = String(data: data, encoding: .utf8)
                        printVal(object: "encrypted = \(responseString!)")
                        self.ReturnData = self.am.DecryptDataAESLittle(DataToSend: responseString!) as String
                        
                        printVal(object: "ReturnData = \(self.ReturnData)")
                        if self.callTypeName.contains("JSONData") || self.callTypeName.contains("FoodDelivery") || self.callTypeName.contains("Delivery") || self.callTypeName.contains("SuperApp") || self.callTypeName.contains("UtilityPayments") || self.callTypeName.contains("Airtime") || self.callTypeName.contains("P2P") || self.callTypeName.contains("Movies") || self.callTypeName.contains("EXTERNALAPI") || self.callTypeName.contains("LilliePuts") || self.callTypeName.contains("LittleCare") || self.callTypeName.contains("IOTCLASS") || self.callTypeName.contains("Simple") {
                            self.ReturnData = self.am.DecodeDataBase64(DataToSend: self.ReturnData) as String
                        }
                        
                        printVal(object: "\(method): decrypted = \(self.ReturnData)")
                        
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.processResults(switchnum: switchnum, method: method, cellIndex: cellIndex)
                    })
                }
            })
            task.resume()
        }
        
        
    }
    
    func processResults(switchnum: Int, method: String, cellIndex: Int?) {
        
        let topController = UIApplication.topViewController()
        
        if switchnum == SDKConstants.REMOVEARRAYRESPONSE && ReturnData.starts(with: "[") {
            ReturnData.removeFirst()
            ReturnData.removeLast()
        }
        
        let data = ReturnData.data(using: .utf8)!
        
        let dataDict:[String: Any] = ["data": data, "cellIndex": cellIndex ?? 0]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: callTypeName), object: nil, userInfo: dataDict)
    }
    
    func handleTimeouts(switchnum: Int, cellIndex: Int?) {
        
        printVal(object: "Timed Out: \(callTypeName)")
        
        let topController = UIApplication.topViewController()
        
        if count < 2 {
            connectToServer(switchnum: switchnum, method: "", cellIndex: cellIndex)
        } else {
            topController?.removeLoadingPage()
            topController?.view.removeAnimation()
            UIWindow.keyWindow?.removeAnimation()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: callTypeName), object: nil)
        }
    }
    
    func reloadCall(switchnum: Int, response: URLResponse, cellIndex: Int? = nil) {
        printVal(object: "Reconnecting...")
        connectToServer(switchnum: switchnum, method: "", cellIndex: cellIndex)
    }
    
    
}
