//
//  OutfitPickerViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 7/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "outfitCell"
private let headerFooterIdentifier = "outfitHeaderFooter"

class OutfitPickerViewController: UIViewController {
    
    private let categories: [Categories] = [.headwear, .accessories, .tops, .bottoms, .socks, .shoes]
    
    private var collectionView: UICollectionView!
    private var randomizeButton: UIButton = {
        let v = UIButton()
        v.setTitle("Randomize!", for: .normal)

        v.translatesAutoresizingMaskIntoConstraints = false
        v.titleLabel?.textAlignment = .center
        v.titleLabel?.numberOfLines = 2
        v.setTitleColor(.grass1, for: .normal)
        v.setTitleColor(UIColor.grass1.withAlphaComponent(0.5), for: .highlighted)
        v.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        return v
    }()
    private var previewButton: UIButton = {
        let v = UIButton()
        v.setTitle("Preview", for: .normal)
        
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
    
    private var datasource: [[Wardrobe]] = []
    private var selectedOutfitIndexPaths: [Int: Int] = [:]
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDatasource()
        
        setBar()
        setupView()
        setupConstraint()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.layoutIfNeeded()
        for i in 0 ..< datasource.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.125) {
                self.collectionView.scrollToItem(at: IndexPath(row: 2, section: i), at: .centeredHorizontally, animated: true)
//                self.renderSelection(at: IndexPath(row: 2, section: i))
            }
        }
    }
    
    // MARK: - Class functions
    private func fetchDatasource() {
        categories.forEach({
            let data = DataEngine.loadWardrobesJSON(from: $0)
            datasource.append(data)
        })
    }
    
    private func setupView() {
        randomizeButton.addTarget(self, action: #selector(randomizeButtonTapped), for: .touchUpInside)
        previewButton.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(OutfitPickerCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(OutfitPickerCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: headerFooterIdentifier)
        
        self.view.addSubview(collectionView)
        self.view.addSubview(randomizeButton)
    }
    
    private func setupConstraint() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        randomizeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom)
        }
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = contentInsets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.20),
            heightDimension: .fractionalWidth(0.20))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _) -> NSCollectionLayoutSection? in
            if sectionIndex == self.datasource.count - 1 {
                let section = self.createSection()
                section.boundarySupplementaryItems = [self.makeSectionFooter()]
                return section
            } else {
                return self.createSection()
            }
        }
        
        return layout
    }
    
    private func makeSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(75))
        
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        return layoutSectionHeader
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "Outfit picker", preferredLargeTitle: false)
        self.view.backgroundColor = .cream1
        self.view.tintColor = .white
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
    }
    
    private func renderSelection(at indexPath: IndexPath) {
        if selectedOutfitIndexPaths[indexPath.section] != indexPath.row && selectedOutfitIndexPaths[indexPath.section] != nil {
            let oldIndexPath = IndexPath(item: selectedOutfitIndexPaths[indexPath.section]!, section: indexPath.section)
            
            if let cell = collectionView.cellForItem(at: oldIndexPath) as? OutfitPickerCollectionViewCell {
             cell.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        selectedOutfitIndexPaths[indexPath.section] = indexPath.row
        if let cell = collectionView.cellForItem(at: indexPath) as? OutfitPickerCollectionViewCell {
            cell.layer.borderColor = UIColor.gold1.cgColor
        }
    }
    
    @objc private func randomizeButtonTapped() {
        Taptic.successTaptic()
        print("Randomize!")
    }
    
    @objc private func previewButtonTapped() {
        Taptic.lightTaptic()
        print("preview!")
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}

extension OutfitPickerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!  OutfitPickerCollectionViewCell
        let data = self.datasource[indexPath.section][indexPath.row]
        
        cell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: data.image!, category: data.category), placeholderImage: UIImage(named: "placeholder"))
        
        return cell
    }
}

extension OutfitPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Taptic.lightTaptic()
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        renderSelection(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerFooterIdentifier, for: indexPath) as? OutfitPickerCollectionReusableView else {
            fatalError("Could not dequeue SectionHeader")
        }
        
        let sv = SVHelper.createSV(axis: .horizontal, spacing: 50, alignment: .center, distribution: .fillProportionally)
        sv.addArrangedSubview(randomizeButton)
        sv.addArrangedSubview(previewButton)
        
        view.addSubview(sv)

        sv.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return view
    }
}
