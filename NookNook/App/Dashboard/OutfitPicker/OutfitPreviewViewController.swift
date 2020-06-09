//
//  OutfitPreviewViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 9/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class OutfitPreviewViewController: UIViewController {

    private let mScrollView: UIScrollView = {
        let v = UIScrollView()
        v.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let logoImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "launchscreen")
        return v
    }()
    private let mSV = SVHelper.createSV(axis: .vertical, spacing: 5, alignment: .center, distribution: .equalSpacing)
    private let buttonSV = SVHelper.createSV(axis: .horizontal, spacing: 10, alignment: .center, distribution: .equalSpacing)
    private var saveButton: UIButton = {
        let v = UIButton()
        v.setTitle("Save to photo library", for: .normal)
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        v.backgroundColor = .grass1
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 2.5
        v.titleLabel?.numberOfLines = 2
        v.layer.borderColor = UIColor.grass1.cgColor
        v.titleLabel?.textAlignment = .center
        v.setTitleColor(UIColor.white, for: .normal)
        v.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        v.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        v.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .semibold)
        
        return v
    }()
    
    var selectedOutfit: [Wardrobe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBar()
        setupView()
        setupConstraint()
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "", preferredLargeTitle: false)
        self.view.backgroundColor = .cream1
        self.view.tintColor = .white
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    private func setupView() {
        logoImageView.alpha = 0.25
        self.view.addSubview(logoImageView)
        self.view.addSubview(mScrollView)
        mScrollView.addSubview(mSV)
        
        for outfit in selectedOutfit {
            let outfitImageView = UIImageView()
            outfitImageView.contentMode = .scaleAspectFit
            outfitImageView.sd_setImage(with: ImageEngine.parseNPURL(with: outfit.image!, category: outfit.category), placeholderImage: UIImage(named: "placeholder"))
            
            outfitImageView.snp.makeConstraints { (make) in
                make.height.width.equalTo(self.view.frame.width * 0.25)
            }
            
            mSV.addArrangedSubview(outfitImageView)
        }
        
        mSV.addArrangedSubview(saveButton, withMargin: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    private func setupConstraint() {
        logoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mSV.snp.makeConstraints { (make) in
            make.top.left.width.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10 * 2)
        }
        
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
