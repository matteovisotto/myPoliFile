//
//  MVTopMenuView.swift
//  myListaSpesa
//
//  Created by Matteo Visotto on 16/10/2020.
//  Copyright © 2020 MatMac System. All rights reserved.
//

import UIKit



class MVTopMenuView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: 150, height: 44)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    open var dataSource: MVTopMenuDataSource? = nil
    open var delegate: MVTopMenuDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.register(MVTopMenuCell.self, forCellWithReuseIdentifier: MVTopMenuCell.cellIdentifier)
    }
    
    public func setSelectedIndex(atIndex index: Int){
        if((self.dataSource?.numberOfItemInMenu(topMenuView: self) ?? 0) != 0) {
            collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: [])
            self.delegate?.topMenu(topMenuView: self, didSelectItemAtIndex: index)
        }
    }
    
}

extension MVTopMenuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItemInMenu(topMenuView: self) ?? 0
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MVTopMenuCell.cellIdentifier, for: indexPath) as! MVTopMenuCell
        cell.setMenuCell(withTitle: self.dataSource?.topMenu(topMenuView: self, titleForItemAtIndex: indexPath.item) ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.topMenu(topMenuView: self, didSelectItemAtIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 100)
    }
    
}

