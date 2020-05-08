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
        
        cell.variantImage.sd_setImage(with: ImageEngine.parseAcnhURL(with: self.favouritesManager.residentVillagers[indexPath.row].image, of: Categories.villagers.rawValue, mediaType: .icons), placeholderImage: UIImage(named: "placeholder"))
        
        let villagerName = self.birthdayResidents.contains(self.favouritesManager.residentVillagers[indexPath.row]) ? "\(self.favouritesManager.residentVillagers[indexPath.row].name) 🎂" : self.favouritesManager.residentVillagers[indexPath.row].name
        cell.variantName.text = villagerName
        
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
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.cream2.withAlphaComponent(0.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = nil
        }
    }
}
