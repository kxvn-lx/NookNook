//
//  EditProfileViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 25/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    private var userDict = UDEngine.shared.getUser()
    
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
        return v
    }()
    private let editProfileImageButton: UIButton = {
        let v = UIButton()
        v.setTitle("Upload a photo", for: .normal)
        v.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        v.setTitleColor(.grass1, for: .normal)
        return v
    }()
    private let nameTextfield: UITextField = {
        let v = UITextField()
        v.placeholder = "Name"
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 5
        v.layer.cornerCurve = .continuous
        v.layer.borderColor = UIColor.dirt1.withAlphaComponent(0.3).cgColor
        v.backgroundColor = .clear
        v.font = .preferredFont(forTextStyle: .body)
        v.borderStyle = .roundedRect
        return v
    }()
    private let islandTextfield: UITextField = {
        let v = UITextField()
        v.placeholder = "Island name"
        v.layer.borderWidth = 1
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
    
    // MARK: - Setup the View
    private func setupView() {
        view.addSubview(mScrollView)
        
        mScrollView.addSubview(userProfileImageView)
        
        mScrollView.addSubview(mStackView)
        mStackView.addArrangedSubview(editProfileImageButton)
        
        mStackView.setCustomSpacing(40, after: editProfileImageButton)
        
        mStackView.addArrangedSubview(nameTextfield)
        mStackView.addArrangedSubview(islandTextfield)
        mStackView.addArrangedSubview(hemisphereSelector)
        mStackView.addArrangedSubview(nativeFruitLabel)
        
        mStackView.setCustomSpacing(40, after: nativeFruitLabel)
        
        mStackView.addArrangedSubview(changeFruitButton)
        mStackView.setCustomSpacing(10, after: changeFruitButton)
        mStackView.addArrangedSubview(saveButton)
        
        editProfileImageButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        changeFruitButton.addTarget(self, action: #selector(changeFruitButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        nameTextfield.delegate = self
        islandTextfield.delegate = self
    }
    
    private func setupConstraint() {
        mScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.top.equalTo(userProfileImageView.snp.bottom).inset(UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
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
        
    }
    
    @objc private func editProfileButtonTapped() {
        print("Edit profile...")
    }
    
    @objc private func changeFruitButtonTapped() {
        print("Changing fruit...")
    }
    
    @objc private func saveButtonTapped() {
        print("saveButtonTapped")
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
