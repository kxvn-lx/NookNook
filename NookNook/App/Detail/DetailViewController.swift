//
//  DetailViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 14/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    private let MARGIN: CGFloat = 10
    
    private var scrollView: UIScrollView!
    // Master StackView that holds all view
    private var mStackView: UIStackView!
    // tsStackView - Title and subtitle stackview.
    private var tsStackView: UIStackView!
    // Stackview to hold all the rest of the informations
    private var infoStackView: UIStackView!
    
    private var itemObj: Item!
    private var critterObj: Critter!
    private var wardrobeObj: Wardrobe!
    
    private var groupOrigin: DataEngine.Group!
    
    private var detailImageView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var titleRarityStack: UIStackView!
    private var buyLabel: UILabel!
    private var sellLabel: UILabel!
    private var specialSellLabel: UILabel!
    private var weatherLabel: UILabel!
    private var rarityLabel: UIButton!
    private var activeTimeN: UILabel!
    private var activeTimeS: UILabel!
    
    private var activeTimeSStack: UIStackView!
    private var activeTimeNStack: UIStackView!
    private var buyStack: UIStackView!
    private var sellStack: UIStackView!
    private var specialSellStack: UIStackView!
    private var weatherStack: UIStackView!
    private var activeTimeStack: UIStackView!
    private var variationStack: UIStackView!
    private var variationTitleLabel: UILabel!
    let variationImageCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    
    private let VARIANT_CELL = "VariantCell"
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        setupView()
        setupConstraint()
        
        renderObj()
        
        self.variationImageCollectionView.register(VariantCollectionViewCell.self, forCellWithReuseIdentifier: VARIANT_CELL)
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
        }
    }
    
    /**
     Method to render each object accordingly (hides the component that is not dependent to each group.
     */
    private func renderObj() {
        switch groupOrigin {
        case .items:
            renderItem()
            activeTimeStack.isHidden = true
            weatherStack.isHidden = true
            rarityLabel.isHidden = true
            specialSellStack.isHidden = true
            
        case .critters:
            renderCritter()
            variationStack.isHidden = true
            buyStack.isHidden = true
            
        case .wardrobes:
            renderWardrobe()
            activeTimeStack.isHidden = true
            weatherStack.isHidden = true
            rarityLabel.isHidden = true
            specialSellStack.isHidden = true
            
        default: fatalError("Attempt to render an invalid object group or groupOrigin is still nil!")
        }
        
    }
    
    /**
     Method to render item object
     */
    private func renderItem() {
        detailImageView.sd_setImage(with: ImageEngine.parseURL(with: itemObj.image!), completed: nil)
        titleLabel.text = itemObj.name
        subtitleLabel.text = itemObj.obtainedFrom
        buyLabel.attributedText = PriceEngine.renderPrice(amount: itemObj.buy!, with: .none, of: buyLabel.font.pointSize)
        sellLabel.attributedText = PriceEngine.renderPrice(amount: itemObj.sell!, with: .none, of: buyLabel.font.pointSize)
        
        if itemObj.variants == nil {
            variationImageCollectionView.isHidden = true
            variationTitleLabel.text = "This item has no variations."
            variationTitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
    
    
    /**
     Method to render item object
     */
    private func renderCritter() {
        detailImageView.sd_setImage(with: ImageEngine.parseAcnhURL(with: critterObj.image, of: critterObj.category), completed: nil)
        titleLabel.text = critterObj.name
        subtitleLabel.text = critterObj.obtainedFrom
        sellLabel.attributedText = PriceEngine.renderPrice(amount: critterObj.sell!, with: .none, of: sellLabel.font.pointSize)
        let specialSell = critterObj.sell!
        specialSellLabel.attributedText = PriceEngine.renderPrice(amount: Int(Double(specialSell) * 1.5), with: .none, of: buyLabel.font.pointSize)
        weatherLabel.text = critterObj.weather
        rarityLabel.setTitle(critterObj.rarity, for: .normal)
        activeTimeN.text = TimeEngine.formatMonth(of: critterObj.activeMonthsN)
        activeTimeS.text = TimeEngine.formatMonth(of: critterObj.activeMonthsS)
        weatherStack.isHidden = critterObj.weather.isEmpty ? true : false
    }
    
    
    /**
     Method to render item object
     */
    private func renderWardrobe() {
        detailImageView.sd_setImage(with: ImageEngine.parseURL(with: wardrobeObj.image!), completed: nil)
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
    
    
    
    
    
    /**
     ------------------------------
     ------------------------------
     ------------------------------
     */
    
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
        rarityLabel = UIButton()
        specialSellLabel = UILabel()
        
        // create master scrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        
        // Create master stackView
        mStackView = UIStackView()
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.axis = .vertical
        mStackView.spacing = MARGIN * 4
        mStackView.alignment = .center
        mStackView.distribution = .equalSpacing

        
        self.view.addSubview(scrollView)
        scrollView.addSubview(mStackView)
        
        
        // detailImageView
        detailImageView = UIImageView()
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        detailImageView.contentMode = .scaleAspectFit
        detailImageView.sd_imageTransition = .fade
        detailImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        

        // Object Title and Subtitle stackView
        tsStackView = UIStackView()
        tsStackView.translatesAutoresizingMaskIntoConstraints = false
        tsStackView.axis = .vertical
        tsStackView.spacing = MARGIN
        tsStackView.alignment = .leading
        tsStackView.distribution = .equalSpacing
        
        titleRarityStack = UIStackView()
        titleRarityStack.translatesAutoresizingMaskIntoConstraints = false
        titleRarityStack.axis = .horizontal
        titleRarityStack.spacing = MARGIN
        titleRarityStack.alignment = .lastBaseline
        titleRarityStack.distribution = .equalSpacing
        
        
        // Title and subtitle section
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.font = UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .semibold)
        titleLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        subtitleLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
        
        
        // Rarity section
        rarityLabel.setTitleColor(UIColor(named: ColourUtil.gold1.rawValue), for: .normal)
        rarityLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        rarityLabel.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rarityLabel.isUserInteractionEnabled = false
        rarityLabel.addBlurEffect(style: .light, cornerRadius: 5, padding: .zero)
        
        titleRarityStack.addArrangedSubview(titleLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 4, bottom: 0, right: 0))
        titleRarityStack.addArrangedSubview(rarityLabel, withMargin: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -MARGIN * 4))
        
        tsStackView.addArrangedSubview(titleRarityStack)
        tsStackView.addArrangedSubview(subtitleLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 4, bottom: 0, right: 0))
        
        
        // Info stack views section
        infoStackView = UIStackView()
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = MARGIN * 2
        infoStackView.alignment = .fill
        infoStackView.distribution = .equalSpacing
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*4, bottom: 0, right: MARGIN*4)
        
        buyLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        sellLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        specialSellLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        weatherLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)

        buyStack = createInfoStackView(title: "Buy", with: buyLabel)
        sellStack = createInfoStackView(title: "Sell", with: sellLabel)
        specialSellStack = createInfoStackView(title: "Special sell price", with: specialSellLabel)
        if let critterObj = critterObj {
            switch critterObj.category {
            case Categories.fishes.rawValue:
                specialSellStack = createInfoStackView(title: "CJ sell price", with: specialSellLabel)
            case Categories.bugs.rawValue:
                specialSellStack = createInfoStackView(title: "Flick sell price", with: specialSellLabel)
            default:
                fatalError("Invalid category detected for critter! (attempt to render special sell price")
            }
        }
        weatherStack = createInfoStackView(title: "Weather", with: weatherLabel)
        
        infoStackView.addArrangedSubview(buyStack)
        infoStackView.addArrangedSubview(sellStack)
        infoStackView.addArrangedSubview(specialSellStack)
        infoStackView.addArrangedSubview(weatherStack)
        
        
        // Active time period section
        activeTimeStack = UIStackView()
        activeTimeStack.translatesAutoresizingMaskIntoConstraints = false
        activeTimeStack.axis = .vertical
        activeTimeStack.spacing = MARGIN * 2
        activeTimeStack.alignment = .fill
        activeTimeStack.distribution = .equalSpacing
        activeTimeStack.isLayoutMarginsRelativeArrangement = true
        activeTimeStack.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*4, bottom: 0, right: MARGIN*4)
        
        activeTimeN.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        activeTimeS.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        
        activeTimeNStack = createInfoStackView(title: "Northern Hemisphere", with: activeTimeN)
        activeTimeSStack = createInfoStackView(title: "Southern Hemisphere", with: activeTimeS)
        
        let activeTimeLabel = UILabel()
        activeTimeLabel.text = "Active Time"
        activeTimeLabel.numberOfLines = 0
        activeTimeLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        activeTimeLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
        
        activeTimeStack.addArrangedSubview(activeTimeLabel)
        activeTimeStack.addArrangedSubview(activeTimeNStack)
        activeTimeStack.addArrangedSubview(activeTimeSStack)

        
        // Variation Section
        variationStack = UIStackView()
        variationStack.translatesAutoresizingMaskIntoConstraints = false
        variationStack.axis = .vertical
        variationStack.spacing = MARGIN * 2
        variationStack.alignment = .leading
        variationStack.distribution = .fill
        variationStack.isLayoutMarginsRelativeArrangement = true
        variationStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        variationTitleLabel = UILabel()
        variationTitleLabel.text = "Variation"
        variationTitleLabel.numberOfLines = 0
        variationTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        variationTitleLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        variationImageCollectionView.setCollectionViewLayout(calculateCVLayout(), animated: true)
        variationImageCollectionView.delegate = self
        variationImageCollectionView.dataSource = self
        variationImageCollectionView.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
        
        
        variationStack.addArrangedSubview(variationTitleLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 4, bottom: 0, right: 0))
        variationStack.addArrangedSubview(variationImageCollectionView)
        
        // Add to stackView
        mStackView.addArrangedSubview(detailImageView)
        mStackView.addArrangedSubview(tsStackView)
        mStackView.addArrangedSubview(infoStackView)
        mStackView.addArrangedSubview(activeTimeStack)
        mStackView.addArrangedSubview(variationStack)
        
    }
    
    private func setupConstraint() {
        let itemImageViewSize: CGFloat = 0.35
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: MARGIN),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -MARGIN),
            
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
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Detail", preferredLargeTitle: false)
        
        self.view.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItems = [cancel]
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
        label1.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
        
        stackView.addBackground(color: UIColor(named: ColourUtil.cream1.rawValue)!, cornerRadius: 10)
        
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
            
        default: fatalError("Attempt to create cells from an unkown group origin or, groupOrigin is nul!")
        }

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VARIANT_CELL, for: indexPath) as! VariantCollectionViewCell
        
        switch groupOrigin {
        case .items:
            if let itemObjArr = itemObj.variants {
                cell.variantImage.sd_setImage(with: ImageEngine.parseURL(with: itemObjArr[indexPath.row]), placeholderImage: nil)
            }
        case .critters:
            print("Attempt to access critter cell.")
        case .wardrobes:
            if let wardrobeObjArr = wardrobeObj.variants {
                cell.variantImage.sd_setImage(with: ImageEngine.parseURL(with: wardrobeObjArr[indexPath.row]), placeholderImage: nil)
            }
        default: fatalError("Attempt to access an invalid object group or groupOrigin is still nil!")
        }
        
        return cell
    }
}