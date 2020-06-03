//
//  DashboardVC+CollectionView.swift
//  NookNook
//
//  Created by Kevin Laminto on 29/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UICollectionView data source
extension DashboardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favouritesManager.residentVillagers.isEmpty {
            collectionView.setEmptyMessage("Swipe right and press Resident to\nadd a villager to your resident collection!")
        } else {
            collectionView.restore()
        }
        
        return favouritesManager.residentVillagers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VARIANT_CELL, for: indexPath) as! ResidentCollectionViewCell
        
        cell.villagerImage.sd_setImage(with: ImageEngine.parseAcnhURL(with: self.favouritesManager.residentVillagers[indexPath.row].icon!), placeholderImage: UIImage(named: "placeholder"))
        
        let villagerName = self.birthdayResidents.contains(self.favouritesManager.residentVillagers[indexPath.row]) ? "\(self.favouritesManager.residentVillagers[indexPath.row].name) 🎂" : self.favouritesManager.residentVillagers[indexPath.row].name
        cell.villagerName.text = villagerName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedVillager = self.favouritesManager.residentVillagers[indexPath.row]
        let vc = self.storyboard!.instantiateViewController(withIdentifier: DETAIL_ID) as! DetailViewController
        
        vc.parseOject(from: .villagers, object: selectedVillager)
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration, isPreview: Bool) -> UITargetedPreview? {

        // Ensure we can get the expected identifier
        guard let identifier = configuration.identifier as? IndexPath else { return nil }

        // Get the image view in order to create a transform from its frame for our animation
        let cell = residentVillagerCollectionView.cellForItem(at: identifier) as! ResidentCollectionViewCell
        let cellImageView = cell.villagerImage
        cellImageView.backgroundColor = isPreview ? UIColor.cream1.withAlphaComponent(0.8) : .clear

        // Create a custom shape for our highlight/dismissal preview
        let visiblePath = UIBezierPath(roundedRect: cellImageView.bounds, cornerRadius: 3)

        // Configure our parameters
        let parameters = UIPreviewParameters()
        parameters.visiblePath = visiblePath

        // Return the custom targeted preview
        return UITargetedPreview(view: cellImageView, parameters: parameters)
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.makeTargetedPreview(for: configuration, isPreview: true)
    }

    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.makeTargetedPreview(for: configuration, isPreview: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let selectedVillager = self.favouritesManager.residentVillagers[indexPath.row]

        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: {
            return DetailViewController(obj: selectedVillager, group: .villagers)
        }, actionProvider: { _ in
            return ShareHelper.shared.presentContextShare(obj: selectedVillager, group: .villagers, toVC: self)
        })
    }

    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {

        guard let indexPath = configuration.identifier as? IndexPath else { return }
        let selectedVillager = self.favouritesManager.residentVillagers[indexPath.row]

        animator.addAnimations {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: self.DETAIL_ID) as! DetailViewController
            vc.parseOject(from: .villagers, object: selectedVillager)

            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
    }
}
