//
//  BaseVM.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation

class BaseVM: NSObject {
    
    deinit {
        removeObservers()
    }
    
    func removeObservers() {}
}
