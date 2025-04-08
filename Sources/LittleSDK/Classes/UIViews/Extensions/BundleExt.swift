//
//  File.swift
//  LittleSDK
//
//  Created by Boaz James on 07/04/2025.
//

import UIKit

extension Bundle {
    static func getAppDisplayName() -> String {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return appName
        }
        
        return ""
    }
}
