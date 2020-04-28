//
//  ModalHelper.swift
//  NookNook
//
//  Created by Kevin Laminto on 28/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit


struct ModalFactory {
    
    static func renderNormalModal(title: String, message: String, icon: String) {
        
        
    }
    
    private func showPopupMessage(attributes: EKAttributes,
                                  title: String,
                                  titleColor: EKColor,
                                  description: String,
                                  descriptionColor: EKColor,
                                  buttonTitleColor: EKColor,
                                  buttonBackgroundColor: EKColor,
                                  image: UIImage? = nil) {
        
        var themeImage: EKPopUpMessage.ThemeImage?
        
        if let image = image {
            themeImage = EKPopUpMessage.ThemeImage(
                image: EKProperty.ImageContent(
                    image: image,
                    displayMode: .inferred,
                    size: CGSize(width: 60, height: 60),
                    tint: titleColor,
                    contentMode: .scaleAspectFit
                )
            )
        }
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: .preferredFont(forTextStyle: .title3),
                color: titleColor,
                alignment: .center,
                displayMode: .inferred
            )
        )
        let description = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: .preferredFont(forTextStyle: .body),
                color: descriptionColor,
                alignment: .center,
                displayMode: .inferred
            )
        )
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "Got it!",
                style: .init(
                    font: .preferredFont(forTextStyle: .body),
                    color: buttonTitleColor,
                    displayMode: .inferred
                )
            ),
            backgroundColor: buttonBackgroundColor,
            highlightedBackgroundColor: buttonTitleColor.with(alpha: 0.05)
        )
        let message = EKPopUpMessage(
            themeImage: themeImage,
            title: title,
            description: description,
            button: button) {
                SwiftEntryKit.dismiss()
        }
        let contentView = EKPopUpMessageView(with: message)
        contentView.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)!
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

