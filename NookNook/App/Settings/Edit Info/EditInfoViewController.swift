//
//  EditInfoViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 20/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import TweeTextField

class EditInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let MARGIN: CGFloat = 10
    
    private var scrollView: UIScrollView!
    private var mStackView: UIStackView!
    
    private var labelSV: UIStackView!
    private var profileNameStackView: UIStackView!
    
    private var favouritesManager: PersistEngine!
    
    var iconView: UIImageView!
    var imgWrapper: UIView!
    
    var profileImageView: UIImageView!
    var nameTF: TweeBorderedTextField!
    var islandNameTF: TweeBorderedTextField!
    var nativeFruitButton: UIButton!
    var fruitLabel: UILabel!
    
    var saveButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        setUI()
        setConstraint()
        
        setupProfile()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgWrapper.isUserInteractionEnabled = true
        imgWrapper.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        favouritesManager = PersistEngine()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
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
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Edit Info", preferredLargeTitle: false)
        
        self.view.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        self.view.tintColor = .white
        
        let close = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    func setupProfile() {
        nameTF.text = static_user.name
        islandNameTF.text = static_user.islandName
        fruitLabel.attributedText = renderFruitLabel(text: static_user.nativeFruit)
//        profileImageView.image = UIImage(named: "profile")
    }
    
    private func setUI() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        
        // Create master stackView
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .center, distribution: .equalCentering)
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
        
        
        iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image =  IconUtil.systemIcon(of: .edit, weight: .regular).withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor(named: ColourUtil.dirt1.rawValue)
        
        imgWrapper = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imgWrapper.translatesAutoresizingMaskIntoConstraints = false
        imgWrapper.addSubview(profileImageView)
        imgWrapper.addSubview(iconView)
        
        
        nameTF = TweeBorderedTextField()
        nameTF.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        nameTF.lineColor = (UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.8))!
        nameTF.lineWidth = 1
        nameTF.minimumPlaceholderFontSize = 11
        nameTF.originalPlaceholderFontSize = nameTF.font!.pointSize
        nameTF.placeholderDuration = 0.2
        nameTF.placeholderColor = (UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5))!
        nameTF.tweePlaceholder = "Name"

        
        islandNameTF = TweeBorderedTextField()
        islandNameTF.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        islandNameTF.lineColor = (UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.8))!
        islandNameTF.lineWidth = 1
        islandNameTF.minimumPlaceholderFontSize = 11
        islandNameTF.originalPlaceholderFontSize = nameTF.font!.pointSize
        islandNameTF.placeholderDuration = 0.2
        islandNameTF.placeholderColor = (UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5))!
        islandNameTF.tweePlaceholder = "Island Name"
        
        profileNameStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .leading, distribution: .fill)
        profileNameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        labelSV = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 2, alignment: .center, distribution: .fillProportionally)
        labelSV.translatesAutoresizingMaskIntoConstraints = false

        fruitLabel = UILabel()
        fruitLabel.translatesAutoresizingMaskIntoConstraints = false
        fruitLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        fruitLabel.numberOfLines = 2
        
        nativeFruitButton = UIButton()
        nativeFruitButton.translatesAutoresizingMaskIntoConstraints = false
        nativeFruitButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        nativeFruitButton.backgroundColor = UIColor(named: ColourUtil.grassBtn.rawValue)
        nativeFruitButton.layer.borderWidth = 1
        nativeFruitButton.titleLabel?.numberOfLines = 2
        nativeFruitButton.layer.borderColor = UIColor(named: ColourUtil.grassBtn.rawValue)?.cgColor
        nativeFruitButton.layer.cornerRadius = 2.5
        nativeFruitButton.titleLabel?.textAlignment = .center
        nativeFruitButton.setTitleColor(UIColor(named: ColourUtil.grass2.rawValue), for: .normal)
        nativeFruitButton.setTitleColor(UIColor(named: ColourUtil.grass2.rawValue)?.withAlphaComponent(0.5), for: .highlighted)
        nativeFruitButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        nativeFruitButton.titleLabel?.font = UIFont.systemFont(ofSize: (nativeFruitButton.titleLabel?.font.pointSize)!, weight: .semibold)
        nativeFruitButton.addTarget(self, action: #selector(fruitPicker), for: .touchUpInside)
        nativeFruitButton.setTitle("Change fruit", for: .normal)
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        saveButton.backgroundColor = UIColor(named: ColourUtil.grass2.rawValue)
        saveButton.layer.borderWidth = 1
        saveButton.titleLabel?.numberOfLines = 2
        saveButton.layer.borderColor = UIColor(named: ColourUtil.grass2.rawValue)?.cgColor
        saveButton.titleLabel?.textAlignment = .center
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        saveButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: (nativeFruitButton.titleLabel?.font.pointSize)!, weight: .semibold)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveButton.setTitle("Save", for: .normal)

        labelSV.addArrangedSubview(nameTF)
        labelSV.addArrangedSubview(islandNameTF, withMargin: UIEdgeInsets(top: MARGIN, left: 0, bottom: 0, right: 0))
        labelSV.addArrangedSubview(fruitLabel)
        labelSV.addArrangedSubview(nativeFruitButton)
        

        profileNameStackView.addArrangedSubview(imgWrapper, withMargin: UIEdgeInsets(top: 0, left: MARGIN*4, bottom: 0, right: 0))
        profileNameStackView.addArrangedSubview(labelSV, withMargin: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        mStackView.addArrangedSubview(profileNameStackView, withMargin: UIEdgeInsets(top: MARGIN*4, left: 0, bottom: 0, right: 0))
        mStackView.addArrangedSubview(saveButton)
        
        scrollView.addSubview(mStackView)
    }
    
    @objc private func saveTapped(sender: UIButton!) {
        
    }
    
    @objc private func fruitPicker(sender: UIButton!) {
        let alert = UIAlertController(title: "Pick your native fruit", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: Fruits.apples.rawValue, style: .default , handler:{ (UIAlertAction)in
            let selectedFruit = Fruits.apples.rawValue
            self.fruitLabel.attributedText = self.renderFruitLabel(text: selectedFruit)
            Taptic.lightTaptic()
        }))
        
        alert.addAction(UIAlertAction(title: Fruits.cherries.rawValue, style: .default , handler:{ (UIAlertAction)in
            let selectedFruit = Fruits.cherries.rawValue
            self.fruitLabel.attributedText = self.renderFruitLabel(text: selectedFruit)
            Taptic.lightTaptic()
        }))
        
        alert.addAction(UIAlertAction(title: Fruits.coconuts.rawValue, style: .default , handler:{ (UIAlertAction)in
            let selectedFruit = Fruits.coconuts.rawValue
            self.fruitLabel.attributedText = self.renderFruitLabel(text: selectedFruit)
            Taptic.lightTaptic()
        }))
        
        alert.addAction(UIAlertAction(title: Fruits.peaches.rawValue, style: .default , handler:{ (UIAlertAction)in
            let  selectedFruit = Fruits.peaches.rawValue
            self.fruitLabel.attributedText = self.renderFruitLabel(text: selectedFruit)
            Taptic.lightTaptic()
        }))
        
        alert.addAction(UIAlertAction(title: Fruits.oranges.rawValue, style: .default , handler:{ (UIAlertAction)in
            let  selectedFruit = Fruits.oranges.rawValue
            self.fruitLabel.attributedText = self.renderFruitLabel(text: selectedFruit)
            Taptic.lightTaptic()
        }))
        
        alert.addAction(UIAlertAction(title: Fruits.pears.rawValue, style: .default , handler:{ (UIAlertAction)in
            let selectedFruit = Fruits.pears.rawValue
            self.fruitLabel.attributedText = self.renderFruitLabel(text: selectedFruit)
            Taptic.lightTaptic()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func imageTapped(sender: UIButton!) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesTableViewController
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
    private func setConstraint() {
        let itemImageViewSize: CGFloat = 0.25
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: MARGIN),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            
            mStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mStackView.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor, constant: -MARGIN),
            mStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profileNameStackView.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            labelSV.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            
            nameTF.widthAnchor.constraint(equalTo: self.labelSV.widthAnchor, multiplier: 0.8),
            islandNameTF.widthAnchor.constraint(equalTo: self.labelSV.widthAnchor, multiplier: 0.8),
            nativeFruitButton.widthAnchor.constraint(equalTo: self.labelSV.widthAnchor, multiplier: 0.8),
            saveButton.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            
            profileImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize),
            profileImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize),
            
            imgWrapper.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize * 1.05),
            imgWrapper.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize * 1.05),
            iconView.widthAnchor.constraint(equalTo: self.profileImageView.widthAnchor, multiplier: itemImageViewSize),
            iconView.heightAnchor.constraint(equalTo: self.profileImageView.widthAnchor, multiplier: itemImageViewSize),
            
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
        label1.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
        
        stackView.addBackground(color: UIColor(named: ColourUtil.cream1.rawValue)!, cornerRadius: 5)
        
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
