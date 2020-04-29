//
//  DetailVC+CollectionView.swift
//  NookNook
//
//  Created by Kevin Laminto on 29/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Collection view datasource
extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch groupOrigin {
        case .items:
            if let itemObjArr = itemObj.variants {
                return itemObjArr.count
            }
        case .critters:
            return 0
            
        case .wardrobes:
            if let wardrobeObjArr = wardrobeObj.variants {
                return wardrobeObjArr.count
            }
            
        case .villagers:
            return 0
            
        default: fatalError("Attempt to create cells from an unkown group origin or, groupOrigin is nul!")
        }

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VARIANT_CELL, for: indexPath) as! VariantCollectionViewCell
        
        switch groupOrigin {
        case .items:
            if let itemObjArr = itemObj.variants {
                cell.variantImage.sd_setImage(with: ImageEngine.parseNPURL(with: itemObjArr[indexPath.row], category: itemObj.category), placeholderImage: nil)
            }
        case .critters:
            print("Attempt to access critter cell.")
        case .wardrobes:
            if let wardrobeObjArr = wardrobeObj.variants {
                cell.variantImage.sd_setImage(with: ImageEngine.parseNPURL(with: wardrobeObjArr[indexPath.row], category: wardrobeObj.category), placeholderImage: nil)
            }
        default: fatalError("Attempt to access an invalid object group or groupOrigin is still nil!")
        }
        
        return cell
    }
}

