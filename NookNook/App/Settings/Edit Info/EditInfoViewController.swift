//
//  EditInfoViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import TweeTextField

class EditInfoViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    private var userDict: [String: String]!
    
    private let MARGIN: CGFloat = 10
    
    private var scrollView: UIScrollView = {
       let v = UIScrollView()
       v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private var mStackView: UIStackView!
    private var fruitStack: UIStackView!
    
    private var favouritesManager: DataPersistEngine!
    
    var iconView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image =  IconHelper.systemIcon(of: .edit, weight: .regular).withRenderingMode(.alwaysTemplate)
        v.tintColor = .dirt1
        return v
    }()
    var imgWrapper: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var profileImageView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 130 / 2
        v.clipsToBounds = true
        v.backgroundColor = .cream2
        v.image = UIImage(named: "appIcon-Ori")
        return v
    }()
    var nameTF: TweeAttributedTextField!
    var islandNameTF: TweeAttributedTextField!
    var nativeFruitButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.titleLabel?.textAlignment = .right
        v.titleLabel?.numberOfLines = 2
        v.setTitleColor(.grass1, for: .normal)
        v.setTitleColor(UIColor.grass1.withAlphaComponent(0.5), for: .highlighted)
        v.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        v.addTarget(self, action: #selector(fruitPicker), for: .touchUpInside)
        v.setTitle("Change fruit", for: .normal)
        return v
    }()
    var fruitLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .dirt1
        v.numberOfLines = 2
        return v
    }()
    var selectedFruit: String!
    var selectedHemisphere: DateHelper.Hemisphere!
    var hemispherePicker: UISegmentedControl = {
        let v = UISegmentedControl(items: [DateHelper.Hemisphere.Northern.rawValue, DateHelper.Hemisphere.Southern.rawValue])
        v.backgroundColor = .cream2
        v.tintColor = .cream1
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var saveButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        v.backgroundColor = .grass1
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 2.5
        v.titleLabel?.numberOfLines = 2
        v.layer.borderColor = UIColor.grass1.cgColor
        v.titleLabel?.textAlignment = .center
        v.setTitleColor(UIColor.white, for: .normal)
        v.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        v.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        v.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .callout).pointSize, weight: .semibold)
        v.setTitle("Save", for: .normal)
        return v
    }()
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDict = UDEngine.shared.getUser()
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
        
        userDict = UDEngine.shared.getUser()
        favouritesManager = DataPersistEngine()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Modify the UI
    private func setBar() {
        self.configureNavigationBar(title: "Edit info", preferredLargeTitle: false)
        
        self.view.backgroundColor = .cream1
        self.view.tintColor = .dirt1
        let close = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupProfile() {
        userDict = UDEngine.shared.getUser()
        
        nameTF.text = userDict["name"]
        islandNameTF.text = "\(userDict["islandName"] ?? "")"
        selectedFruit = userDict["nativeFruit"] ?? ""
        fruitLabel.attributedText = renderFruitLabel(text: userDict["nativeFruit"] ?? "Not selected")
        hemispherePicker.selectedSegmentIndex = userDict["hemisphere"] == DateHelper.Hemisphere.Northern.rawValue ? 0 : 1
        selectedHemisphere = userDict["hemisphere"].map { DateHelper.Hemisphere(rawValue: $0) ?? DateHelper.Hemisphere.Southern } == nil ? DateHelper.Hemisphere.Southern : userDict["hemisphere"].map { DateHelper.Hemisphere(rawValue: $0)! }
        if let img = UserPersistEngine.loadImage() {
            profileImageView.image = img
        }
    }
    
    // MARK: - Set the views
    private func setUI() {
        self.view.addSubview(scrollView)
        
        // Create master stackView
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .center, distribution: .equalSpacing)
        mStackView.translatesAutoresizingMaskIntoConstraints = false

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

        fruitStack = SVHelper.createSV(axis: .horizontal, spacing: 10, alignment: .center, distribution: .fillProportionally)
        fruitStack.translatesAutoresizingMaskIntoConstraints = false
        fruitStack.addArrangedSubview(fruitLabel)
        fruitStack.addArrangedSubview(nativeFruitButton)

        hemispherePicker.addTarget(self, action: #selector(hemispherePickerChanged), for: .valueChanged)
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        mStackView.addArrangedSubview(imgWrapper, withMargin: UIEdgeInsets(top: MARGIN*4, left: 0, bottom: 0, right: 0))
        mStackView.addArrangedSubview(nameTF)
        mStackView.addArrangedSubview(islandNameTF)
        mStackView.addArrangedSubview(hemispherePicker)
        mStackView.addArrangedSubview(fruitStack)
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
            UDEngine.shared.saveUser(user: user)
            
            // Save user image
            if let img = self.profileImageView.image {
                UserPersistEngine.saveImage(image: img)
            }
            
            Taptic.successTaptic()
            self.closeTapped()
        } else {            
            let alert = AlertHelper.createDefaultAction(title: "Oh bummer!", message: "Please make sure you did not leave any textfields empty!")
            self.present(alert, animated: true)
            Taptic.errorTaptic()
        }

    }
    
    @objc private func fruitPicker(sender: UIButton!) {
        let FRUIT_ID = "FruitsVC"
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: FRUIT_ID) as! FruitsTableViewController
        vc.fruitsDelegate = self
        vc.userFruit = selectedFruit
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
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
            
            nameTF.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor, multiplier: 0.7),
            islandNameTF.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor, multiplier: 0.7),
            fruitStack.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor, multiplier: 0.7),
            saveButton.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor, multiplier: 0.7),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 130),
            profileImageView.heightAnchor.constraint(equalToConstant: 130),
            
            imgWrapper.widthAnchor.constraint(equalToConstant: 130),
            imgWrapper.heightAnchor.constraint(equalToConstant: 130),
            iconView.widthAnchor.constraint(equalTo: self.profileImageView.widthAnchor, multiplier: itemImageViewSize - 0.12),
            iconView.heightAnchor.constraint(equalTo: self.profileImageView.widthAnchor, multiplier: itemImageViewSize - 0.12),
            
            iconView.rightAnchor.constraint(equalTo: imgWrapper.rightAnchor),
            iconView.bottomAnchor.constraint(equalTo: imgWrapper.bottomAnchor)
            
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
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.fruitLabel.font.pointSize, weight: .semibold)]
        let attributedString = NSMutableAttributedString(string: boldText, attributes: attrs)

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
