//
//  DashboardViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 19/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage
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
    private var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        v.translatesAutoresizingMaskIntoConstraints = false
       return v
    }()
    private var mStackView: UIStackView!
    
    private var profileNameStackView: UIStackView!
    private var nameStackView: UIStackView!
    private var passportStackView: UIStackView!
    private var residentStack: UIStackView!
    private var phraseStack: UIStackView!
    
    var phraseLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .dirt1
        v.font = UIFont.preferredFont(forTextStyle: .title3)
       return v
    }()
    var profileImageView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.backgroundColor = .cream2
        v.image = UIImage(named: "appIcon-Ori")
        v.layer.cornerRadius = v.frame.size.width / 2
       return v
    }()
    var profileNameLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .dirt1
        v.font = UIFont.preferredFont(forTextStyle: .title1)
        v.font = UIFont.systemFont(ofSize: v.font.pointSize, weight: .semibold)
       return v
    }()
    var islandNameLabel: UILabel = {
        let v = UILabel()
        v.textColor = .gold1
       return v
    }()
    var nativeFruitLabel: UILabel = {
        let v = UILabel()
        v.textColor = .gold1
        return v
    }()
    var residentLabel: UILabel = {
        let v = UILabel()
        v.text = "Your Resident"
        v.numberOfLines = 0
        v.font = UIFont.preferredFont(forTextStyle: .title3)
        v.textColor = UIColor.dirt1.withAlphaComponent(0.5)
       return v
    }()
    let residentVillagerCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    internal var birthdayResidents: [Villager] = []
    
    // Critter Monthly properties
    var monthlyBug: [Critter]!
    var monthlyFish: [Critter]!
    var monthlySeaCreatures: [Critter]!
    
    var caughtBugsMonth: [Critter] = []
    var caughtFishesMonth: [Critter] = []
    var caughtSeaCreaturesMonth: [Critter] = []

    // MARK: - Table view properties
    let CRITTER_CELL = "CritterCell"
    let FAVOURITE_CELL = "FavouriteCell"
    var tableView: DynamicSizeTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesManager = DataPersistEngine()
        userDict = UDEngine.shared.getUser()
        
        setBar()
        setUI()
        setConstraint()
        
        self.residentVillagerCollectionView.register(ResidentCollectionViewCell.self, forCellWithReuseIdentifier: VARIANT_CELL)
        
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
            self.residentVillagerCollectionView.reloadData()
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
        self.view.addSubview(scrollView)
        
        // Create master stackView
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .center, distribution: .equalSpacing)
        
        scrollView.addSubview(mStackView)
        
        // Name stack view
        nameStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .center, distribution: .fill)
        nameStackView.addArrangedSubview(profileNameLabel)
        
        profileNameStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 2, alignment: .center, distribution: .fill)
        profileNameStackView.addArrangedSubview(profileImageView)
        profileNameStackView.addArrangedSubview(nameStackView)
        
        // phrase
        phraseStack = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fillEqually)
        phraseStack.addArrangedSubview(phraseLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 2, bottom: 0, right: 0))
        
        // Passport
        passportStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .fill, distribution: .equalSpacing)
        passportStackView.isLayoutMarginsRelativeArrangement = true
        passportStackView.layoutMargins = UIEdgeInsets(top: 0, left: MARGIN*2, bottom: 0, right: MARGIN*2)
        passportStackView.addArrangedSubview(createSV(title: "Island Name", with: islandNameLabel))
        passportStackView.addArrangedSubview(createSV(title: "Native Fruit", with: nativeFruitLabel))
        
        residentStack = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .leading, distribution: .fill)

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        residentVillagerCollectionView.setCollectionViewLayout(calculateCVLayout(), animated: true)
        residentVillagerCollectionView.delegate = self
        residentVillagerCollectionView.dataSource = self
        residentVillagerCollectionView.backgroundColor = .cream2
        
        residentStack.addArrangedSubview(residentLabel, withMargin: UIEdgeInsets(top: 0, left: MARGIN * 2, bottom: 0, right: 0))
        residentStack.addArrangedSubview(residentVillagerCollectionView)
        
        // Table view
        tableView = DynamicSizeTableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CRITTER_CELL)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: FAVOURITE_CELL)
        
        mStackView.addArrangedSubview(profileNameStackView, withMargin: UIEdgeInsets(top: MARGIN*4, left: 0, bottom: 0, right: 0))
        mStackView.addArrangedSubview(phraseStack)
        mStackView.addArrangedSubview(passportStackView)
        mStackView.addArrangedSubview(residentStack)
        mStackView.addArrangedSubview(tableView)
    }
    
    private func setConstraint() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.top.left.width.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-MARGIN * 2)
        }
        
        profileNameStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        phraseStack.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        passportStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(130)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        residentStack.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        residentVillagerCollectionView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(self.view.frame.width * 0.325)
        }
    }
    
    private func createSV(title: String, with body: UILabel) -> UIStackView {
        let stackView = SVHelper.createSV(axis: .horizontal, spacing: MARGIN, alignment: .center, distribution: .equalCentering)
        
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
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
        let caughtSeaCreatures = favouritesManager.caughtCritters.filter({ $0.category == Categories.seaCreatures.rawValue })
        
        ( monthlyBug, monthlyFish, monthlySeaCreatures ) = CritterHelper.parseCritter(userHemisphere: userDict!["hemisphere"].map { DateHelper.Hemisphere(rawValue: $0)! } ?? DateHelper.Hemisphere.Southern)
        ( caughtBugsMonth, caughtFishesMonth, caughtSeaCreaturesMonth ) = CritterHelper.parseCaughtCritter(caughtBugs: caughtBugs, caughtFishes: caughtFishes, caughtSeaCreatures: caughtSeaCreatures, monthBugs: monthlyBug, monthFishes: monthlyFish, monthSeaCreatures: monthlySeaCreatures)
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
            self.residentVillagerCollectionView.reloadData()
            self.tableView.reloadData()
        }
    }
}

extension DashboardViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.reloadProfile()
    }
}

extension DashboardViewController: ProfileDelegate {
    func updateprofile() {
        self.reloadProfile()
        
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
