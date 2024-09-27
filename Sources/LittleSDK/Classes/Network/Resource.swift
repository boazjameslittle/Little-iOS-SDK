//
//  Resource.swift
//  LittleSDK
//
//  Created by Boaz James on 26/09/2024.
//

import Foundation

enum Resource<T> {
    case loading
    case data(Swift.Result<T, APIError>)
    
}

