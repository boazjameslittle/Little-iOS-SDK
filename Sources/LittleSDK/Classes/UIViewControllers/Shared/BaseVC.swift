//
//  File.swift
//  
//
//  Created by Boaz James on 17/07/2023.
//

import UIKit

public class BaseVC: UIViewController {
    
    var customNavigationItem = {
        return UINavigationItem()
    }()
    
    private var style: UIStatusBarStyle = .default
    private var initialStyle: UIStatusBarStyle = .default
    private var traitCollectionChaged = false
    private var statusBarHidden = false
    
    var constraints: [NSLayoutConstraint] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tag = 1
        changeStatusBarStyle(.lightContent)
        
//        UITextField.appearance().tintColor = .littleBlue
        
//        changeNavBarAppearance(isLightContent: true)
        
        setupViews()
        setupContraints()
        setupSharedContraints()
        setupTableView()
        setupCollectionView()
        setupRadioButtons()
        setupPickers()
        setupLabels()
        setupGestures()
        setupBorders()
        setupObservers()
        
        //        NotificationCenter.default.addObserver(forName: LocalizableLanguage.ApplicationDidChangeLanguage, object: nil, queue: nil) { notification in
        //            guard let _ = notification.object as? String else { return }
        //            self.setupLabels()
        //        }
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    public override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupBorders()
        setupContraints()
        
        if !traitCollectionChaged {
            initialStyle = style
        }
        
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                if #available(iOS 13.0, *) {
                    changeStatusBarStyle(.lightContent)
                } else {
                    changeStatusBarStyle(.default)
                }
            } else {
                changeStatusBarStyle(initialStyle)
            }
        }
        
        traitCollectionChaged = true
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 14.0, *) {
            self.navigationItem.backButtonDisplayMode = .minimal
        }
    }
    
    func changeStatusBarStyle(_ style: UIStatusBarStyle) {
        self.style = style
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    func changeNavBarAppearance(isLightContent: Bool, isTranslucent: Bool = false) {
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            
            if isTranslucent {
                navBarAppearance.configureWithTransparentBackground()
                navBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            } else {
                navBarAppearance.configureWithOpaqueBackground()
            }
            
            if isLightContent {
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.backgroundColor = .themeColor
                navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.littleWhite]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.littleWhite]
                navigationController?.navigationBar.standardAppearance = navBarAppearance
                navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            } else {
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.backgroundColor = .littleWhite
                navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.littleLabelColor]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.littleLabelColor]
                navigationController?.navigationBar.standardAppearance = navBarAppearance
                navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            }
        } else {
            if isTranslucent {
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationController?.navigationBar.shadowImage = UIImage()
            }
        }
        
        if isLightContent {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = .littleWhite
            navigationController?.navigationBar.barTintColor = .themeColor
            navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                                       .foregroundColor: UIColor.littleWhite]
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = .littleLabelColor
            navigationController?.navigationBar.barTintColor = .littleWhite
            navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                                       .foregroundColor: UIColor.themeColor]
        }
    }
    
    func showNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func hideNavBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func hideMyNavBarShadow() {
        if #available(iOS 13.0, *) {
            guard let navBarAppearance = self.navigationController?.navigationBar.standardAppearance else { return }
            navBarAppearance.shadowColor = .clear
            navBarAppearance.shadowImage = UIImage()
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        }
        
    }
    
    @objc
    func navigateBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func navigateToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    func replaceBackButtonWithCancel() {
        let cancelButton = UIBarButtonItem(image: UIImage(named: "close")?.renderResizedImage(20)?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleCancel))
        self.navigationItem.setLeftBarButtonItems([cancelButton], animated: false)
    }
    
    @objc func handleCancel() {
        
    }
    
    func setupViews() {}
    
    func setupGestures() {}
    
    func setupLabels() {}
    
    func setupTableView() {}
    
    func setupCollectionView() {}
    
    func setupRadioButtons() {}
    
    func setupPickers() {}
    
    func setupSharedContraints() {}
    
    func setupContraints() {}
    
    func setupObservers() {}
    
    func setupBorders() {}
    
    @objc func validateFields() {}
    
    @objc func validateFieldsWithSender(_ sender: UIButton) {}
    
    
    @objc func dummyClick() {}
    
    func showStatusBar() {
        self.statusBarHidden = false
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.setNeedsStatusBarAppearanceUpdate()
            self.tabBarController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func hideStatusBar() {
        self.statusBarHidden = true
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.setNeedsStatusBarAppearanceUpdate()
            self.tabBarController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
