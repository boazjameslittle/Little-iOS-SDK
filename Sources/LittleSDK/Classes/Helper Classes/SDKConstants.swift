//
//  Constants.swift
//  LittleSDK
//
//  Created by Gabriel John on 10/05/2021.
//

import UIKit

class SDKConstants {
    
    var chainkey: NSString=""
    var iv: NSString="i7otp4rq4ysrdh5v"
    var headerkey: NSString=""
    var headeriv: NSString="HDJAK$2$23232Fax"
        
    var live = "lwCGahusOkXBoFnNKoWjOBPsuG6cAX5Cs5CUstPbKEUNzjKRzPKBQSemVIVw+PIu"
    var uat = "oMmWr0f0bfDELjSmIqIpgnU/USZNk3hHo+k42DEsDlEejQ+2FXu21HrYmzke3fgyJs+FRbwCnp+JwTBHLP49mw=="
    var mapsKey = "vdQEvjOXQir20oZY7ARDCVk/IZ0zf9mJptA3YxtrpEeuwVsYmtgKAKViH6wWYu3H"
    var placesKey = "vdQEvjOXQir20oZY7ARDCVk/IZ0zf9mJptA3YxtrpEeuwVsYmtgKAKViH6wWYu3H"
    var littleMapKey = "/iPGWhGGttczgqTb/ZAXW8KcCKzPlbe259mm7o2VnHAuzftRz+s6VHkH5LguC1WK"
    
    init(){
        let _key1:String="X0MZL&sHwmxbtA"
        let _key2:String="A29C333B-2C77-4094-A1D3-856BA52C"
        chainkey = _key1.hash256() as NSString
        headerkey = _key2 as NSString
    }
    
    func link() -> String {
        if SDKAllMethods().getIsUAT() {
            return uat
        }
        
        return live
    }
    
    static let testDriverEmail = "og12@gmail.com"
    
    // Colors
    static let littleRed = UIColor(hex: "#D52029")
    static let littleGreen = UIColor(hex: "#0D9848")
    
    // Equity
//    static var littleSDKThemeColor = UIColor(hex: "#A32A29")
    // Vooma
    static var littleSDKThemeColor = UIColor(hex: "#891755")
    // rafiki
//    static var littleSDKThemeColor = UIColor(hex: "#136EAF")
    
    // Equity
    static var littleSDKDarkThemeColor = UIColor(hex: "#A32A29")
    // Vooma
//    static var littleSDKDarkThemeColor = UIColor(hex: "#891755")
    // rafiki
//    static var littleSDKDarkThemeColor = UIColor(hex: "#136EAF")
    
    static var littleSDKLabelColor = UIColor(hex: "#404040")
    static var littleSDKCellBackgroundColor = UIColor(hex: "#FFFFFF")
    static var littleSDKPageBackgroundColor = UIColor(hex: "#FFFFFF")
    
    // Change to vooma or quity
    static let SDK_CLIENT = SDKClient.VOOMA
    
   static let WALLET_ACTION_TYPE_DIAL = "DIAL"
   static let WALLET_ACTION_TYPE_FORM_ID = "FORMID"
    
   static let REMOVEARRAYRESPONSE = 1
    
}
