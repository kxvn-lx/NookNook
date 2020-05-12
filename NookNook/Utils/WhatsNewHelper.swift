//
//  WhatsNewHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 27/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import WhatsNewKit

@objc protocol WhatsNewhelperDelegate: class {
    func whatsNewDidFinish(controller: UIViewController)
}

class WhatsNewHelper {
    
    // MARK: Properties
    var view: WhatsNewViewController?
    @objc weak var delegate: WhatsNewhelperDelegate?
    
    private var swipeRightIcon = IconHelper.systemIcon(of: .swipeRight, weight: .light)
    private var favouriteIcon = IconHelper.systemIcon(of: .star, weight: .light)
    private var birthdayIcon = IconHelper.systemIcon(of: .birthday, weight: .light)
    private var critterIcon = IconHelper.systemIcon(of: .critter, weight: .light)
    private var profileIcon = IconHelper.systemIcon(of: .dashboard, weight: .light)
    private var reminderIcon = IconHelper.systemIcon(of: .reminder, weight: .light)
    
    // MARK: Initialiser
    init() {
        let whatsNew = WhatsNew(
            title: "Welcome\nto NookNook!",
            items: [
                WhatsNew.Item(
                    title: "Swipe right action",
                    subtitle: "All actions, one swipe away.",
                    image: swipeRightIcon
                ),
                WhatsNew.Item(
                    title: "Save anything, anyone!",
                    subtitle: "Favourited? Donated/Caught? In resident? we got it.",
                    image: favouriteIcon
                ),
                WhatsNew.Item(
                    title: "Resident's birthday",
                    subtitle: "See who's in your resident list are having their birthday this month.",
                    image: birthdayIcon
                ),
                WhatsNew.Item(
                    title: "Critters this month",
                    subtitle: "All available critters this month, under your fingertip.",
                    image: critterIcon
                ),
                WhatsNew.Item(
                    title: "Turnip reminder",
                    subtitle: "Use the default reminder, or set your own custom time!",
                    image: reminderIcon
                ),
                WhatsNew.Item(
                    title: "Personalised dashboard",
                    subtitle: "Make NookNook your own personal app.",
                    image: profileIcon
                )
            ]
        )
        
        let configuration = getConfiguration()
        let versionStore: WhatsNewVersionStore = KeyValueWhatsNewVersionStore()
        
        // MARK: Initialize
        view = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration,
            versionStore: versionStore
        )
        
//        view = WhatsNewViewController(
//            whatsNew: whatsNew,
//            configuration: configuration
//        )
    }
    
    private func getConfiguration() -> WhatsNewViewController.Configuration {
        // MARK: Configurations
        var configuration = WhatsNewViewController.Configuration()
        
        configuration.backgroundColor = .cream1
        configuration.apply(animation: .slideRight)
        
        // MARK: Title
        configuration.titleView.secondaryColor = .init(
            startIndex: 11,
            length: 8,
            color: .grass1
        )
        configuration.titleView.titleColor = .dirt1
        configuration.titleView.titleFont = UIFont.preferredFont(forTextStyle: .title1)
        configuration.titleView.titleFont = .systemFont(ofSize: configuration.titleView.titleFont.pointSize, weight: .bold)
        configuration.titleView.titleAlignment = .left
        
        // MARK: Items
        configuration.itemsView.titleFont = .preferredFont(forTextStyle: .callout)
        configuration.itemsView.titleFont = .systemFont(ofSize: configuration.itemsView.titleFont.pointSize, weight: .semibold)
        configuration.itemsView.subtitleFont = .preferredFont(forTextStyle: .subheadline)
        configuration.itemsView.titleColor = .dirt1
        configuration.itemsView.subtitleColor = UIColor.dirt1.withAlphaComponent(0.5)
        configuration.itemsView.layout = .left
        configuration.itemsView.contentMode = .top
        
        // MARK: Buttons
        let completionButton = WhatsNewViewController.CompletionButton(
            title: "Get started",
            action: .custom(action: { [weak self] whatsNewViewController in
                self?.delegate?.whatsNewDidFinish(controller: whatsNewViewController)
            }),
            hapticFeedback: .notification(.success),
            backgroundColor: .grass1,
            titleColor: .white,
            cornerRadius: 2.5,
            animation: .slideRight
        )
        configuration.completionButton = completionButton
        
        return configuration
    }
    
}
