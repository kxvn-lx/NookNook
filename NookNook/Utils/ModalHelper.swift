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


struct ModalHelper {
    
    private static var cream1 = UIColor.cream1
    private static var grass1 = UIColor.grass1
    private static var dirt1 = UIColor.dirt1
    static var grassBtn = UIColor.grassBtn
    
    private static func getAttr() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: EKColor(ModalHelper.cream1))
        attributes.screenInteraction = .absorbTouches
        attributes.screenBackground = .color(color: EKColor(UIColor(white: 0/255.0, alpha: 0.3)))
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.roundCorners = .all(radius: 2.5)
        
        attributes.entranceAnimation = .init(
            scale: .init(
                from: 0.9,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 0.8, initialVelocity: 0)
            ),
            fade: .init(
                from: 0,
                to: 1,
                duration: 0.3
            )
        )
        attributes.exitAnimation = .init(
            fade: .init(
                from: 1,
                to: 0,
                duration: 0.2
            )
        )
        
        return attributes
    }
    
    static func showPopupMessage(title: String,
                                 description: String,
                                 image: UIImage? = nil) -> ( UIView, EKAttributes ) {
        
        let attributes = ModalHelper.getAttr()
        var titleFont = UIFont.preferredFont(forTextStyle: .title3)
        titleFont = UIFont.systemFont(ofSize: titleFont.pointSize, weight: .semibold)
        let bodyFont = UIFont.preferredFont(forTextStyle: .callout)
        
        var themeImage: EKPopUpMessage.ThemeImage?
        if let image = image {
            themeImage = EKPopUpMessage.ThemeImage(
                image: EKProperty.ImageContent(
                    image: image,
                    displayMode: .inferred,
                    size: CGSize(width: 60, height: 60),
                    tint: EKColor(ModalHelper.grass1),
                    contentMode: .scaleAspectFit
                )
            )
        }
        
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: titleFont,
                color: EKColor(ModalHelper.dirt1),
                alignment: .center,
                displayMode: .inferred
            )
        )
        let description = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: bodyFont,
                color: EKColor(ModalHelper.dirt1),
                alignment: .center,
                displayMode: .inferred
            )
        )
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "Okay",
                style: .init(
                    font: .preferredFont(forTextStyle: .body),
                    color: EKColor.white,
                    displayMode: .inferred
                )
            ),
            backgroundColor: EKColor(ModalHelper.grass1),
            highlightedBackgroundColor: EKColor(ModalHelper.grass1).with(alpha: 0.05),
            displayMode: .inferred
        )
        
        let message = EKPopUpMessage(
            themeImage: themeImage,
            title: title,
            description: description,
            button: button) {
                SwiftEntryKit.dismiss()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        
        
        return ( contentView, attributes )
        
        
    }
    
    
    static func showAlertMessage(title: String, description: String, image: String, actionButton: EKProperty.ButtonContent) -> ( UIView, EKAttributes ) {
        let attributes = ModalHelper.getAttr()
        var titleFont = UIFont.preferredFont(forTextStyle: .title3)
        titleFont = UIFont.systemFont(ofSize: titleFont.pointSize, weight: .semibold)
        let bodyFont = UIFont.preferredFont(forTextStyle: .callout)

        
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: titleFont,
                color: EKColor(ModalHelper.dirt1),
                alignment: .center,
                displayMode: .inferred
            )
        )
        let description = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: bodyFont,
                color: EKColor(ModalHelper.dirt1),
                alignment: .center,
                displayMode: .inferred
            )
        )
        
        let closeButton = EKProperty.ButtonContent(
            label: .init(
                text: "Cancel",
                style: .init(
                    font: .preferredFont(forTextStyle: .body),
                    color: EKColor(ModalHelper.grass1),
                    displayMode: .inferred
                )
            ),
            backgroundColor: EKColor(ModalHelper.grassBtn),
            highlightedBackgroundColor: EKColor(ModalHelper.dirt1).with(alpha: 0.05),
            displayMode: .inferred) {
                SwiftEntryKit.dismiss()
        }

        
        let buttonsBarContent = EKProperty.ButtonBarContent(
            with: closeButton, actionButton,
            separatorColor: EKColor(ModalHelper.cream1),
            displayMode: .inferred,
            expandAnimatedly: false
        )

        let image = EKProperty.ImageContent(
            imageName: image,
            displayMode: .inferred,
            size: CGSize(width: 25, height: 25),
            contentMode: .scaleAspectFit
        )
        
        let simpleMessage = EKSimpleMessage(
            image: image,
            title: title,
            description: description
        )
        
        let alertMessage = EKAlertMessage(
            simpleMessage: simpleMessage,
            buttonBarContent: buttonsBarContent
        )
        
        let contentView = EKAlertMessageView(with: alertMessage)
        
        return ( contentView, attributes )
    }
}

