//
//  DateExt.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation

extension Date {
    func logDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        return formatter.string(from: self)
    }
}
