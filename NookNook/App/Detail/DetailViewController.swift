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
    private var groupOrigin: DataEngine.Group!
    
    private var detailImageView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var buyLabel: UILabel!
    private var sellLabel: UILabel!
    private var weatherLabel: UILabel!
    private var rarityLabel: UILabel!
    private var activeTimeLabel: UILabel!
    private var buyStack: UIStackView!
    private var sellStack: UIStackView!
    private var weatherStack: UIStackView!
    private var rarityStack: UIStackView!
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
            print("Attempt to parse an object from Critters")
            
        case .wardrobes:
            print("Attempt to parse an object from Wardrobes")
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
            rarityStack.isHidden = true
            
        case .critters:
            print("Attempt to render an object from Wardrobes")
        case .wardrobes:
            print("Attempt to render an object from Wardrobes")
        default: fatalError("Attempt to render an invalid object group or groupOrigin is still nil!")
        }
        
    }
    
    /**
     Method to render item object
     */
    private func renderItem() {
        detailImageView.sd_setImage(with: ImageEngine.parseURL(of: itemObj.image!), completed: nil)
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
    
    
    
    private func setupView() {
        // create master scrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = .red
        
        // Create master stackView
        mStackView = UIStackView()
        mStackView.translatesAutoresizingMaskIntoConstraints = false
        mStackView.axis = .vertical
        mStackView.spacing = MARGIN * 4
        mStackView.alignment = .center
        mStackView.distribution = .equalSpacing
//        mStackView.addBackground(color: .brown)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(mStackView)
        
        // detailImageView
        detailImageView = UIImageView()
//        detailImageView.backgroundColor = .blue
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
//        tsStackView.addBackground(color: .green)
        
        titleLabel = UILabel()
        subtitleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        subtitleLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
        
        tsStackView.addArrangedSubview(titleLabel)
        tsStackView.addArrangedSubview(subtitleLabel)
        tsStackView.isLayoutMarginsRelativeArrangement = true
        tsStackView.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*4, bottom: 0, right: MARGIN*4)
        
        infoStackView = UIStackView()
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = MARGIN * 2
        infoStackView.alignment = .fill
        infoStackView.distribution = .equalSpacing
        infoStackView.isLayoutMarginsRelativeArrangement = true
        infoStackView.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*4, bottom: 0, right: MARGIN*4)
//        infoStackView.addBackground(color: .green)
        
        buyStack = UIStackView()
        sellStack = UIStackView()
        weatherStack = UIStackView()
        rarityStack = UIStackView()
        activeTimeStack = UIStackView()
        buyLabel = UILabel()
        sellLabel = UILabel()
        rarityLabel = UILabel()
        weatherLabel = UILabel()
        activeTimeLabel = UILabel()
        
        buyLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        sellLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        rarityLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        weatherLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)
        activeTimeLabel.textColor = UIColor(named: ColourUtil.gold1.rawValue)

        buyStack = createInfoStackView(title: "Buy", with: buyLabel)
        sellStack = createInfoStackView(title: "Sell", with: sellLabel)
        weatherStack = createInfoStackView(title: "Weather", with: weatherLabel)
        rarityStack = createInfoStackView(title: "Rarity", with: rarityLabel)
        activeTimeStack = createInfoStackView(title: "Active Time", with: activeTimeLabel)
        
        infoStackView.addArrangedSubview(buyStack)
        infoStackView.addArrangedSubview(sellStack)
        infoStackView.addArrangedSubview(activeTimeStack)
        infoStackView.addArrangedSubview(weatherStack)
        infoStackView.addArrangedSubview(rarityStack)
        
        variationStack = UIStackView()
        variationStack.translatesAutoresizingMaskIntoConstraints = false
        variationStack.axis = .vertical
        variationStack.spacing = MARGIN * 2
        variationStack.alignment = .leading
        variationStack.distribution = .fill
        variationStack.isLayoutMarginsRelativeArrangement = true
        variationStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        variationStackView.addBackground(color: .green)
        
        variationTitleLabel = UILabel()
        variationTitleLabel.text = "Variation"
        variationTitleLabel.numberOfLines = 0
        variationTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
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
        mStackView.addArrangedSubview(variationStack)
        
    }
    
    private func setupConstraint() {
        let itemImageViewSize: CGFloat = 0.5
        
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
            
            infoStackView.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            
            variationStack.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            
            variationImageCollectionView.widthAnchor.constraint(equalTo: self.variationStack.widthAnchor),
            variationImageCollectionView.heightAnchor.constraint(equalToConstant: 150)

        ])
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
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
        default: fatalError("Attempt to create cells from an unkown group origin or, groupOrigin is nul!")
        }

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VARIANT_CELL, for: indexPath) as! VariantCollectionViewCell
        
        switch groupOrigin {
        case .items:
            if let itemObjArr = itemObj.variants {
                cell.variantImage.sd_setImage(with: ImageEngine.parseURL(of: itemObjArr[indexPath.row]), placeholderImage: nil)
            }
        case .critters:
            print("Attempt to access critter cell.")
        case .wardrobes:
            print("Attempt to access wardrobe cell")
        default: fatalError("Attempt to access an invalid object group or groupOrigin is still nil!")
        }
        
        return cell
    }
}
