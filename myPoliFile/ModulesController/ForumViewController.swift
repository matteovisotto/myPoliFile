//
//  ForumViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit

class ForumViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    private var navigationBar = BackHeader()
    private var loader = Loader()
    public var forum: ModuleForum! {
        didSet {
            navigationBar.titleLabel.text = forum.name
        }
    }
    private var realNumberOfItems: Int = 0
    private var content: [Discussion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width-20, height: 10)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContent()
    }
    
    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = .clear
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCell")
        collectionView.register(ForumCollectionViewCell.self, forCellWithReuseIdentifier: "forumCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadContent() {
        self.loader = CircleLoader.createGeometricLoader()
        self.loader.startAnimation()
        self.content.removeAll()
        let parameters: [String: Any] = ["forumid": forum.instance]
        let urlStr = LinkBuilder.build(serviceName: "mod_forum_get_forum_discussions", withParameters: LinkBuilder.prepareParameters(params: parameters))
        let forumTask = TaskManager(url: URL(string: urlStr)!)
        forumTask.delegate = self
        forumTask.execute()
    }

}

extension ForumViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        DispatchQueue.main.async {
            self.loader.stopAnimation()
        }
        if result{
            let discParser = ForumParser(target: self, stringData: stringContent)
            discParser.parse(completionHandler: { discussions in
                self.content = discussions
                self.collectionView.reloadData()
            })
        } else {
            //Show error
            DispatchQueue.main.async {
                self.loader.stopAnimation()
                let errorVC = ErrorAlertController()
                errorVC.isLoadingPhase = false
                errorVC.setContent(title: "Error", message: stringContent)
                errorVC.modalPresentationStyle = .overFullScreen
                self.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}

extension ForumViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        realNumberOfItems = self.content.count
        return (realNumberOfItems==0) ? 1 : realNumberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(realNumberOfItems == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCell", for: indexPath) as! GenericCollectionViewCell
            cell.backgroundColor = .clear
            cell.text = "Nothing to show"
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forumCell", for: indexPath) as! ForumCollectionViewCell
        cell.discussion = self.content[indexPath.item]
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
        let forumContentVC = ForumContentViewController()
        forumContentVC.discussion = self.content[indexPath.item]
        self.navigationController?.pushViewController(forumContentVC, animated: true)
    }
}
