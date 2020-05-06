//
//  DetailViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 14/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class DetailViewController: UIViewController {
    
    private var favouriteManager = DataPersistEngine()
    
    // Constants
    private let MARGIN: CGFloat = 10
    internal let VARIANT_CELL = "VariantCell"
    
    // Containers
    private var scrollView: UIScrollView!
    // Master StackView that holds all view
    private var mStackView: UIStackView!
    // tsStackView - Title and subtitle stackview.
    private var tsStackView: UIStackView!
    // Stackview to hold all the rest of the informations
    private var infoStackView: UIStackView!
    
    /// Objects
    internal var itemObj: Item!
    internal var critterObj: Critter!
    internal var wardrobeObj: Wardrobe!
    internal var villagerObj: Villager!
    
    internal var groupOrigin: DataEngine.Group!
    
    internal var detailImageView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var sourceNoteLabel: UILabel!
    private var titleRarityStack: UIStackView!
    private var buyLabel: UILabel!
    private var sellLabel: UILabel!
    private var specialSellLabel: UILabel!
    private var weatherLabel: UILabel!
    private var rarityLabel: UIButton!
    private var activeTimeN: UILabel!
    private var activeTimeS: UILabel!
    private var timeLabel: UILabel!
    
    private var firstIconLabel: PaddingLabel!
    private var secondIconLabel: PaddingLabel!
    
    private var iconStackView: UIStackView!
    private var activeTimeSStack: UIStackView!
    private var activeTimeNStack: UIStackView!
    private var buyStack: UIStackView!
    private var sellStack: UIStackView!
    private var specialSellStack: UIStackView!
    private var weatherStack: UIStackView!
    private var activeTimeStack: UIStackView!
    private var timeStack: UIStackView!
    private var variationStack: UIStackView!
    private var variationTitleLabel: UILabel!
    let variationImageCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    // Google ads banner
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.adUnitID = GoogleAdsHelper.AD_UNIT_ID
        adBannerView.rootViewController = self

        return adBannerView
    }()
    
    lazy var adBannerViewMiddle: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.adUnitID = GoogleAdsHelper.AD_UNIT_ID
        adBannerView.rootViewController = self

        return adBannerView
    }()



    // MARK: - Tableview init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        setupView()
        setupConstraint()
        
        renderObj()
        
        self.variationImageCollectionView.register(VariantCollectionViewCell.self, forCellWithReuseIdentifier: VARIANT_CELL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !UDEngine.shared.getIsAdsPurchased() {
            self.view.addSubview(adBannerView)
            adBannerView.load(GADRequest())
            NSLayoutConstraint.activate([
                adBannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                adBannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            ])
        } else {
            adBannerView.removeFromSuperview()
        }
    }
    
    /**
     Method to parse an object provided from a VC, and treat them as to their own unique type.
     - Parameters:
        - group: The group that the method is being called. ie: Items, Critters, Wardrobes, etc
        - object: An object of Any type, which the method will then typecast it to the selected type.
     */
    func parseOject(from group: DataEngine.Group, object: Any) {
        
        switch group {
        case .items:
            self.itemObj = object as? Item
            self.groupOrigin = .items
            
        case .critters:
            self.critterObj = object as? Critter
            self.groupOrigin = .critters
            
        case .wardrobes:
            self.wardrobeObj = object as? Wardrobe
            self.groupOrigin = .wardrobes
            
        case .villagers:
            self.villagerObj = object as? Villager
            self.groupOrigin = .villagers
        }
        
    }
    
    /// Method to render each object accordingly (hides the component that is not dependent to each group.
    private func renderObj() {
        switch groupOrigin {
        case .items:
            renderItem()
            activeTimeStack.isHidden = true
            weatherStack.isHidden = true
            rarityLabel.isHidden = true
            specialSellStack.isHidden = true
            iconStackView.isHidden = true
            timeStack.isHidden = true
            
        case .critters:
            renderCritter()
            variationStack.isHidden = true
            buyStack.isHidden = true
            
        case .wardrobes:
            renderWardrobe()
            iconStackView.isHidden = true
            activeTimeStack.isHidden = true
            weatherStack.isHidden = true
            rarityLabel.isHidden = true
            specialSellStack.isHidden = true
            timeStack.isHidden = true
            
        case .villagers:
            renderVillager()
            firstIconLabel.isHidden = true
            variationStack.isHidden = true
            activeTimeStack.isHidden = true
            specialSellStack.isHidden = true
            sourceNoteLabel.isHidden = true
            timeStack.isHidden = true
            let species = sellStack.viewWithTag(1) as! UILabel
            species.text = "Species"
            
            let bday = buyStack.viewWithTag(1) as! UILabel
            bday.text = "Birthday"
            
            let gender = weatherStack.viewWithTag(1) as! UILabel
            gender.text = "Gender"
            
            
            
        default: fatalError("Attempt to render an invalid object group or groupOrigin is still nil!")
        }
        
    }
    
    
    
    /// Method to render item object
    private func renderItem() {
        detailImageView.sd_setImage(with: ImageEngine.parseNPURL(with: itemObj.image!, category: itemObj.category), placeholderImage: UIImage(named: "placeholder"))
        titleLabel.text = itemObj.name
        subtitleLabel.text = itemObj.obtainedFrom
        buyLabel.attributedText = PriceEngine.renderPrice(amount: itemObj.buy!, with: .none, of: buyLabel.font.pointSize)
        sellLabel.attributedText = PriceEngine.renderPrice(amount: itemObj.sell!, with: .none, of: buyLabel.font.pointSize)
        sourceNoteLabel.text = itemObj.sourceNote

        
        if itemObj.variants == nil {
            variationImageCollectionView.isHidden = true
            variationTitleLabel.text = "This item has no variations."
            variationTitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }

    /// Method to render critter object
    private func renderCritter() {
        var shadow = critterObj.shadow ?? ""
        if !shadow.isEmpty {
            shadow = shadow.components(separatedBy: " ")[0]
            sourceNoteLabel.text = "Shadow size: \(shadow)"
        }
        
        detailImageView.sd_setImage(with: ImageEngine.parseAcnhURL(with: critterObj.image, of: critterObj.category, mediaType: .images), placeholderImage: UIImage(named: "placeholder"))
        titleLabel.text = critterObj.name
        subtitleLabel.text = critterObj.obtainedFrom
        sellLabel.attributedText = PriceEngine.renderPrice(amount: critterObj.sell!, with: .none, of: sellLabel.font.pointSize)
        let specialSell = critterObj.sell!
        specialSellLabel.attributedText = PriceEngine.renderPrice(amount: Int(Double(specialSell) * 1.5), with: .none, of: buyLabel.font.pointSize)
        weatherLabel.text = critterObj.weather
        rarityLabel.setTitle(critterObj.rarity, for: .normal)
        activeTimeN.text = TimeMonthEngine.renderMonth(monthInString: critterObj.activeMonthsN)
        activeTimeS.text = TimeMonthEngine.renderMonth(monthInString: critterObj.activeMonthsS)
        weatherStack.isHidden = critterObj.weather.isEmpty ? true : false
        timeLabel.text = TimeMonthEngine.formatTime(of: critterObj.time)
        
        firstIconLabel.text = self.favouriteManager.donatedCritters.contains(critterObj) ? "Donated" : ""
        secondIconLabel.text = self.favouriteManager.caughtCritters.contains(critterObj) ? "Caught" : ""
        
        firstIconLabel.isHidden =  self.favouriteManager.donatedCritters.contains(critterObj) ? false : true
        secondIconLabel.isHidden =  self.favouriteManager.caughtCritters.contains(critterObj) ? false : true
        
        if !self.favouriteManager.donatedCritters.contains(critterObj) && !self.favouriteManager.caughtCritters.contains(critterObj) {
            iconStackView.isHidden = true
        } else {
            iconStackView.isHidden = false
        }
    }

    /// Method to render wardrobe  object
    private func renderWardrobe() {
        detailImageView.sd_setImage(with: ImageEngine.parseNPURL(with: wardrobeObj.image!, category: wardrobeObj.category), placeholderImage: UIImage(named: "placeholder"))
        titleLabel.text = wardrobeObj.name
        subtitleLabel.text = wardrobeObj.obtainedFrom
        buyLabel.attributedText = PriceEngine.renderPrice(amount: wardrobeObj.buy!, with: .none, of: buyLabel.font.pointSize)
        sellLabel.attributedText = PriceEngine.renderPrice(amount: wardrobeObj.sell!, with: .none, of: buyLabel.font.pointSize)
        if wardrobeObj.variants == nil {
            variationImageCollectionView.isHidden = true
            variationTitleLabel.text = "This clothing has no variations."
            variationTitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }

    /// Method to render villager object
    private func renderVillager() {
        detailImageView.sd_setImage(with: ImageEngine.parseAcnhURL(with: villagerObj.image, of: villagerObj.category, mediaType: .images), placeholderImage: UIImage(named: "placeholder"))
        titleLabel.text = villagerObj.name
        buyLabel.text = villagerObj.bdayString
        subtitleLabel.text = "Catch-phrase: \(villagerObj.catchphrase)"
        sellLabel.text = villagerObj.species
        weatherLabel.text = villagerObj.gender
        rarityLabel.setTitle(villagerObj.personality, for: .normal)
        
        secondIconLabel.text = self.favouriteManager.residentVillagers.contains(villagerObj) ? "In Resident" : ""
        
        iconStackView.isHidden = self.favouriteManager.residentVillagers.contains(villagerObj) ? false : true

    }

    
    // MARK:- Modify UI
    private func setupView() {
        
        buyStack = UIStackView()
        sellStack = UIStackView()
        weatherStack = UIStackView()
        activeTimeStack = UIStackView()
        
        buyLabel = UILabel()
        sellLabel = UILabel()
        weatherLabel = UILabel()
        activeTimeN = UILabel()
        activeTimeS = UILabel()
        
        titleLabel = UILabel()
        subtitleLabel = UILabel()
        sourceNoteLabel = UILabel()
        rarityLabel = UIButton()
        
        specialSellLabel = UILabel()
        timeLabel = UILabel()
        firstIconLabel = PaddingLabel(withInsets: 5, 5, 10, 10)
        secondIconLabel = PaddingLabel(withInsets: 5, 5, 10, 10)
        
        // create master scrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        // Create master stackView
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .center, distribution: .equalSpacing)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(mStackView)
        
        
        // detailImageView
        detailImageView = UIImageView()
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        detailImageView.contentMode = .scaleAspectFit
        detailImageView.sd_imageTransition = .fade
        detailImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        

        // Object Title and Subtitle stackView
        tsStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .equalSpacing)

        titleRarityStack = SVHelper.createSV(axis: .horizontal, spacing: MARGIN, alignment: .lastBaseline, distribution: .equalSpacing)
        
        
        // Title, subtitle, and sourcenote section
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.font = UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .semibold)
        titleLabel.textColor = .dirt1
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        subtitleLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        sourceNoteLabel.numberOfLines = 0
        sourceNoteLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        sourceNoteLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        
        
        // Rarity section
        rarityLabel.setTitleColor(.darkGray, for: .normal)
        rarityLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        rarityLabel.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rarityLabel.isUserInteractionEnabled = false
        rarityLabel.addBlurEffect(style: .light, cornerRadius: 5, padding: .zero)
        
        titleRarityStack.addArrangedSubview(titleLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 2, bottom: 0, right: 0))
        titleRarityStack.addArrangedSubview(rarityLabel, withMargin: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -MARGIN * 2))
        
        tsStackView.addArrangedSubview(titleRarityStack)
        tsStackView.addArrangedSubview(subtitleLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 2, bottom: 0, right: 0))
        
        firstIconLabel.numberOfLines = 0
        firstIconLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        firstIconLabel.font = UIFont.systemFont(ofSize: firstIconLabel.font.pointSize, weight: .semibold)
        firstIconLabel.textColor =  .white
        firstIconLabel.layer.borderColor = UIColor.grass1.cgColor
        firstIconLabel.backgroundColor = .grass1
        firstIconLabel.layer.borderWidth = 1
        firstIconLabel.layer.cornerRadius = 2.5
        firstIconLabel.clipsToBounds = true
        firstIconLabel.textAlignment = .center
        
        secondIconLabel.numberOfLines = 0
        secondIconLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        secondIconLabel.font = UIFont.systemFont(ofSize: secondIconLabel.font.pointSize, weight: .semibold)
        secondIconLabel.textColor =  .white
        secondIconLabel.layer.borderColor = UIColor.gold1.cgColor
        secondIconLabel.backgroundColor = .gold1
        secondIconLabel.textAlignment = .center
        secondIconLabel.layer.borderWidth = 1
        secondIconLabel.clipsToBounds = true
        secondIconLabel.layer.cornerRadius = 2.5
        
        
        iconStackView = SVHelper.createSV(axis: .horizontal, spacing: MARGIN, alignment: .center, distribution: .fillEqually)
        iconStackView.isLayoutMarginsRelativeArrangement = true
        iconStackView.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*2, bottom: 0, right: MARGIN*2)
        
        iconStackView.addArrangedSubview(firstIconLabel)
        iconStackView.addArrangedSubview(secondIconLabel)
        
        // Info stack views section
        infoStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .fill, distribution: .equalSpacing)
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*2, bottom: 0, right: MARGIN*2)
        
        
        buyLabel.textColor = .gold1
        sellLabel.textColor = .gold1
        specialSellLabel.textColor = .gold1
        weatherLabel.textColor = .gold1
        timeLabel.textColor = .gold1

        buyStack = createInfoStackView(title: "Buy", with: buyLabel)
        sellStack = createInfoStackView(title: "Sell", with: sellLabel)
        specialSellStack = createInfoStackView(title: "Special sell price", with: specialSellLabel)
        timeStack = createInfoStackView(title: "Active time", with: timeLabel)

        if let critterObj = critterObj {
            let t = critterObj.category == Categories.fishes.rawValue ? "CJ sell price" : "Flick sell price"
            specialSellStack = createInfoStackView(title: t, with: specialSellLabel)
        }
        
        weatherStack = createInfoStackView(title: "Weather", with: weatherLabel)
        
        
        
        infoStackView.addArrangedSubview(sourceNoteLabel)
        infoStackView.addArrangedSubview(buyStack)
        infoStackView.addArrangedSubview(sellStack)
        infoStackView.addArrangedSubview(specialSellStack)
        infoStackView.addArrangedSubview(weatherStack)
        infoStackView.addArrangedSubview(timeStack)
        
        
        // Active time period section
        activeTimeStack = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .fill, distribution: .equalSpacing)
        activeTimeStack.isLayoutMarginsRelativeArrangement = true
        activeTimeStack.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*2, bottom: 0, right: MARGIN*2)
        
        
        activeTimeN.textColor = .gold1
        activeTimeS.textColor = .gold1
        activeTimeN.numberOfLines = 0
        activeTimeS.numberOfLines = 0
        activeTimeN.textAlignment = .right
        activeTimeS.textAlignment = .right
        
        activeTimeNStack = createInfoStackView(title: "Northern Hemisphere", with: activeTimeN)
        activeTimeSStack = createInfoStackView(title: "Southern Hemisphere", with: activeTimeS)
        
        let activeTimeLabel = UILabel()
        activeTimeLabel.text = "Active Months"
        activeTimeLabel.numberOfLines = 0
        activeTimeLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        activeTimeLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        
        activeTimeStack.addArrangedSubview(activeTimeLabel)
        activeTimeStack.addArrangedSubview(activeTimeNStack)
        activeTimeStack.addArrangedSubview(activeTimeSStack)

        
        // Variation Section
        variationStack = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fill)
        
        variationTitleLabel = UILabel()
        variationTitleLabel.text = "Variation"
        variationTitleLabel.numberOfLines = 0
        variationTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        variationTitleLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        variationImageCollectionView.setCollectionViewLayout(calculateCVLayout(), animated: true)
        variationImageCollectionView.delegate = self
        variationImageCollectionView.dataSource = self
        variationImageCollectionView.backgroundColor = .cream2
        
        
        variationStack.addArrangedSubview(variationTitleLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 2, bottom: 0, right: 0))
        variationStack.addArrangedSubview(variationImageCollectionView)
        
        // Add to stackView
        mStackView.addArrangedSubview(detailImageView, withMargin: UIEdgeInsets(top: MARGIN * 4, left: 0, bottom: 0, right: 0))
        mStackView.addArrangedSubview(tsStackView)
        mStackView.addArrangedSubview(iconStackView)
        
        if !UDEngine.shared.getIsAdsPurchased() {
            mStackView.addArrangedSubview(adBannerViewMiddle)
            adBannerViewMiddle.load(GADRequest())
            NSLayoutConstraint.activate([
                adBannerViewMiddle.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                adBannerViewMiddle.heightAnchor.constraint(equalToConstant: 50),
            ])
        }
        
        mStackView.addArrangedSubview(infoStackView)
        mStackView.addArrangedSubview(activeTimeStack)
        mStackView.addArrangedSubview(variationStack)
        
    }
    
    private func setupConstraint() {
        let itemImageViewSize: CGFloat = 0.35
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            
            mStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            detailImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize),
            detailImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize),
            
            tsStackView.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            titleRarityStack.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            
            
            infoStackView.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            
            activeTimeStack.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            
            
            variationStack.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            
            variationImageCollectionView.widthAnchor.constraint(equalTo: self.variationStack.widthAnchor),
            variationImageCollectionView.heightAnchor.constraint(equalToConstant: 135)

        ])
        
        if critterObj != nil {
            titleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        }
    }
    
    private func setBar() {
        self.configureNavigationBar(title: nil, preferredLargeTitle: false)
        self.view.backgroundColor = .cream1
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func createInfoStackView(title: String, with body: UILabel) -> UIStackView {
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
        
        stackView.addBackground(color: .cream2, cornerRadius: 5)
        
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35),
                                               heightDimension: .fractionalHeight(1))
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
