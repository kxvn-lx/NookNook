//
//  DashboardViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 19/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class DashboardViewController: UIViewController {
    
    // Data variables
    private var favouritesManager: PersistEngine!
    private var user: User!
    private var userDict: [String: String]!
    
    // Constant variables
    private let VARIANT_CELL = "VariantCell"
    private let SETTING_ID = "SettingsVC"
    private let DETAIL_ID = "Detail"
    private let MARGIN: CGFloat = 10
    private var isFirstLoad = true
    
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
    let variationImageCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    private var birthdayResidents: [Villager] = []
    
    // Critter Monthly properties
    private var monthlyBug: [Critter]!
    private var monthlyFish: [Critter]!
    private var caughtBugsMonth: [Critter] = []
    private var caughtFishesMonth: [Critter] = []
    
    // MARK: - Table view properties
    private let CRITTER_CELL = "CritterCell"
    private let FAVOURITE_CELL = "FavouriteCell"
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesManager = PersistEngine()
        userDict = UDHelper.getUser()
        
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
                presentAlert(title: "hey there!", message: "Please head to settings and fill out the user detail for a better app experience! 😁")
            }
            isFirstLoad = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.variationImageCollectionView.reloadData()
        }
        favouritesManager = PersistEngine()
        userDict = UDHelper.getUser()
        
        setupProfile()
        residentLabel.text = "Your Resident: \(self.favouritesManager.residentVillagers.count)/10"
        
        birthdayResidents = ResidentHelper.getMonthsBirthday(residents: self.favouritesManager.residentVillagers)
        
        
        // Calculate monthly bug and fish count
        calculateMonthlyCritter()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // Modify the UI
    private func setBar() {
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(named: ColourUtil.grass1.rawValue)!, tintColor: .white, title: "Dashboard", preferredLargeTitle: true)
        
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
        vc.profileDelegate = self
        let navController = UINavigationController(rootViewController: vc)
        navController.presentationController?.delegate = self
        self.present(navController, animated:true, completion: nil)
    }
    
    func setupProfile() {
        profileNameLabel.text = userDict["name"] ?? "Not provided"
        islandNameLabel.text = "\(userDict["islandName"] ?? "Not provided") 🏝"
        nativeFruitLabel.text = userDict["nativeFruit"] ?? "Not provided"
        
        if let img = ImagePersistEngine.loadImage() {
            profileImageView.image = img
        }
        
        let firstText = "Good \(DateHelper.renderGreet())!"
        let secondText = "\nIt's \(DateHelper.renderSeason(hemisphere: userDict["hemisphere"] ?? DateHelper.Hemisphere.Southern.rawValue)) ━ \(DateHelper.renderDate())."
        phraseLabel.attributedText = renderPhraseLabel(withString: secondText, boldString: firstText, font: phraseLabel.font)
        
    }
    
    private func setUI() {
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
 
        self.view.addSubview(scrollView)
        
        // Create master stackView
        mStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN * 4, alignment: .center, distribution: .equalSpacing)
        
        // Name stack view
        nameStackView = SVHelper.createSV(axis: .vertical, spacing: MARGIN, alignment: .center, distribution: .fill)
        
        profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        
        profileNameLabel = UILabel()
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
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
        
        // Table view
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width:0, height: 0), style: .grouped)
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
        scrollView.addSubview(mStackView)
    }
    
    private func setConstraint() {
        let itemImageViewSize: CGFloat = 0.3
        
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
            
            profileImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize),
            profileImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: itemImageViewSize),
            
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 320),
            
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
    
    private func calculateCVLayout() -> UICollectionViewCompositionalLayout {
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
    
    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func isEmptyLists(dicts: [String: String]?) -> Bool {
        for list in dicts!.values {
            if !list.isEmpty { return false }
        }
        return true
    }
    
    private func calculateMonthlyCritter() {
        caughtBugsMonth = favouritesManager.caughtCritters.filter({ $0.category == Categories.bugs.rawValue })
        caughtFishesMonth = favouritesManager.caughtCritters.filter({ $0.category == Categories.fishes.rawValue })
        
        ( monthlyBug, monthlyFish ) = CritterHelper.parseCritter(userHemisphere:userDict!["hemisphere"].map { DateHelper.Hemisphere(rawValue: $0)! } ?? DateHelper.Hemisphere.Southern)
    }
    
    private func renderPhraseLabel(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let boldText = boldString
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: font.pointSize)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = string
        let normalString = NSMutableAttributedString(string:normalText)

        attributedString.append(normalString)
        return attributedString
    }
    
    private func reloadProfile() {
        userDict = UDHelper.getUser()
        setupProfile()
        
        favouritesManager = PersistEngine()
        calculateMonthlyCritter()
        DispatchQueue.main.async {
            self.variationImageCollectionView.reloadData()
            self.tableView.reloadData()
        }
    }
}

// MARK:- UICollectionView data source
extension DashboardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        
        let villagerName = self.birthdayResidents.contains(self.favouritesManager.residentVillagers[indexPath.row]) ? "\(self.favouritesManager.residentVillagers[indexPath.row].name) 🎂" : self.favouritesManager.residentVillagers[indexPath.row].name
        cell.variantName.text = villagerName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedVillager = self.favouritesManager.residentVillagers[indexPath.row]
        let vc = self.storyboard!.instantiateViewController(withIdentifier: DETAIL_ID) as! DetailViewController
        
        vc.parseOject(from: .villagers, object: selectedVillager)
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(named: ColourUtil.cream2.rawValue)?.withAlphaComponent(0.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = nil
        }
    }
}

extension DashboardViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.reloadProfile()
        self.dismiss(animated: true, completion: nil)
    }
}

extension DashboardViewController: ProfileDelegate {
    func updateprofile() {
        self.reloadProfile()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- UITableView data source
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: FAVOURITE_CELL)
            cell.textLabel!.text = "Favourites"
            cell.imageView?.image = IconUtil.systemIcon(of: .starFill, weight: .regular).withRenderingMode(.alwaysTemplate)
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: CRITTER_CELL)
                cell.textLabel!.text = "Critters this month"
                cell.detailTextLabel?.text = "Bugs: \(caughtBugsMonth.count)/\(monthlyBug.count) | Fishes: \(caughtFishesMonth.count)/\(monthlyFish.count)"
                cell.accessoryType = .disclosureIndicator
                return cell
            case 1:
                let totalBugsCount = DataEngine.loadCritterJSON(from: .bugsMain).count
                let caughtBugsCount = self.favouritesManager.caughtCritters.filter( {$0.category == Categories.bugs.rawValue} ).count
                let percentageCount = (Float(caughtBugsCount) / Float(totalBugsCount)) * 100
                
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CRITTER_CELL)
                cell.textLabel!.text = "Total bugs caught (\(percentageCount)%)"
                cell.detailTextLabel?.text = "\(caughtBugsCount)/\(totalBugsCount)"
                return cell
            case 2:
                let totalFishesCount = DataEngine.loadCritterJSON(from: .fishesMain).count
                let caughtFishesCount = self.favouritesManager.caughtCritters.filter( {$0.category == Categories.fishes.rawValue} ).count
                let percentageCount = (Float(caughtFishesCount) / Float(totalFishesCount)) * 100
                
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CRITTER_CELL)
                cell.textLabel!.text = "Total fishes caught (\(percentageCount)%)"
                cell.detailTextLabel?.text = "\(caughtFishesCount)/\(totalFishesCount)"
                return cell
            default: fatalError("Index out of range")
            }
        default: fatalError("Indexpath out of range.")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default: fatalError("Invalid rows detected.")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return ""
        case 1: return "Critters Information"
        default: return " "
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(named: ColourUtil.cream1.rawValue)
        cell.tintColor =  UIColor(named: ColourUtil.dirt1.rawValue)
        cell.textLabel?.textColor = UIColor(named: ColourUtil.dirt1.rawValue)
        cell.detailTextLabel?.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesTableViewController
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated:true, completion: nil)
        case 1:
            switch indexPath.row {
            case 0:
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "CrittersMonthlyVC") as! CrittersMonthlyTableViewController
                vc.profileDelegate = self
                let navController = UINavigationController(rootViewController: vc)
                navController.presentationController?.delegate = self
                self.present(navController, animated:true, completion: nil)
            case 1: break
            case 2: break
            default: fatalError("Invalid index")
            }
        default: fatalError("Invalid section detected")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: ColourUtil.dirt1.rawValue)?.withAlphaComponent(0.5)
        header.textLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        header.textLabel?.text? = header.textLabel?.text?.capitalized ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}
