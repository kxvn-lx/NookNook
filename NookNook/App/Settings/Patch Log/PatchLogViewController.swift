//
//  PatchLogViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 24/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class PatchLogViewController: UIViewController {
    
    private let MARGIN: CGFloat = 10
    
    var scrollView: UIScrollView!
    var mStackView: UIStackView!
    
    var patchLabel: UILabel!
    var titleLabel: UILabel!
    
    var logArray = [
        """
        v1.2.1 (202006251)
        - Improved app performance
        - Minor bug fixes

        v1.2.0 (202006110)
        - Added outfit picker! Mix and match all the clothings to find your next outfit! You can also save an outfit that you liked to your camera roll for future reference.
        - Minor bug fixes to improve the app.

        v1.1.2 (202006030)
        - Fixed chrash on some devices when opening the app

        v1.1.1 (202006020)
        - Fixed IAP issue not removing ads on purchase.
        - Minor adjustments on the app engine.

        v1.1.0 (202005280)
        - Long press on any main cells to preview and share! (Items, Critters, Wardrobes, Villagers, critters this month, favourites, and resident list.)
        - Improved app performance
        - Fixed minor bugs and typos
        - Improved edit info layout

        v1.0.0 (2020050616)
        - Added ads (can be removed via in app purchases under settings (future). Ads MAY NOT appear as this is a new app. It takes time for the server to register my app to receive ads.)
        - Added swipe tableview cells hint for new user to let them know SWIPE RIGHT is an option (only first time)
        - Improved app architecture
        - Added shadow size for fishes
        - Fixed minor bugs
        - Fixed critter this month displaying all caught critters instead of only on a particular month
        - Added some surprise when you caught/donated all critters 😉
        - Minor UI tweaks for Turnip reminder (for consistency)
        - Minor icon changed for consistency and readability

        v1.0.0 (305202010)
        - Improved app performance
        - Fixed minor UI bugs
        - Animated tab bars!
        - Tap any tab bar to go back to the top of the table list.
        - You can now tap any variants of items or wardrobe! (if exist)
        - Added turnip reminders! You can no longer forget to buy or sell them!
        - Edit your profile picture with cropping!
        - Added website link (privacy policy included)

        v1.0.0 (290420201)
        - Fixed 'critters this month' glitch on certain region.
        - New app icon! courtesy of @lonelyvillagerr.
        - Resolve an issue regarding images not displaying correctly for some critters.
        - All pages should now have a consistent search bar component.
        - Tap any tab bar to go back to top of the list!
        
        V1.0.0 (28042020)
        Beta testing released! 🤩
        """
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setBar()
        setView()
        setConstraint()
        setPatchLog()
    }
    
    private func setPatchLog() {
        titleLabel.text = "Patch log."
        
        let masterPatch = logArray.joined(separator: "\n\n")
        patchLabel.text = masterPatch
    }
    
    private func setView() {
        scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .leading, distribution: .equalSpacing)
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.font = UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .bold)
        titleLabel.textColor = .dirt1
        
        patchLabel = UILabel()
        patchLabel.translatesAutoresizingMaskIntoConstraints = false
        patchLabel.numberOfLines = 0
        patchLabel.font = UIFont.preferredFont(forTextStyle: .body)
        patchLabel.textColor = .dirt1
        
        mStackView.addArrangedSubview(titleLabel, withMargin: UIEdgeInsets(top: MARGIN * 2, left: MARGIN * 2, bottom: 0, right: -MARGIN * 2))
        mStackView.addArrangedSubview(patchLabel, withMargin: UIEdgeInsets(top: MARGIN * 2, left: MARGIN * 2, bottom: 0, right: -MARGIN * 2))
        scrollView.addSubview(mStackView)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            
            mStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: MARGIN * 4),
            mStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "Patch Log", preferredLargeTitle: false)
        self.view.backgroundColor = .cream2
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
