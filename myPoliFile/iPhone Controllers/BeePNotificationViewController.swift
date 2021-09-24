//
//  BeePNotificationViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import UIKit

class BeePNotificationViewController: BaseViewController {
    
    private var loader = Loader()
    private let navigationBar = BackHeader()
    private var newsTask: TaskManager!
    private var collectionView: UICollectionView!
    private var realNumberOfItems: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width-20, height: 10)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadNews()
    }
    
    private func setNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = .groupTableViewBackground
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        navigationBar.titleLabel.text = NSLocalizedString("global.notifications", comment: "Notifications")
       
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCell")
        collectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: "notificationCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func downloadNews() {
        AppData.notifications.removeAll()
        loader = CircleLoader.createGeometricLoader()
        loader.startAnimation()
        let parameters: [String: Any] = ["useridto": AppData.mySelf.userId]
        let url = LinkBuilder.build(serviceName: "message_popup_get_popup_notifications", withParameters: LinkBuilder.prepareParameters(params: parameters))
        self.newsTask = TaskManager(url: URL(string: url)!)
        self.newsTask.delegate = self
        self.newsTask.execute()
    }
    
    @objc private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
   
}

extension BeePNotificationViewController: TaskManagerDelegate {
    
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        DispatchQueue.main.async {
            self.loader.stopAnimation()
        }
        if result {
            let notificationParser = NotificationParser(target: self, stringData: stringContent)
            notificationParser.parse {
                self.collectionView.reloadData()
            }
        } else {
            //Show error
            DispatchQueue.main.async {
                let errorVC = ErrorAlertController()
                errorVC.isLoadingPhase = false
                errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: stringContent)
                errorVC.modalPresentationStyle = .overFullScreen
                self.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}

extension BeePNotificationViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        realNumberOfItems = AppData.notifications.count
        return (realNumberOfItems==0) ? 1 : realNumberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(realNumberOfItems == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCell", for: indexPath) as! GenericCollectionViewCell
            cell.backgroundColor = .clear
            cell.text = NSLocalizedString("global.nocontent", comment: "No content")
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notificationCell", for: indexPath) as! NotificationCollectionViewCell
        cell.notification = AppData.notifications[indexPath.item]
        cell.layer.cornerRadius = 15
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if (realNumberOfItems == 0) {return}
        let notificationVC = NotificationViewController()
        notificationVC.notification = AppData.notifications[indexPath.item]
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
}
