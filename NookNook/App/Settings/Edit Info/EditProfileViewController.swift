//
//  EditProfileViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 25/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    private var userDict = UDEngine.shared.getUser()
    private var selectedFruit: String!
    private var selectedHemisphere: DateHelper.Hemisphere!
    private var imagePicker = UIImagePickerController()
    
    private let mScrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let mStackView = SVHelper.createSV(axis: .vertical, spacing: 20, alignment: .center, distribution: .fill)
    private let userProfileImageView: UIImageView = {
        let v = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        v.image = UIImage(named: "appIcon-Ori")
        v.contentMode = .scaleAspectFit
        v.layer.cornerRadius = 100 / 2
        v.clipsToBounds = true
        return v
    }()
    private let editProfileImageButton: UIButton = {
        let v = UIButton()
        v.setTitle("Edit profile photo", for: .normal)
        v.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        v.setTitleColor(.grass1, for: .normal)
        return v
    }()
    private let nameTextfield: UITextField = {
        let v = UITextField()
        v.placeholder = "NookNook"
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 5
        v.layer.cornerCurve = .continuous
        v.layer.borderColor = UIColor.dirt1.withAlphaComponent(0.3).cgColor
        v.backgroundColor = .clear
        v.font = .preferredFont(forTextStyle: .callout)
        v.font = .preferredFont(forTextStyle: .body)
        v.borderStyle = .roundedRect
        return v
    }()
    private let islandTextfield: UITextField = {
        let v = UITextField()
        v.placeholder = "My island"
        v.layer.borderWidth = 1
        v.font = .preferredFont(forTextStyle: .callout)
        v.layer.cornerRadius = 5
        v.layer.cornerCurve = .continuous
        v.layer.borderColor = UIColor.dirt1.withAlphaComponent(0.3).cgColor
        v.backgroundColor = .clear
        v.font = .preferredFont(forTextStyle: .body)
        v.borderStyle = .roundedRect
        return v
    }()
    private let hemisphereSelector: UISegmentedControl = {
        let v = UISegmentedControl(items: [DateHelper.Hemisphere.Northern.rawValue, DateHelper.Hemisphere.Southern.rawValue])
        v.backgroundColor = .cream2
        v.tintColor = .cream1
        return v
    }()
    private let nativeFruitLabel: UILabel = {
        let v = UILabel()
        v.textColor = .dirt1
        v.text = "Native fruit: none"
        return v
    }()
    private let changeFruitButton: UIButton = {
        let v = UIButton()
        v.setTitle("Change fruit", for: .normal)
        v.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        v.setTitleColor(.grass1, for: .normal)
        return v
    }()
    private let saveButton: UIButton = {
        let v = UIButton()
        v.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        v.backgroundColor = .grass1
        v.layer.cornerRadius = 2.5
        v.setTitleColor(UIColor.white, for: .normal)
        v.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        v.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .callout).pointSize, weight: .semibold)
        v.setTitle("Save", for: .normal)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBar()
        
        setupView()
        setupConstraint()
        
        setupProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        userDict = UDEngine.shared.getUser()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Setup the View
    private func setupView() {
        view.addSubview(mScrollView)
        
        mScrollView.addSubview(userProfileImageView)
        
        mScrollView.addSubview(mStackView)
        mStackView.addArrangedSubview(editProfileImageButton)
        
        mStackView.setCustomSpacing(40, after: editProfileImageButton)
        mStackView.addArrangedSubview(hemisphereSelector)
        mStackView.addArrangedSubview(createSVWithLabel(textfield: nameTextfield, title: "Name"))
        mStackView.addArrangedSubview(createSVWithLabel(textfield: islandTextfield, title: "Island name 🏝"))
        mStackView.addArrangedSubview(nativeFruitLabel)
        
        mStackView.setCustomSpacing(40, after: nativeFruitLabel)
        
        mStackView.addArrangedSubview(changeFruitButton)
        mStackView.setCustomSpacing(10, after: changeFruitButton)
        mStackView.addArrangedSubview(saveButton)
        
        // Targets adding to buttons and selector
        editProfileImageButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        changeFruitButton.addTarget(self, action: #selector(changeFruitButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        hemisphereSelector.addTarget(self, action: #selector(hemispherePickerChanged), for: .valueChanged)
        
        nameTextfield.delegate = self
        islandTextfield.delegate = self
    }
    
    private func setupConstraint() {
        mScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.top.equalTo(userProfileImageView.snp.bottom).inset(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
            make.left.width.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10 * 2)
        }
        
        userProfileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        nameTextfield.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.8)
        }
        
        islandTextfield.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.8)
        }
        
        hemisphereSelector.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.8)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.8)
            make.height.equalTo(40)
        }
    }
    
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
        nameTextfield.text = userDict["name"]
        islandTextfield.text = "\(userDict["islandName"] ?? "")"
        selectedFruit = userDict["nativeFruit"] ?? ""
        nativeFruitLabel.attributedText = renderFruitLabel(text: userDict["nativeFruit"] ?? "Not selected")
        hemisphereSelector.selectedSegmentIndex = userDict["hemisphere"] == DateHelper.Hemisphere.Northern.rawValue ? 0 : 1
        selectedHemisphere = userDict["hemisphere"].map { DateHelper.Hemisphere(rawValue: $0) ?? DateHelper.Hemisphere.Southern } == nil ? DateHelper.Hemisphere.Southern : userDict["hemisphere"].map { DateHelper.Hemisphere(rawValue: $0)! }
        
        if let img = UserPersistEngine.loadImage() {
            userProfileImageView.image = img
        }
    }
    
    @objc private func editProfileButtonTapped() {
        let uploadAction = UIAlertAction(title: "Upload a photo", style: .default) { [weak self] (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self?.imagePicker.delegate = self
                self?.imagePicker.sourceType = .photoLibrary
                self?.imagePicker.allowsEditing = true
                self?.present(self!.imagePicker, animated: true, completion: nil)
            }
        }
        
        let removeAction = UIAlertAction(title: "Remove photo", style: .destructive) { [weak self] (_) in
            self?.userProfileImageView.image = UIImage(named: "appIcon-Ori")
        }
        
        let alert = AlertHelper.createCustomAction(actions: [uploadAction, removeAction])
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func changeFruitButtonTapped() {
        let vc = FruitsTableViewController(style: .insetGrouped)
        vc.fruitsDelegate = self
        vc.userFruit = selectedFruit
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        if !nameTextfield.text!.trimmingCharacters(in: .whitespaces).isEmpty &&
            !islandTextfield.text!.trimmingCharacters(in: .whitespaces).isEmpty &&
            !selectedFruit.isEmpty {
            let user = User(name: nameTextfield.text!, islandName: islandTextfield.text!, nativeFruit: selectedFruit, hemisphere: selectedHemisphere)
            UDEngine.shared.saveUser(user: user)
            
            // Save the image
            if let img = self.userProfileImageView.image {
                UserPersistEngine.saveImage(image: img)
            }
            
            Taptic.successTaptic()
            self.closeTapped()
        } else {
            let alert = AlertHelper.createDefaultAction(title: "Oh bummer!", message: "Please make sure you did not leave any textfields and selections empty!")
            self.present(alert, animated: true, completion: nil)
            Taptic.errorTaptic()
        }
    }
    
    @objc private func hemispherePickerChanged(_ sender: UISegmentedControl) {
        Taptic.lightTaptic()
        selectedHemisphere = sender.selectedSegmentIndex == 0 ? .Northern : .Southern
    }
    
    private func renderFruitLabel(text: String) -> NSMutableAttributedString {
        let boldText = "Native fruit: "
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.nativeFruitLabel.font.pointSize, weight: .semibold)]
        let attributedString = NSMutableAttributedString(string: boldText, attributes: attrs)
        
        let normalString = NSMutableAttributedString(string: text)
        
        attributedString.append(normalString)
        return attributedString
    }
    
    private func createSVWithLabel(textfield: UITextField, title: String) -> UIStackView {
        let sv = SVHelper.createSV(axis: .vertical, spacing: 10, alignment: .leading, distribution: .fillProportionally)
        
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        
        sv.addArrangedSubview(label)
        sv.addArrangedSubview(textfield)
        
        sv.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.8)
        }
        
        return sv
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        mStackView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10 * 30)
        }
        mScrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        mScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        mStackView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10 * 2)
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.dirt1.withAlphaComponent(0.8).cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.dirt1.withAlphaComponent(0.3).cgColor
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image: UIImage!
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
            self.userProfileImageView.image = image
            
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
            self.userProfileImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: FruitsDelegate {
    func changeFruit(fruit: Fruits) {
        selectedFruit = fruit.rawValue
        self.nativeFruitLabel.attributedText = renderFruitLabel(text: selectedFruit)
        
    }
}
