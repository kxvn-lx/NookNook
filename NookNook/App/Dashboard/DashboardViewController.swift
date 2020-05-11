//
//  DashboardViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 19/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMobileAds
import StoreKit

class DashboardViewController: UIViewController {
    
    // Data variables
    internal var favouritesManager: DataPersistEngine!
    private var user: User!
    private var userDict: [String: String]!
    
    // Constant variables
    internal let VARIANT_CELL = "VariantCell"
    internal let SETTING_ID = "SettingsVC"
    internal let DETAIL_ID = "Detail"
    internal let TURNIP_ID = "TurnipVC"
    private let MARGIN: CGFloat = 10
    private var isFirstLoad = true
    
    private let reviewHelper = ReviewHelper()
    
    // Views variables
    private var scrollView: UIScrollView!
    private var mStackView: UIStackView!
    
    private var profileNameStackView: UIStackView!
    private var nameStackView: UIStackView!
    private var passportStackView: UIStackView!
    private var residentStack: UIStackView!
    private var phraseStack: UIStackView!
    
    var phraseLabel: UILabel!
    var profileImageView: UIImageView!
    var profileNameLabel: UILabel!
    var islandNameLabel: UILabel!
    var nativeFruitLabel: UILabel!
    var residentLabel: UILabel!
    let variationImageCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    internal var birthdayResidents: [Villager] = []
    
    // Critter Monthly properties
    internal var monthlyBug: [Critter]!
    internal var monthlyFish: [Critter]!
    internal var caughtBugsMonth: [Critter] = []
    internal var caughtFishesMonth: [Critter] = []
    
    // MARK: - Table view properties
    internal let CRITTER_CELL = "CritterCell"
    internal let FAVOURITE_CELL = "FavouriteCell"
    internal var tableView: DynamicSizeTableView!
    
    // Google ads banner
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.adUnitID = GoogleAdsHelper.AD_UNIT_ID
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    // Google ads banner
    lazy var adBannerViewMiddle: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        adBannerView.translatesAutoresizingMaskIntoConstraints = false
        adBannerView.adUnitID = GoogleAdsHelper.DETAIL_PROFILE_AD_UNIT_ID
        adBannerView.rootViewController = self
        adBannerView.delegate = self

        return adBannerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesManager = DataPersistEngine()
        userDict = UDEngine.shared.getUser()
        
        setBar()
        setUI()
        setConstraint()
        
        self.variationImageCollectionView.register(ResidentCollectionViewCell.self, forCellWithReuseIdentifier: VARIANT_CELL)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoad {
            if isEmptyLists(dicts: userDict) {
                let alert = AlertHelper.createDefaultAction(title: "Hey there 👋", message: "NookNook is much better when you fill out your user info detail from the settings page.")
                self.present(alert, animated: true)
                
            }
            isFirstLoad = false
        }
        self.tabBarController?.delegate = self
        
        // Trigger to review the app
        if reviewHelper.canReview() {
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.variationImageCollectionView.reloadData()
        }
        favouritesManager = DataPersistEngine()
        userDict = UDEngine.shared.getUser()
        
        setupProfile()
        residentLabel.text = "Your Resident: \(self.favouritesManager.residentVillagers.count)/10"
        
        birthdayResidents = ResidentHelper.getMonthsBirthday(residents: self.favouritesManager.residentVillagers)
        
        // Calculate monthly bug and fish count
        calculateMonthlyCritter()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        if !UDEngine.shared.getIsAdsPurchased() {
            self.view.addSubview(adBannerView)
            adBannerView.load(GADRequest())
            NSLayoutConstraint.activate([
                adBannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                adBannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            adBannerView.removeFromSuperview()
            mStackView.removeArrangedSubview(adBannerViewMiddle)
            adBannerViewMiddle.removeFromSuperview()
        }
    }
    
    // MARK: - Modify UI
    private func setBar() {
        self.configureNavigationBar(title: "Dashboard")
        self.view.backgroundColor = .cream1
        self.view.tintColor = .white
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(IconHelper.systemIcon(of: .gear, weight: .regular), for: .normal)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.imageView?.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func settingsButtonPressed() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: SETTING_ID) as! SettingsTableViewController
        vc.profileDelegate = self
        let navController = UINavigationController(rootViewController: vc)
        navController.presentationController?.delegate = self
        self.present(navController, animated: true, completion: nil)
    }
    
    func setupProfile() {
        profileNameLabel.text = userDict["name"] ?? "NookNook"
        islandNameLabel.text = "\(userDict["islandName"] ?? "My Island") 🏝"
        nativeFruitLabel.text = userDict["nativeFruit"] ?? "My Fruit 🧃"
        
        if let img = UserPersistEngine.loadImage() {
            profileImageView.image = img
        }
        
        let firstText = "Good \(DateHelper.renderGreet())!"
        let secondText = "\nIt's \(DateHelper.renderSeason(hemisphere: userDict["hemisphere"] ?? DateHelper.Hemisphere.Southern.rawValue)) ━ \(DateHelper.renderDate())."
        phraseLabel.attributedText = renderPhraseLabel(withString: secondText, boldString: firstText, font: phraseLabel.font)
        
    }
    
    private func setUI() {
        
        scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        
        // Create master stackView
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .center, distribution: .equalSpacing)
        
        // Name stack view
        nameStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .center, distribution: .fill)
        scrollView.addSubview(mStackView)
        
        profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .cream2
        profileImageView.image = UIImage(named: "appIcon-Ori")
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        
        profileNameLabel = UILabel()
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.textColor = .dirt1
        profileNameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        profileNameLabel.font = UIFont.systemFont(ofSize: profileNameLabel.font.pointSize, weight: .semibold)
        
        nameStackView.addArrangedSubview(profileNameLabel)
        
        profileNameStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 2, alignment: .center, distribution: .fill)
        profileNameStackView.addArrangedSubview(profileImageView)
        profileNameStackView.addArrangedSubview(nameStackView)
        
        // phrase
        phraseLabel = UILabel()
        phraseLabel.numberOfLines = 0
        phraseLabel.translatesAutoresizingMaskIntoConstraints = false
        phraseLabel.textColor = .dirt1
        phraseLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        
        phraseStack = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fillEqually)
        phraseStack.addArrangedSubview(phraseLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 2, bottom: 0, right: 0))
        
        // Passport
        passportStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .fill, distribution: .equalSpacing)
        passportStackView.isLayoutMarginsRelativeArrangement = true
        passportStackView.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*2, bottom: 0, right: MARGIN*2)
        
        islandNameLabel = UILabel()
        islandNameLabel.textColor = .gold1
        
        nativeFruitLabel = UILabel()
        nativeFruitLabel.textColor = .gold1
        
        passportStackView.addArrangedSubview(createSV(title: "Island Name", with: islandNameLabel))
        passportStackView.addArrangedSubview(createSV(title: "Native Fruit", with: nativeFruitLabel))
        
        residentStack = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fill)
        
        residentLabel = UILabel()
        residentLabel.text = "Your Resident"
        residentLabel.numberOfLines = 0
        residentLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        residentLabel.textColor = UIColor.dirt1.withAlphaComponent(0.5)
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        variationImageCollectionView.setCollectionViewLayout(calculateCVLayout(), animated: true)
        variationImageCollectionView.delegate = self
        variationImageCollectionView.dataSource = self
        variationImageCollectionView.backgroundColor = .cream2
        
        residentStack.addArrangedSubview(residentLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 2, bottom: 0, right: 0))
        residentStack.addArrangedSubview(variationImageCollectionView)
        
        // Table view
        tableView = DynamicSizeTableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CRITTER_CELL)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: FAVOURITE_CELL)
        
        mStackView.addArrangedSubview(profileNameStackView, withMargin: UIEdgeInsets(top: MARGIN*4, left: 0, bottom: 0, right: 0))
        mStackView.addArrangedSubview(phraseStack)
        if !UDEngine.shared.getIsAdsPurchased() {
            adBannerViewMiddle.load(GADRequest())
        }
        mStackView.addArrangedSubview(passportStackView)
        mStackView.addArrangedSubview(residentStack)
        mStackView.addArrangedSubview(tableView)
    }
    
    private func setConstraint() {
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
            
            profileImageView.widthAnchor.constraint(equalToConstant: 130),
            profileImageView.heightAnchor.constraint(equalToConstant: 130),
            
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            residentStack.widthAnchor.constraint(equalTo: self.mStackView.widthAnchor),
            
            variationImageCollectionView.widthAnchor.constraint(equalTo: self.residentStack.widthAnchor),
            variationImageCollectionView.heightAnchor.constraint(equalToConstant: 140)
            
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
        
        stackView.addBackground(color: .cream2, cornerRadius: 5)
        
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(body)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: MARGIN * 1.5, left: MARGIN * 1.5, bottom: MARGIN * 1.5, right: MARGIN * 1.5)
        
        return stackView
    }
    
    private func calculateCVLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                               heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        
        return layout
    }
    
    private func isEmptyLists(dicts: [String: String]?) -> Bool {
        for list in dicts!.values {
            if !list.isEmpty { return false }
        }
        return true
    }
    
    private func calculateMonthlyCritter() {
        let caughtBugs = favouritesManager.caughtCritters.filter({ $0.category == Categories.bugs.rawValue })
        let caughtFishes = favouritesManager.caughtCritters.filter({ $0.category == Categories.fishes.rawValue })
        
        ( monthlyBug, monthlyFish ) = CritterHelper.parseCritter(userHemisphere: userDict!["hemisphere"].map { DateHelper.Hemisphere(rawValue: $0)! } ?? DateHelper.Hemisphere.Southern)
        ( caughtBugsMonth, caughtFishesMonth ) = CritterHelper.parseCaughtCritter(caughtBugs: caughtBugs, caughtFishes: caughtFishes, monthBugs: monthlyBug, monthFishes: monthlyFish)
    }
    
    private func renderPhraseLabel(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let boldText = boldString
        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let attributedString = NSMutableAttributedString(string: boldText, attributes: attrs)
        
        let normalText = string
        let normalString = NSMutableAttributedString(string: normalText)
        
        attributedString.append(normalString)
        return attributedString
    }
    
    private func reloadProfile() {
        userDict = UDEngine.shared.getUser()
        favouritesManager = DataPersistEngine()
        setupProfile()
        
        residentLabel.text = "Your Resident: \(self.favouritesManager.residentVillagers.count)/10"
        calculateMonthlyCritter()
        DispatchQueue.main.async {
            self.variationImageCollectionView.reloadData()
            self.tableView.reloadData()
        }
    }
}

extension DashboardViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.reloadProfile()
        if !UDEngine.shared.getIsAdsPurchased() {
            self.view.addSubview(adBannerView)
            adBannerView.load(GADRequest())
        } else {
            adBannerView.removeFromSuperview()
            mStackView.removeArrangedSubview(adBannerViewMiddle)
            adBannerViewMiddle.removeFromSuperview()
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension DashboardViewController: ProfileDelegate {
    func updateprofile() {
        self.reloadProfile()
        if !UDEngine.shared.getIsAdsPurchased() {
            self.view.addSubview(adBannerView)
            adBannerView.load(GADRequest())
        } else {
            adBannerView.removeFromSuperview()
            mStackView.removeArrangedSubview(adBannerViewMiddle)
            adBannerViewMiddle.removeFromSuperview()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Tabbarcontroller delegate
extension DashboardViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 4 {
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}

extension DashboardViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        if !UDEngine.shared.getIsAdsPurchased() {
            DispatchQueue.main.async {
                self.mStackView.insertArrangedSubview(bannerView, at: 2)
                NSLayoutConstraint.activate([
                    bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                    bannerView.heightAnchor.constraint(equalToConstant: 50)
                ])
            }
        } else {
            mStackView.removeArrangedSubview(bannerView)
        }
    }
}
