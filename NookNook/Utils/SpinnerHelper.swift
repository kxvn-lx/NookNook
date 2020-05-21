//
//  SpinnerHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 6/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

class SpinnerHelper: NSObject {
    
    private let window = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first
    
    private var v = UIView()
    
    override private init() { }

    static let shared = SpinnerHelper()
    
    /// Start animating the spinner
    func present() {
        guard let window = window else { return }
        
        v = UIView(frame: window.bounds)
        window.addSubview(v)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .cream1
        spinner.startAnimating()
        v.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
    }
    
    /// Stop animating the spinner
    func absent() {
        v.removeFromSuperview()
    }
}
