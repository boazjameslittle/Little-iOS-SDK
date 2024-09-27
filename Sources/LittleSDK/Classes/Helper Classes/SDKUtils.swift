//
//  File.swift
//  
//
//  Created by Little Developers on 14/09/2022.
//

import Foundation
import CoreLocation
import UIKit
import CoreTelephony

class SDKUtils {
    static func dictionaryArrayToJson(from object: [[String: String]]) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    static func dictionaryToJson(from object: [String: Any]) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    static func extractCoordinate(string: String?) -> CLLocationCoordinate2D {
        guard let string = string else { return CLLocationCoordinate2D(latitude: 0, longitude: 0) }
        
        if string.isEmpty {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        let components = string.components(separatedBy: ",")
        if components.count > 1 {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(components[0]) ?? 0, longitude: CLLocationDegrees(components[1]) ?? 0)
        }
        
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    static func extractStringCoordinateLatitude(string: String?) -> String {
        guard let string = string else { return "0.0" }
        
        if string.isEmpty {
            return  "0.0"
        }
        
        let components = string.components(separatedBy: ",")
        if components.count > 1 {
            return components[0]
        }
        
        return  "0.0"
    }
    
    static func extractStringCoordinateLongitude(string: String?) -> String {
        guard let string = string else { return "0.0" }
        
        if string.isEmpty {
            return  "0.0"
        }
        
        let components = string.components(separatedBy: ",")
        if components.count > 1 {
            return components[1]
        }
        
        return  "0.0"
    }
    
    static func extractCoordinate(array: [String]?, index: Int) -> CLLocationCoordinate2D {
        guard let array = array else { return CLLocationCoordinate2D(latitude: 0, longitude: 0) }
        
        if index > (array.count - 1) {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        let string = array[index]
        
        if string.isEmpty {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        let components = string.components(separatedBy: ",")
        if components.count > 1 {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(components[0]) ?? 0, longitude: CLLocationDegrees(components[1]) ?? 0)
        }
        
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    static func commonJsonTags(formId: String) -> [String: Any] {
        var language = (Locale.current.languageCode ?? "en").lowercased()
        if language.lowercased() != "en" && language.lowercased() != "fr" {
            language = "en"
        }
        
        return [
            "FormID": formId,
            "SessionID": am.getMyUniqueID() ?? "",
            "MobileNumber": am.getSDKMobileNumber() ?? "",
            "IMEI": am.getIMEI() ?? "",
            "CodeBase": am.getMyCodeBase() ?? "",
            "PackageName": am.getSDKPackageName() ?? "",
            "DeviceName": SDKUtils.getPhoneType(),
            "SOFTWAREVERSION": SDKUtils.getAppVersion(),
            "RiderLL": am.getCurrentLocation() ?? "0.0,0.0",
            "LatLong": am.getCurrentLocation() ?? "0.0,0.0",
            "TripID": "",
            "City": am.getCity() ?? "",
            "Country": am.getCountry() ?? "",
            "RegisteredCountry": am.getCountry() ?? "",
            "UniqueID": am.getMyUniqueID() ?? "",
            "CarrierName": SDKUtils.getCarrierName() ?? "",
            "UserAdditionalData": am.getSDKAdditionalData(),
            "LanguageID": language
        ]
    }
    
    static func commonJsonTags(formId: String, uniqueId: String) -> [String: Any] {
        var language = (Locale.current.languageCode ?? "en").lowercased()
        if language.lowercased() != "en" && language.lowercased() != "fr" {
            language = "en"
        }
        
        return [
            "FormID": formId,
            "SessionID": am.getMyUniqueID() ?? "",
            "MobileNumber": am.getSDKMobileNumber() ?? "",
            "IMEI": am.getIMEI() ?? "",
            "CodeBase": am.getMyCodeBase() ?? "",
            "PackageName": am.getSDKPackageName() ?? "",
            "DeviceName": SDKUtils.getPhoneType(),
            "SOFTWAREVERSION": SDKUtils.getAppVersion(),
            "RiderLL": am.getCurrentLocation() ?? "0.0,0.0",
            "LatLong": am.getCurrentLocation() ?? "0.0,0.0",
            "TripID": "",
            "City": am.getCity() ?? "",
            "Country": am.getCountry() ?? "",
            "RegisteredCountry": am.getCountry() ?? "",
            "UniqueID": uniqueId,
            "CarrierName": SDKUtils.getCarrierName() ?? "",
            "UserAdditionalData": am.getSDKAdditionalData(),
            "LanguageID": language
        ]
    }
    
    static func commonJsonPipedTags() -> String {
        let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
        return "UNIQUEID|\(am.getMyUniqueID() ?? "")|MOBILENUMBER|\(am.getSDKMobileNumber() ?? "")|APKVERSION|\(SDKUtils.getAppVersion())|CODEBASE|APPLE|CITY|\(am.getCity() ?? "")|COUNTRY|\(am.getCountry() ?? "")|DEVICENAME|\(SDKUtils.getPhoneType())|IMEI|\(am.getIMEI() ?? "")|CURRENTLL|\(am.getCurrentLocation() ?? "0.0,0.0")|LanguageID|\(Locale.current.languageCode ?? "en")|NetworkCountry|\(countryCode ?? "")|CarrierName|\(SDKUtils.getCarrierName() ?? "")|"
    }

    func commonJsonTagsString(formId: String) -> String {
        let params = SDKUtils.commonJsonTags(formId: formId)
        return (try? SDKUtils.dictionaryToJson(from: params)) ?? ""
    }
    
    static func getAppVersion() -> String {
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        
        return version
        
    }
    
    static func getPhoneType() -> String {
        let modelName = UIDevice.modelName
        return modelName
    }
    
    static func getCarrierName() -> String! {
        // Setup the Network Info and create a CTCarrier object
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        // Get carrier name
        var carrierName = carrier?.carrierName
        
        if carrierName == nil {
            carrierName = ""
        }
        
        return carrierName
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.range(of: emailRegEx, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    static func cleanDeliveryDate(dateStr: String) -> String {
        if dateStr.containsIgnoringCase("Today".localized) {
            let today = Date()
            return dateStr.replacingLastOccurrenceOfString("Today".localized, with: today.scheduleDateOnlyFormat())
            
        } else if dateStr.containsIgnoringCase("Tomorrow".localized) {
            let tomorrow = Date().adding(.day, value: 1)
            return dateStr.replacingLastOccurrenceOfString("Tomorrow".localized, with: tomorrow.scheduleDateOnlyFormat())
        }
        
        return dateStr
    }
    
    static func currencyFormatWithoutZero(_ amount: Float, currencyCode: String = SDKAllMethods().getGLOBALCURRENCY() ?? "KES") -> String? {
        let cf = NumberFormatter()
        cf.currencyCode = currencyCode
        cf.numberStyle = .currency
        cf.maximumFractionDigits = 0
        cf.minimumFractionDigits = 0
        cf.locale = Locale(identifier: "en")
        cf.decimalSeparator = "."
        cf.groupingSeparator = ","
        return cf.string(for: amount)
    }

    static func currencyFormatWithoutZero(_ amount: Int, currencyCode: String = SDKAllMethods().getGLOBALCURRENCY() ?? "KES") -> String? {
        let cf = NumberFormatter()
        cf.currencyCode = currencyCode
        cf.numberStyle = .currency
        cf.maximumFractionDigits = 0
        cf.minimumFractionDigits = 0
        cf.locale = Locale(identifier: "en")
        cf.decimalSeparator = "."
        cf.groupingSeparator = ","
        return cf.string(for: amount)
    }

    static func currencyFormatWithoutZero(_ amount: Double, currencyCode: String = SDKAllMethods().getGLOBALCURRENCY() ?? "KES") -> String? {
        let cf = NumberFormatter()
        cf.currencyCode = currencyCode
        cf.numberStyle = .currency
        cf.maximumFractionDigits = 0
        cf.minimumFractionDigits = 0
        cf.locale = Locale(identifier: "en")
        cf.decimalSeparator = "."
        cf.groupingSeparator = ","
        return cf.string(for: amount)
    }

    static func numberFormat(_ value: Float, maximumFractionDigits: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.locale = Locale(identifier: "en")
        return numberFormatter.string(from: NSNumber(value:value)) ?? ""
    }

    static func numberFormat(_ value: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en")
        return numberFormatter.string(from: NSNumber(value:value)) ?? ""
    }

    static func numberFormat(_ value: Double, maximumFractionDigits: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.locale = Locale(identifier: "en")
        return numberFormatter.string(from: NSNumber(value:value)) ?? ""
    }
    
    static func printObject(_ items: Any?...) {
        #if DEBUG
        print(Date().logDateFormat(), separator: "", terminator: " Little: ")
        
        for (idx, item) in items.enumerated() {
            if idx != items.count - 1 {
                if item != nil {
                    print(item!, separator: "", terminator: ", ")
                } else {
                    print(String(describing: item), separator: "", terminator: ", ")
                }
            } else {
                if item != nil {
                    print(item!, separator: "", terminator: "\n")
                } else {
                    print(String(describing: item), separator: "", terminator: "\n")
                }
            }
        }
        #endif
    }
    
    static func safeAreaBottomInset() -> CGFloat  {
        return UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0
    }

    static func safeAreaTopInset() -> CGFloat  {
        return UIWindow.keyWindow?.safeAreaInsets.top ?? 0
    }

    static func safeAreaLeftInset() -> CGFloat  {
        return UIWindow.keyWindow?.safeAreaInsets.left ?? 0
    }

    static func safeAreaRightInset() -> CGFloat  {
        return UIWindow.keyWindow?.safeAreaInsets.right ?? 0
    }
    
    static func formatDistance(distance: String) -> String {
        let myDistance: Double = Double(distance) ?? 0.0
        
        if myDistance < 1 {
            let distanceInMetres = myDistance * 1000
            
            var rounded: Int {
                if distanceInMetres > 50 {
                    return Int(round(distanceInMetres, toNearest: 100))
                }
                
                return Int(round(distanceInMetres, toNearest: 50))
            }
            
            if rounded >= 1000 {
                return String(format: "%.1f km".localized, myDistance)
            }
            
            return String(format: "%d metres".localized, rounded)
        }
        
        return String(format: "%.1f km".localized, myDistance)
    }

    static func formatDistance(distance: Double) -> String {
        
        if distance < 1 {
            let distanceInMetres = distance * 1000
            
            var rounded: Int {
                if distanceInMetres > 50 {
                    return Int(round(distanceInMetres, toNearest: 100))
                }
                
                return Int(round(distanceInMetres, toNearest: 50))
            }
            
            if rounded >= 1000 {
                return String(format: "%.1f km".localized, distance)
            }
            
            return String(format: "%d metres".localized, rounded)
        }
        
        return String(format: "%.1f km".localized, distance)
    }
    
    static func round(_ value: Double, toNearest: Double) -> Double {
        return _math.round(value / toNearest) * toNearest
    }
}
