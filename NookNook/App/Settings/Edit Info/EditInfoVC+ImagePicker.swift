//
//  EditInfoVC+ImagePicker.swift
//  NookNook
//
//  Created by Kevin Laminto on 3/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

extension EditInfoViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image: UIImage!
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
            self.profileImageView.image = image

        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
            self.profileImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    

}
