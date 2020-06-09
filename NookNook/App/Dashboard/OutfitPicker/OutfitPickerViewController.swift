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

class OutfitPickerViewController: UICollectionViewController {
    
    private let categories: [Categories] = [.headwear, .accessories, .tops, .bottoms, .socks, .shoes]
    private let cellSize: CGFloat = 0.25
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
        
        collectionView.layoutIfNeeded()
        for i in 0 ..< datasource.count {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: i), at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - Class functions
    private func fetchDatasource() {
        categories.forEach({
            datasource.append(DataEngine.loadWardrobesJSON(from: $0))
        })
    }
    
    private func setupView() {
        randomizeButton.addTarget(self, action: #selector(randomizeButtonTapped), for: .touchUpInside)
        previewButton.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        
        collectionView.collectionViewLayout = makeLayout()
        collectionView.backgroundColor = .clear
        
        let vWidth = self.view.frame.width * (cellSize + 0.005)
        let vHeight = self.view.frame.height * (cellSize - 0.11) * 5.25
        let vCenterX = self.view.frame.midX - vWidth / 2
        
        let v = UIView(frame: CGRect(x: vCenterX, y: 0, width: vWidth, height: vHeight))
        v.layer.cornerRadius = 10
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.gold1.withAlphaComponent(0.5).cgColor
        v.backgroundColor = .cream2

        self.collectionView.addSubview(v)
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
        let contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = contentInsets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(cellSize),
            heightDimension: .fractionalHeight(cellSize - 0.11))
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

    @objc private func randomizeButtonTapped() {
        Taptic.successTaptic()
        
        for i in 0 ..< datasource.count {
            let randomInt = Int.random(in: 0 ..< datasource[i].count)
            
            collectionView.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.125) {
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                    self.collectionView.scrollToItem(at: IndexPath(row: randomInt, section: i), at: .centeredHorizontally, animated: false)
                }, completion: nil)
            }

            selectedOutfitIndexPaths[i] = randomInt
        }
    }
    
    @objc private func previewButtonTapped() {
        Taptic.lightTaptic()
        
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        for i in 0 ..< datasource.count {
            let constant = self.view.frame.height / 1.65 * cellSize * CGFloat(i)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.minY + 5 + constant)

            guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { fatalError("Item not found") }
            selectedOutfitIndexPaths[indexPath.section] = indexPath.row
        }
        
        var selectedOutfit: [Wardrobe] = []
        
        let sortedDict = selectedOutfitIndexPaths.sorted( by: { $0.0 < $1.0 })
        
        for (key, value) in sortedDict {
            selectedOutfit.append(datasource[key][value])
        }
        
        let vc = OutfitPreviewViewController()
        vc.selectedOutfit = selectedOutfit
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}

extension OutfitPickerViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!  OutfitPickerCollectionViewCell
        let data = self.datasource[indexPath.section][indexPath.row]
        
        cell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: data.image!, category: data.category), placeholderImage: UIImage(named: "placeholder"))
        
        return cell
    }
}

extension OutfitPickerViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Taptic.lightTaptic()
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selectedOutfitIndexPaths[indexPath.section] = indexPath.row
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerFooterIdentifier, for: indexPath)
        
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
