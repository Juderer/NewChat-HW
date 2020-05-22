//
//  ColletionViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/24.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .blue
        
        titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.frame = self.bounds
        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColletionViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: self.view.bounds.height - 100), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
//        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
}

extension ColletionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.titleLabel.text = "编号:\(indexPath.item)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
}
