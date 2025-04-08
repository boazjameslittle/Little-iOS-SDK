//
//  File.swift
//  LittleSDK
//
//  Created by Boaz James on 08/04/2025.
//

import UIKit

extension UIViewController {
    func showLoadingView(title : String = "Please wait…".localized) {
        let existingView = view.viewWithTag(1200)
        if existingView != nil {
            return
        }
        
        let view = ProgressView(frame: UIScreen.main.bounds)
        view.title = title
        view.tag = 1200
        self.view.addSubview(view)
        
    }
    
    func hideLoadingView() {
        let existingView = view.viewWithTag(1200)
        existingView?.removeFromSuperview()
    }
}
