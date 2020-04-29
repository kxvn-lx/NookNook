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
        v1.0.0 (553A18)
        - Fixed 'critters this month' glitch on certain region.
        - New app icon! courtesy of @lonelyvillagerr.
        - Resolve an issue regarding images not displaying correctly for some critters.
        - All pages should now have a consistent search bar component.
        - Tap any tab bar to go back to top of the list!
        
        V1.0.0 (28042020)
        Beta testing released! 🤩
        """,
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .leading, distribution: .equalSpacing)
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.font = UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .bold)
        titleLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        
        patchLabel = UILabel()
        patchLabel.translatesAutoresizingMaskIntoConstraints = false
        patchLabel.numberOfLines = 0
        patchLabel.font = UIFont.preferredFont(forTextStyle: .body)
        patchLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        
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
            mStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }
    
    private func setBar() {
        self.configureNavigationBar(largeTitleColor: UIColor(named: ColourUtil.dirt1.rawValue)!, backgoundColor: UIColor(named: ColourUtil.cream1.rawValue)!, tintColor: UIColor(named: ColourUtil.dirt1.rawValue)!, title: "Patch Log", preferredLargeTitle: false)
        
        self.view.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
