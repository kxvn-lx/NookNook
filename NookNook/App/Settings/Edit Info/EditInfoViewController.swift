//
//  EditInfoViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import TweeTextField
import SwiftEntryKit

class EditInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    private var userDict: [String: String]!
    
    private let MARGIN: CGFloat = 10
    
    
    private var scrollView: UIScrollView!
    private var mStackView: UIStackView!
    
    private var favouritesManager: PersistEngine!
    
    var iconView: UIImageView!
    var imgWrapper: UIView!

    
    var profileImageView: UIImageView!
    var nameTF: TweeAttributedTextField!
    var islandNameTF: TweeAttributedTextField!
    var nativeFruitButton: UIButton!
    var fruitLabel: UILabel!
    var selectedFruit: String!
    var selectedHemisphere: DateHelper.Hemisphere!
    var hemispherePicker: UISegmentedControl!
    
    var saveButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDict = UDHelper.getUser()
        setBar()
        setUI()
        setConstraint()
        
        setupProfile()
        
        self.nameTF.delegate = self
        self.islandNameTF.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgWrapper.isUserInteractionEnabled = true
        imgWrapper.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        userDict = UDHelper.getUser()
        favouritesManager = PersistEngine()
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    // Modify the UI
    private func setBar() {
        self.configureNavigationBar(title: "Edit Info", preferredLargeTitle: false)
        
        self.view.backgroundColor = .cream1
        
        self.view.tintColor = .white
        
        let close = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    private func setupProfile() {
        userDict = UDHelper.getUser()
        
        nameTF.text = userDict["name"]
        islandNameTF.text = "\(userDict["islandName"] ?? "")"
        selectedFruit = userDict["nativeFruit"] ?? ""
        fruitLabel.attributedText = renderFruitLabel(text: userDict["nativeFruit"] ?? "Not selected")
        hemispherePicker.selectedSegmentIndex = userDict["hemisphere"] == DateHelper.Hemisphere.Northern.rawValue ? 0 : 1
        selectedHemisphere = userDict["hemisphere"].map { DateHelper.Hemisphere(rawValue: $0) ?? DateHelper.Hemisphere.Southern } == nil ? DateHelper.Hemisphere.Southern : userDict["hemisphere"].map { DateHelper.Hemisphere(rawValue: $0)! }
        if let img = ImagePersistEngine.loadImage() {
            profileImageView.image = img
        }
    }
    
    // MARK: - Set the views
    private func setUI() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        
        // Create master stackView
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .center, distribution: .equalSpacing)
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .cream2
        profileImageView.image = UIImage(named: "appIcon-Ori")
        
        
        iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image =  IconUtil.systemIcon(of: .edit, weight: .regular).withRenderingMode(.alwaysTemplate)
        iconView.tintColor = .dirt1
        
        imgWrapper = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imgWrapper.translatesAutoresizingMaskIntoConstraints = false
        imgWrapper.addSubview(profileImageView)
        imgWrapper.addSubview(iconView)
        
        
        nameTF = TweeAttributedTextField()
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        nameTF.addTarget(self, action: #selector(textfieldEventEnd), for: .editingDidEnd)
        nameTF.addTarget(self, action: #selector(textfieldEventBegin), for: .editingDidBegin)
        nameTF.infoTextColor = UIColor.red.withAlphaComponent(0.8)
        nameTF.infoLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        nameTF.infoAnimationDuration = 0.05
        nameTF.clearButtonMode = .always
        nameTF.clearButtonMode = .whileEditing
        nameTF.animationDuration = 0.25
        nameTF.activeLineColor = UIColor.dirt1.withAlphaComponent(0.8)
        nameTF.textColor = .dirt1
        nameTF.lineColor = UIColor.dirt1.withAlphaComponent(0.3)
        nameTF.lineWidth = 1
        nameTF.minimumPlaceholderFontSize = nameTF.font!.pointSize - 6
        nameTF.originalPlaceholderFontSize = nameTF.font!.pointSize - 2
        nameTF.placeholderDuration = 0.2
        nameTF.placeholderColor = UIColor.dirt1.withAlphaComponent(0.5)
        nameTF.tweePlaceholder = "Name"

        
        islandNameTF = TweeAttributedTextField()
        islandNameTF.translatesAutoresizingMaskIntoConstraints = false
        islandNameTF.addTarget(self, action: #selector(textfieldEventEnd), for: .editingDidEnd)
        islandNameTF.addTarget(self, action: #selector(textfieldEventBegin), for: .editingDidBegin)
        islandNameTF.infoTextColor = UIColor.red.withAlphaComponent(0.8)
        islandNameTF.infoAnimationDuration = 0.05
        islandNameTF.infoLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        islandNameTF.animationDuration = 0.25
        islandNameTF.activeLineColor = UIColor.dirt1.withAlphaComponent(0.8)
        islandNameTF.clearButtonMode = .always
        islandNameTF.clearButtonMode = .whileEditing
        islandNameTF.textColor = .dirt1
        islandNameTF.lineColor = UIColor.dirt1.withAlphaComponent(0.3)
        islandNameTF.lineWidth = 1
        islandNameTF.minimumPlaceholderFontSize = nameTF.font!.pointSize - 6
        islandNameTF.originalPlaceholderFontSize = nameTF.font!.pointSize - 2
        islandNameTF.placeholderDuration = 0.2
        islandNameTF.placeholderColor = UIColor.dirt1.withAlphaComponent(0.5)
        islandNameTF.tweePlaceholder = "Island Name 🏝"

        fruitLabel = UILabel()
        fruitLabel.translatesAutoresizingMaskIntoConstraints = false
        fruitLabel.textColor = .dirt1
        fruitLabel.numberOfLines = 2
        
        nativeFruitButton = UIButton()
        nativeFruitButton.translatesAutoresizingMaskIntoConstraints = false
        nativeFruitButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        nativeFruitButton.backgroundColor = .grassBtn
        nativeFruitButton.layer.borderWidth = 1
        nativeFruitButton.titleLabel?.numberOfLines = 2
        nativeFruitButton.layer.borderColor = UIColor.grassBtn.cgColor
        nativeFruitButton.layer.cornerRadius = 2.5
        nativeFruitButton.titleLabel?.textAlignment = .center
        nativeFruitButton.setTitleColor(.grass1, for: .normal)
        nativeFruitButton.setTitleColor(UIColor.grass1.withAlphaComponent(0.5), for: .highlighted)
        nativeFruitButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        nativeFruitButton.titleLabel?.font = UIFont.systemFont(ofSize: (nativeFruitButton.titleLabel?.font.pointSize)!, weight: .semibold)
        nativeFruitButton.addTarget(self, action: #selector(fruitPicker), for: .touchUpInside)
        nativeFruitButton.setTitle("Change fruit", for: .normal)
        
        
        hemispherePicker = UISegmentedControl(items: [DateHelper.Hemisphere.Northern.rawValue, DateHelper.Hemisphere.Southern.rawValue])
        hemispherePicker.backgroundColor = .cream2
        hemispherePicker.tintColor = .cream1
        hemispherePicker.translatesAutoresizingMaskIntoConstraints = false
        hemispherePicker.addTarget(self, action:  #selector(hemispherePickerChanged), for: .valueChanged)
        
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        saveButton.backgroundColor = .grass1
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 2.5
        saveButton.titleLabel?.numberOfLines = 2
        saveButton.layer.borderColor = UIColor.grass1.cgColor
        saveButton.titleLabel?.textAlignment = .center
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        saveButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: (nativeFruitButton.titleLabel?.font.pointSize)!, weight: .semibold)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveButton.setTitle("Save", for: .normal)
        
        mStackView.addArrangedSubview(imgWrapper, withMargin: UIEdgeInsets(top: MARGIN*4, left: 0, bottom: 0, right: 0))
        mStackView.addArrangedSubview(nameTF)
        mStackView.addArrangedSubview(islandNameTF)
        mStackView.addArrangedSubview(hemispherePicker)
        mStackView.addArrangedSubview(fruitLabel)
        mStackView.addArrangedSubview(nativeFruitButton)
        mStackView.addArrangedSubview(saveButton)
        
        scrollView.addSubview(mStackView)
    }
    
    @objc private func hemispherePickerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedHemisphere = .Northern
            Taptic.lightTaptic()
        case 1:
            selectedHemisphere = .Southern
            Taptic.lightTaptic()
        default:
            fatalError("Hemisphere Picker out of range")
        }
    }
    
    @objc private func textfieldEventEnd(_ sender: TweeAttributedTextField) {
        if sender.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            if nameTF == sender {
                sender.showInfo("You cannot have an empty name.")
            } else if islandNameTF == sender {
                sender.showInfo("You cannot have an empty island name.")
            }
        }
    }
    
    @objc private func textfieldEventBegin(_ sender: TweeAttributedTextField) {
        sender.hideInfo()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc private func saveTapped(sender: UIButton!) {
        if !nameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty && !islandNameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty && !selectedFruit.isEmpty {
            let user = User(name: nameTF.text!, islandName: islandNameTF.text!, nativeFruit: selectedFruit, hemisphere: selectedHemisphere)
            UDHelper.saveUser(user: user)
            
            // Save user image
            if let img = self.profileImageView.image {
                ImagePersistEngine.saveImage(image: img)
            }
            
            
            Taptic.successTaptic()
            self.closeTapped()
        }
        else {
            let ( view, attributes ) = ModalFactory.showPopupMessage(title: "Oh bummer!", description: "Please make sure you did not leave any textfields empty!", image: UIImage(named: "sad"))
            
            SwiftEntryKit.display(entry: view, using: attributes)
            Taptic.errorTaptic()
        }

    }
    
    @objc private func fruitPicker(sender: UIButton!) {
        let FRUIT_ID = "FruitsVC"
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: FRUIT_ID) as! FruitsTableViewController
        vc.fruitsDelegate = self
        vc.userFruit = selectedFruit
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
    private func setConstraint() {
        let itemImageViewSize: CGFloat = 0.3
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            
            mStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -MARGIN * 4),
            mStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            nameTF.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor, multiplier: 0.8),
            islandNameTF.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor, multiplier: 0.8),
            nativeFruitButton.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor, multiplier: 0.7),
            saveButton.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor, multiplier: 0.7),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 130),
            profileImageView.heightAnchor.constraint(equalToConstant: 130),
            
            imgWrapper.widthAnchor.constraint(equalToConstant: 130),
            imgWrapper.heightAnchor.constraint(equalToConstant: 130),
            iconView.widthAnchor.constraint(equalTo: self.profileImageView.widthAnchor, multiplier: itemImageViewSize - 0.12),
            iconView.heightAnchor.constraint(equalTo: self.profileImageView.widthAnchor, multiplier: itemImageViewSize - 0.12),
            
            iconView.rightAnchor.constraint(equalTo: imgWrapper.rightAnchor),
            iconView.bottomAnchor.constraint(equalTo: imgWrapper.bottomAnchor),
            
            
        ])
    }
    
    private func createSV(title: String, with body: UILabel) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = self.MARGIN
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
        let label1 = UILabel()
        label1.numberOfLines = 0
        label1.text = title
        label1.tag = 1
        label1.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        
        stackView.addBackground(color: .cream1, cornerRadius: 5)
        
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(body)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: MARGIN * 1.5, left: MARGIN * 1.5, bottom: MARGIN * 1.5, right: MARGIN * 1.5)
        
        
        
        return stackView
    }
    
    private func renderFruitLabel(text: String) -> NSMutableAttributedString {
        let boldText = "Native fruit: "
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: self.fruitLabel.font.pointSize, weight: .semibold)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalString = NSMutableAttributedString(string: text)

        attributedString.append(normalString)
        return attributedString
    }
    
}

extension EditInfoViewController: FruitsDelegate {
    func changeFruit(fruit: Fruits) {
        selectedFruit = fruit.rawValue
        self.fruitLabel.attributedText = renderFruitLabel(text: selectedFruit)
        
    }
}
