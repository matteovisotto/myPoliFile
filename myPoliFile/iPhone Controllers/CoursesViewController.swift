//
//  CoursesViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import UIKit

class CoursesViewController: BaseViewController {
    
    private class TopMenu: MVTopMenuView{
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            collectionView.collectionViewLayout = layout
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width/CGFloat(3)-20, height: collectionView.frame.height)
        }
    }
    
    private var model: CoursesViewModel!
    
    private var loader = Loader()
    private let refreshControl = UIRefreshControl()
    private let topMenu = TopMenu()
    
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupTopMenu()
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width-20, height: 10)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        self.model = CoursesViewModel(target: self, collectionView: collectionView, loader: loader)
        setupCollectionView()
        topMenu.delegate = self
        topMenu.dataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self
        self.topMenu.setSelectedIndex(atIndex: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.loadContent()
        self.topMenu.collectionView.reloadData()
        self.topMenu.setSelectedIndex(atIndex: model.selectedMenuIndex)
        (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: UIScreen.main.bounds.width-20, height: 10)
        self.collectionView.reloadData()
    }
    
    private func setupTopMenu() {
        self.view.addSubview(topMenu)
        topMenu.translatesAutoresizingMaskIntoConstraints = false
        topMenu.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        topMenu.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        topMenu.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topMenu.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topMenu.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didAskRefresh), for: .valueChanged)
        refreshControl.tintColor = .primary.withAlphaComponent(0.5)
        model.registerCollectionViewElements()
    }

    
    @objc private func didAskRefresh() {
        AppData.clearCourses()
        collectionView.reloadData()
        refreshControl.endRefreshing()
        model.loadContent()
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.topMenu.collectionView.reloadData()
        self.topMenu.setSelectedIndex(atIndex: model.selectedMenuIndex)
        (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: UIScreen.main.bounds.width-20, height: 10)
        self.collectionView.reloadData()
    }
}

extension CoursesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.getNumberOfElements()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return model.getCollectionViewCell(forIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: MainViewController.safeAreaBottom+MainViewController.tabBarHeight+10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        model.performActionForCell(atIndexPath: indexPath){ course in
            let detailVC = CourseContentViewController()
            detailVC.course = course
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension CoursesViewController: MVTopMenuDelegate, MVTopMenuDataSource {
    
    func topMenu(topMenuView: MVTopMenuView, titleForItemAtIndex itemIndex: Int) -> String {
        return model.menuItems[itemIndex]
    }
    
    func numberOfItemInMenu(topMenuView: MVTopMenuView) -> Int {
        return model.menuItems.count
    }
    
    func topMenu(topMenuView: MVTopMenuView, didSelectItemAtIndex itemIndex: Int) {
        model.selectedMenuIndex = itemIndex
        self.collectionView.reloadData()
    }
}
