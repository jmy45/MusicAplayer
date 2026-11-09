//
//  File.swift
//  App
//
//  Created by xianshen Jiang on 2026/10/12.
//

import UIKit

@MainActor
public class UIBootloader {
    public static let shared = UIBootloader()
    private init() {}
    
    public func configure(window: UIWindow) {

        var controller: UIViewController!
            
        if UserDefaults.standard.hasOnboarded {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewController(identifier: "HomeNC") as! UINavigationController
        } else {
            controller = OnboardingViewController.instantiate()
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            controller = storyboard.instantiateViewController(identifier: "OnboardingViewController")
        }
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
