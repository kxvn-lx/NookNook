//
//  VC+.swift
//  NookNook
//
//  Created by Kevin Laminto on 12/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

/// EXTENSIONS
// MARK: - UIViewController
extension UIViewController {
    func configureNavigationBar(largeTitleColor: UIColor? = nil, backgoundColor: UIColor? = nil, tintColor: UIColor? = nil, title: String? = "", preferredLargeTitle: Bool? = nil) {
        
        // Colours
        let cream1 = UIColor.cream1
        let dirt1 = UIColor.dirt1
        
        let largeTitleColour = largeTitleColor == nil ? dirt1 : largeTitleColor
        let backgroundColour = backgoundColor == nil ? cream1 : backgoundColor
        let tintColour = tintColor == nil ? dirt1 : tintColor
        let prefLargeTitle = preferredLargeTitle == nil ? true : false
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColour!]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColour!]
        navBarAppearance.backgroundColor = backgroundColour
        navBarAppearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationController?.navigationBar.prefersLargeTitles = prefLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColour
        navigationItem.title = title
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITableViewController {
    func setCustomFooterView(text: String, height: CGFloat, multiplier: CGFloat = 0) {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: height + height * multiplier))
        customView.backgroundColor = .clear
        let titleLabel = UILabel(frame: CGRect(x: 30, y: 0, width: self.tableView.frame.width * 0.85, height: height))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        titleLabel.font = .preferredFont(forTextStyle: .caption2)
        titleLabel.text  = text
        customView.addSubview(titleLabel)
        self.tableView.tableFooterView = customView
    }
    
    func addHeaderImage(withIcon icon: UIImage, height: CGFloat? = 150) {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height!))
        let headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
        
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.tintColor = .dirt1
        headerImageView.image = icon.withRenderingMode(.alwaysTemplate)
        v.addSubview(headerImageView)
        headerImageView.center = CGPoint(x: v.frame.size.width  / 2, y: v.frame.size.height / 2)
        self.tableView.tableHeaderView = v
    }
}

// MARK: - UIStackView
extension UIStackView {
    func addBackground(color: UIColor, cornerRadius: CGFloat? = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.cornerRadius = cornerRadius!
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
    func addArrangedSubview(_ v: UIView, withMargin m: UIEdgeInsets ) {
        let containerForMargin = UIView()
        containerForMargin.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: containerForMargin.topAnchor, constant: m.top ),
            v.bottomAnchor.constraint(equalTo: containerForMargin.bottomAnchor, constant: m.bottom ),
            v.leftAnchor.constraint(equalTo: containerForMargin.leftAnchor, constant: m.left),
            v.rightAnchor.constraint(equalTo: containerForMargin.rightAnchor, constant: m.right)
        ])
        
        addArrangedSubview(containerForMargin)
    }
}

// MARK: - UIButton
extension UIButton {
    func addBlurEffect(style: UIBlurEffect.Style = .regular, cornerRadius: CGFloat = 0, padding: CGFloat = 0) {
        backgroundColor = .clear
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        if cornerRadius > 0 {
            blurView.layer.cornerRadius = cornerRadius
            blurView.layer.masksToBounds = true
        }
        self.insertSubview(blurView, at: 0)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding).isActive = true
        self.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -padding).isActive = true
        
        if let imageView = self.imageView {
            imageView.backgroundColor = .clear
            self.bringSubviewToFront(imageView)
        }
    }
}

// MARK: - String
extension String {
    var isInteger: Bool { return Int(self) != nil }
    var isFloat: Bool { return Float(self) != nil }
    var isDouble: Bool { return Double(self) != nil }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

// MARK: - UISearchBar
extension UISearchBar {
    func setPlaceholderTextColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
}

// MARK: - UITableView
extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width * 0.3, height: self.bounds.size.height * 0.5))
        messageLabel.text = message
        messageLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width * 0.3, height: self.bounds.size.height * 0.5))
        messageLabel.text = message
        messageLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

// MARK: - UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    // App colour
    /// Used for main texts colour and accent colours
    static let dirt1 = UIColor(named: "Dirt-1")!
    /// Used for main app secondary background colour and buttons
    static let grass1 = UIColor(named: "Grass-1")!
    /// Used for secondary buttons
    static let grassBtn = UIColor(named: "Grass-btn")!
    /// Used for main app background
    static let cream1 = UIColor(named: "Cream-1")!
    /// Used for secondary app background
    static let cream2 = UIColor(named: "Cream-2")!
    /// Used for secondary texts colour
    static let gold1 = UIColor(named: "Gold-1")!
    
}

/// CLASS
// MARK: - UILabel
class PaddingLabel: UILabel {
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    required init(withInsets top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += topInset + bottomInset
        contentSize.width += leftInset + rightInset
        return contentSize
    }
}
