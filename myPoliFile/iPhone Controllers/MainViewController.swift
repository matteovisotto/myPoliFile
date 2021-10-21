//
//  MainViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class MainViewController: BaseViewController {
    static let safeAreaBottom:CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    static let tabBarHeight: CGFloat = 50

    private var collectionView: UICollectionView!
    private var containerView = UIView()
    
    private var headerView = HomeHeader()
    
    private var selectedItem: Int = 0
    
    private let viewControllers: [UIViewController] = [CoursesViewController(), SearchViewController(), DownloadViewController()]
    private let titles: [String] = [NSLocalizedString("home.courses", comment: ""), NSLocalizedString("home.search", comment: ""), "Download"]
    private let imageNames: [String] = ["courses", "search", "download"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = .groupTableViewBackground
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        setHeader()
        setCollectionView()
        setContainerView()
        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .right)
        displayContentController(content: viewControllers[self.selectedItem])
    }
    
    
    @objc private func didTapSettingBtn() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc private func didTapNotificationBtn() {
        self.navigationController?.pushViewController(BeePNotificationViewController(), animated: true)
    }
    
    private func setHeader() {
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        //headerView.logoImage = UIImage(named: "logo")!
        headerView.headerTitle = NSLocalizedString("home.courses", comment: "")
        headerView.settingsButton.addTarget(self, action: #selector(didTapSettingBtn), for: .touchUpInside)
        headerView.notificationButton.addTarget(self, action: #selector(didTapNotificationBtn), for: .touchUpInside)
    }
    
    private func setCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: MainViewController.tabBarHeight).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        if(MainViewController.safeAreaBottom == 0){
            collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
            collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            collectionView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            collectionView.layer.cornerRadius = MainViewController.tabBarHeight/2
            collectionView.layer.masksToBounds = false
            collectionView.layer.shadowColor = UIColor.darkGray.cgColor
            collectionView.layer.shadowOffset = CGSize(width: 0, height: 3)
            collectionView.layer.shadowRadius = 1.5
            collectionView.layer.shadowOpacity = 0.3
        }
        
        collectionView.backgroundColor = backgroundColor
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TabBarCollectionViewCell.self, forCellWithReuseIdentifier: "menuCell")
    }
    
    private func setContainerView() {
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        containerView.backgroundColor = .clear
        collectionView.layer.zPosition = 1
        self.view.bringSubviewToFront(self.collectionView)
        self.view.layoutSubviews()
    }

    private func displayContentController(content: UIViewController) {
        addChild(content)
        content.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        self.containerView.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    private func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! TabBarCollectionViewCell
        cell.backgroundColor = .clear
        cell.image = UIImage(named: self.imageNames[indexPath.item]) ?? UIImage()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let controllers = CGFloat(self.viewControllers.count)
        return CGSize(width: (collectionView.bounds.width/controllers)-(collectionView.bounds.height/2), height: collectionView.bounds.height-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: collectionView.bounds.height/2, bottom: 5, right: collectionView.bounds.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.hideContentController(content: self.viewControllers[self.selectedItem])
        self.displayContentController(content: self.viewControllers[indexPath.item])
        self.headerView.headerTitle = self.titles[indexPath.item]
        self.selectedItem = indexPath.item
    }
}
