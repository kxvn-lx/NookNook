//
//  OutfitPickerViewController.swift
//  NookNook
//
//  Created by Kevin Laminto on 7/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "outfitCell"
private let headerIdentifier = "filtersHeader"

class OutfitPickerViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var datasource: [[UIColor]] = [
        [.systemRed, .systemRed],
        [.systemOrange, .systemOrange],
        [.systemYellow, .systemYellow],
        [.systemGreen, .systemGreen],
        [.systemBlue, .systemBlue]
    ]
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setBar()
        setupView()
        setupConstraint()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    // MARK: - Class functions
    private func setupView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.view.addSubview(collectionView)
    }
    
    private func setupConstraint() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        let contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = contentInsets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let data = self.datasource[indexPath.section][indexPath.row]
        cell.contentView.backgroundColor = data
        return cell
    }
}

extension OutfitPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Taptic.lightTaptic()

        print(indexPath)
    }
}
