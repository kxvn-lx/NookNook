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
    
    private var categories: [Categories] = [.headwear, .accessories, .tops, .bottoms, .socks, .shoes]
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
    private var isDressToggled = false
    
    private var bottomSV = SVHelper.createSV(axis: .vertical, spacing: 10, alignment: .center, distribution: .fillProportionally)
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDatasource()
        
        setBar()
        setupView()
        
        collectionView.layoutIfNeeded()
        for i in 0 ..< datasource.count {
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: i), at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - Class functions
    private func fetchDatasource() {
        categories.forEach({
            var clothes = DataEngine.loadWardrobesJSON(from: $0)
            clothes.insert(Wardrobe.empty_wardrobe, at: 0)
            datasource.append(clothes)
        })
        
        if isDressToggled {
            datasource.append([])
        }
    }
    
    private func setupView() {
        self.view.addSubview(createTriangleSelector(frame: CGRect(x: self.view.frame.midX - 20 / 2, y: 0, width: 20, height: 20)))
        randomizeButton.addTarget(self, action: #selector(randomizeButtonTapped), for: .touchUpInside)
        previewButton.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        
        let sv = SVHelper.createSV(axis: .horizontal, spacing: 50, alignment: .center, distribution: .fillProportionally)
        sv.addArrangedSubview(randomizeButton)
        sv.addArrangedSubview(previewButton)
        
        self.view.addSubview(bottomSV)
        
        sv.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.8)
        }
        
        bottomSV.addArrangedSubview(sv)

        bottomSV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.view.getSafeAreaInsets().bottom + 10)
        }
        
        collectionView.collectionViewLayout = makeLayout()
        collectionView.backgroundColor = .clear
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
        let layout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            return self.createSection()
        }
        
        return layout
    }
    
    private func setBar() {
        self.configureNavigationBar(title: "Outfit picker", preferredLargeTitle: false)
        self.view.backgroundColor = .cream1
        self.view.tintColor = .white
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        
        let btn = UIButton(type: .detailDisclosure)
        btn.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    private func createTriangleSelector(frame: CGRect) -> UIView {
        let v = UIView(frame: frame)
        let heightWidth = frame.size.width
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: heightWidth / 2, y: heightWidth / 2))
        path.addLine(to: CGPoint(x: heightWidth, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.gold1.cgColor
        
        v.layer.insertSublayer(shape, at: 0)
        
        return v
    }

    @objc private func randomizeButtonTapped() {
        Taptic.successTaptic()

        let d = isDressToggled ? datasource.filter { !$0.isEmpty } : datasource
        
        for i in 0 ..< d.count {
            let randomInt = Int.random(in: 0 ..< d[i].count)
            
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
        
        let d = isDressToggled ? datasource.filter { !$0.isEmpty } : datasource
        
        for i in 0 ..< d.count {
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
        
        let selected = selectedOutfit.filter({ $0.image != nil })
        guard !selected.isEmpty else {
            let alert = AlertHelper.createDefaultAction(title: "Nope!", message: "You can't just go around your island without any clothes do you? so please pick at least one")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let vc = OutfitPreviewViewController()
        vc.selectedOutfit = selected
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func filterTapped() {
        let vc = OutfitFilterTableViewController(style: .insetGrouped)
        vc.delegate = self
        vc.isDressTogled = isDressToggled
        let root = UINavigationController(rootViewController: vc)
        self.present(root, animated: true, completion: nil)
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
        let data = datasource[indexPath.section][indexPath.row]
        
        if indexPath.row == 0 {
            cell.imgView.image = UIImage(named: "none")
            cell.imgView.alpha = 0.25
            cell.imgView.sd_imageIndicator = nil
        } else {
            cell.imgView.sd_setImage(with: ImageEngine.parseNPURL(with: data.image!, category: data.category), placeholderImage: UIImage(named: "placeholder"))
            cell.imgView.alpha = 1
        }

        return cell
    }
}

extension OutfitPickerViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Taptic.lightTaptic()
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selectedOutfitIndexPaths[indexPath.section] = indexPath.row
    }
    
}

extension OutfitPickerViewController: OutfitFilterDelegate {
    func filterDidToggleDress(withToggleResult isDress: Bool) {
        self.isDressToggled = isDress
        
        if isDress {
            self.categories = [.headwear, .accessories, .dresses, .socks, .shoes]
        } else {
            self.categories = [.headwear, .accessories, .tops, .bottoms, .socks, .shoes]
        }
        datasource.removeAll()
        fetchDatasource()

        self.collectionView.reloadData()
        self.selectedOutfitIndexPaths = [:]

        collectionView.layoutIfNeeded()
        for i in 0 ..< datasource.count {
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: i), at: .centeredHorizontally, animated: true)
        }
    }
}
