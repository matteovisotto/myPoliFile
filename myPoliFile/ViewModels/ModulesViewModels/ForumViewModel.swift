//
//  ForumViewModel.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 25/09/21.
//

import Foundation
import UIKit

class ForumViewModel {
    
    private var target: UIViewController!
    private var collectionView: UICollectionView!
    private var loader: Loader?
    private var forum: ModuleForum!
    private var realNumberOfItems: Int = 0
    
    required init (target: UIViewController, collectionView: UICollectionView, forum: ModuleForum, loader: Loader?) {
        self.target = target
        self.collectionView = collectionView
        self.forum = forum
        self.loader = loader
    }
    
    func downloadData() {
        self.forum.content.removeAll()
        self.loader = CircleLoader.createGeometricLoader()
        self.loader?.startAnimation()
        let parameters: [String: Any] = ["forumid": forum.instance]
        let urlStr = LinkBuilder.build(serviceName: "mod_forum_get_forum_discussions", withParameters: LinkBuilder.prepareParameters(params: parameters))
        let forumTask = TaskManager(url: URL(string: urlStr)!)
        forumTask.delegate = self
        forumTask.execute()
    }
    
    func registerCollectionViewElements() {
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCell")
        collectionView.register(ForumCollectionViewCell.self, forCellWithReuseIdentifier: "forumCell")
    }
    
    func getNumberOfElements() -> Int {
        realNumberOfItems = self.forum.content.count
        return (realNumberOfItems==0) ? 1 : realNumberOfItems
    }
    
    func getCollectionViewCell(atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        if(realNumberOfItems == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCell", for: indexPath) as! GenericCollectionViewCell
            cell.backgroundColor = .clear
            cell.text = NSLocalizedString("global.nocontent", comment: "No content")
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forumCell", for: indexPath) as! ForumCollectionViewCell
        cell.discussion = self.forum.content[indexPath.item]
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func performActionForCell(atIndexPath indexPath: IndexPath) -> Void {
        if (realNumberOfItems == 0) {return}
        let forumContentVC = ForumContentViewController()
        forumContentVC.discussion = self.forum.content[indexPath.item]
        target.navigationController?.pushViewController(forumContentVC, animated: true)
    }
    
}

extension ForumViewModel: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        DispatchQueue.main.async {
            self.loader?.stopAnimation()
        }
        if result{
            let discParser = ForumParser(target: target, stringData: stringContent)
            discParser.parse(completionHandler: { discussions in
                self.forum.content = discussions
                self.collectionView.reloadData()
            })
        } else {
            //Show error
            DispatchQueue.main.async {
                self.loader?.stopAnimation()
                let errorVC = ErrorAlertController()
                errorVC.isLoadingPhase = false
                errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: stringContent)
                errorVC.modalPresentationStyle = .overFullScreen
                self.target.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}
