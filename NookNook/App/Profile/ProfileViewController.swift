//
//  ProfileViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 19/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var favouritesManager: PersistEngine!
    private var user: User!
    
    
    private let VARIANT_CELL = "VariantCell"
    private let SETTING_ID = "SettingsVC"
    
    private let MARGIN: CGFloat = 10
    
    private var scrollView: UIScrollView!
    private var mStackView: UIStackView!
    
    private var profileNameStackView: UIStackView!
    private var nameStackView: UIStackView!
    private var passportStackView: UIStackView!
    private var residentStack: UIStackView!
    private var phraseStack: UIStackView!
    
    private var goToFavButton: UIButton!
    
    var phraseLabel: UILabel!
    
    var profileImageView: UIImageView!
    var profileNameLabel: UILabel!
    var islandNameLabel: UILabel!
    var nativeFruitLabel: UILabel!
    var residentLabel: UILabel!
    let variationImageCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouritesManager = PersistEngine()
        
        setBar()
        setUI()
        setConstraint()
        
        setupProfile()
        
        self.variationImageCollectionView.register(ResidentCollectionViewCell.self, forCellWithReuseIdentifier: VARIANT_CELL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.variationImageCollectionView.reloadData()
        }
        favouritesManager = PersistEngine()
        
        residentLabel.text = "Your Resident: \(self.favouritesManager.residentVillagers.count)/10"
        
    }
    
    // Modify the UI
    private func setBar() {
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Profile", preferredLargeTitle: true)
        
        self.view.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        self.view.tintColor = .white
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(IconUtil.systemIcon(of: .gear, weight: .regular), for: .normal)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func settingsButtonPressed() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: SETTING_ID) as! SettingsTableViewController
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
    func setupProfile() {
        profileNameLabel.text = static_user.name
        islandNameLabel.text = "\(static_user.islandName) 🏝"
        nativeFruitLabel.text = static_user.nativeFruit
        profileImageView.image = UIImage(named: "profile")
        
        phraseLabel.text = "Good \(DateHelper.renderGreet())!\nIt's \(DateHelper.renderSeason(hemisphere: static_user.hemisphere)) ━ \(DateHelper.renderDate())."
        
    }
    
    private func setUI() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        
        // Create master stackView
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .center, distribution: .equalSpacing)
        
        // Name stack view
        nameStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fill)
        
        profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        profileNameLabel = UILabel()
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        profileNameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        profileNameLabel.font = UIFont.systemFont(ofSize: profileNameLabel.font.pointSize, weight: .semibold)
        
        nameStackView.addArrangedSubview(profileNameLabel)
        
        profileNameStackView = SVHelper.createSV(axis: .horizontal, spacing: MARGIN * 2, alignment: .center, distribution: .fill)
        profileNameStackView.addArrangedSubview(profileImageView, withMargin: UIEdgeInsets(top: 0, left: MARGIN*4, bottom: 0, right: 0))
        profileNameStackView.addArrangedSubview(nameStackView)
        
        
        // phrase
        phraseLabel = UILabel()
        phraseLabel.numberOfLines = 0
        phraseLabel.translatesAutoresizingMaskIntoConstraints = false
        phraseLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        phraseLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        
        phraseStack = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fillEqually)
        phraseStack.addArrangedSubview(phraseLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 2, bottom: 0, right: 0))
        
        
        // Passport
        passportStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .fill, distribution: .equalSpacing)
        passportStackView.isLayoutMarginsRelativeArrangement = true
        passportStackView.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*2, bottom: 0, right: MARGIN*2)
        
        islandNameLabel = UILabel()
        islandNameLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        
        nativeFruitLabel = UILabel()
        nativeFruitLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        
        passportStackView.addArrangedSubview(createSV(title: "Island Name", with: islandNameLabel))
        passportStackView.addArrangedSubview(createSV(title: "Native Fruit", with: nativeFruitLabel))
        
        
        residentStack = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fill)
        
        residentLabel = UILabel()
        residentLabel.text = "Your Resident"
        residentLabel.numberOfLines = 0
        residentLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        residentLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        variationImageCollectionView.setCollectionViewLayout(calculateCVLayout(), animated: true)
        variationImageCollectionView.delegate = self
        variationImageCollectionView.dataSource = self
        variationImageCollectionView.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
        
        
        residentStack.addArrangedSubview(residentLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 2, bottom: 0, right: 0))
        residentStack.addArrangedSubview(variationImageCollectionView)
        
        
        // Go to fav VC Button
        goToFavButton = UIButton()
        goToFavButton.translatesAutoresizingMaskIntoConstraints = false
        goToFavButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
        goToFavButton.backgroundColor = UIColor(named: ColourUtil.grassBtn.rawValue)
        goToFavButton.layer.borderWidth = 1
        goToFavButton.titleLabel?.textAlignment = .center
        goToFavButton.layer.borderColor = UIColor(named: ColourUtil.grassBtn.rawValue)?.cgColor
        goToFavButton.layer.cornerRadius = 2.5
        goToFavButton.setTitleColor(UIColor(named: ColourUtil.grass2.rawValue), for: .normal)
        goToFavButton.setTitleColor(UIColor(named: ColourUtil.grass2.rawValue)?.withAlphaComponent(0.5), for: .highlighted)
        goToFavButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        goToFavButton.titleLabel?.font = UIFont.systemFont(ofSize: (goToFavButton.titleLabel?.font.pointSize)!, weight: .semibold)
        goToFavButton.setTitle("Favourites", for: .normal)
        goToFavButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        
        
        mStackView.addArrangedSubview(profileNameStackView, withMargin: UIEdgeInsets(top: MARGIN*4, left: 0, bottom: 0, right: 0))
        mStackView.addArrangedSubview(phraseStack)
        mStackView.addArrangedSubview(passportStackView)
        mStackView.addArrangedSubview(residentStack)
        mStackView.addArrangedSubview(goToFavButton)
        scrollView.addSubview(mStackView)
    }
    
    @objc private func favouriteButtonTapped(sender: UIButton!) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesTableViewController
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
    private func setConstraint() {
        let itemImageViewSize: CGFloat = 0.25
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            
            mStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -MARGIN * 2),
            mStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            profileNameStackView.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            phraseStack.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            passportStackView.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            goToFavButton.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor, multiplier: 0.7),
            
            profileImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize),
            profileImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize),
            
            residentStack.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            
            variationImageCollectionView.widthAnchor.constraint(equalTo: self.residentStack.widthAnchor),
            variationImageCollectionView.heightAnchor.constraint(equalToConstant: 140),
            
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
    
    func calculateCVLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(0.3),
                                               heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(section: section, configuration:config)
        
        return layout
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (favouritesManager.residentVillagers.count == 0) {
            collectionView.setEmptyMessage("Swipe right and press Resident to\nadd a villager to your resident collection!")
        } else {
            collectionView.restore()
        }

        return favouritesManager.residentVillagers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VARIANT_CELL, for: indexPath) as! ResidentCollectionViewCell
        
        cell.variantImage.sd_setImage(with: ImageEngine.parseAcnhURL(with: self.favouritesManager.residentVillagers[indexPath.row].image, of: Categories.villagers.rawValue, mediaType: .icons), completed: nil)
        
        cell.variantName.text = self.favouritesManager.residentVillagers[indexPath.row].name
        
        return cell
    }
}
