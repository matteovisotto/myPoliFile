//
//  BeePNotificationViewModel.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 24/09/21.
//

import Foundation
import UIKit

class BeePNotificationViewModel {
    private var target: UIViewController!
    private var collectionView: UICollectionView!
    private var loader: Loader?
    private var newsTask: TaskManager!
    private var realNumberOfItems: Int = 0
    
    required init(target: UIViewController, collectionView: UICollectionView, loader: Loader?) {
        self.target = target
        self.collectionView = collectionView
        self.loader = loader
    }
    
    func registerCollectionViewElements() {
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCell")
        collectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: "notificationCell")
    }
    
    func loadContent() {
        AppData.notifications.removeAll()
        loader = CircleLoader.createGeometricLoader()
        loader?.startAnimation()
        let parameters: [String: Any] = ["useridto": AppData.mySelf.userId]
        let url = LinkBuilder.build(serviceName: "message_popup_get_popup_notifications", withParameters: LinkBuilder.prepareParameters(params: parameters))
        self.newsTask = TaskManager(url: URL(string: url)!)
        self.newsTask.delegate = self
        self.newsTask.execute()
    }
    
    func numberOfElement() -> Int {
        realNumberOfItems = AppData.notifications.count
        return (realNumberOfItems==0) ? 1 : realNumberOfItems
    }
    
    func getCollectionViewCell(atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func performActionForCell(atIndexPath indexPath: IndexPath) -> Void {
        if (realNumberOfItems == 0) {return}
        let notificationVC = NotificationViewController()
        notificationVC.notification = AppData.notifications[indexPath.item]
        target.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
}

extension BeePNotificationViewModel: TaskManagerDelegate {
    
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        DispatchQueue.main.async {
            self.loader?.stopAnimation()
        }
        if result {
            let notificationParser = NotificationParser(target: target, stringData: stringContent)
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
                self.target.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}
