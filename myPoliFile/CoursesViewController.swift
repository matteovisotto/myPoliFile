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
    
    private var loader = Loader()
    private var courseTask: TaskManager!
    private let topMenu = TopMenu()
    private let menuItems: [String] = ["All", "Favourire", "Hidden"]
    private var selectedMenuIndex = 0
    private var realNumberOfItems = 0
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupTopMenu()
        let collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        setupCollectionView()
        self.topMenu.setSelectedIndex(atIndex: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadCourses()
    }
    
    private func setupTopMenu() {
        self.view.addSubview(topMenu)
        topMenu.translatesAutoresizingMaskIntoConstraints = false
        topMenu.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        topMenu.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        topMenu.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topMenu.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        topMenu.delegate = self
        topMenu.dataSource = self
        
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topMenu.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: "courseCell")
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCell")
    }

    private func downloadCourses() {
        loader = CircleLoader.createGeometricLoader()
        loader.startAnimation()
        Course.clear()
        let parameters: [String: Any] = ["userid":User.mySelf.userId]
        let urlString = LinkBuilder.build(serviceName: "core_enrol_get_users_courses", withParameters: LinkBuilder.prepareParameters(params: parameters))
        self.courseTask = TaskManager(url: URL(string: urlString)!)
        self.courseTask.delegate = self
        self.courseTask.execute()
    }
}

extension CoursesViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        if result {
            let parser = CourseParser(target: self, stringData: stringContent)
            parser.parse {
                self.collectionView.reloadData()
                self.loader.stopAnimation()
            }
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

extension CoursesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(self.selectedMenuIndex == 0){
            realNumberOfItems = Course.courses.count
        } else if (self.selectedMenuIndex == 1){
            realNumberOfItems = Course.favourite.count
        } else {
            realNumberOfItems = Course.hidden.count
        }

        return (realNumberOfItems==0) ? 1 : realNumberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(realNumberOfItems == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCell", for: indexPath) as! GenericCollectionViewCell
            cell.backgroundColor = .clear
            cell.text = "Nothing to show"
            return cell
        }
        
        var course: Course!
        if(self.selectedMenuIndex == 0){
            course = Course.courses[indexPath.item]
        } else if (self.selectedMenuIndex == 1){
            course = Course.favourite[indexPath.item]
        } else {
            course = Course.hidden[indexPath.item]
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath) as! CourseCollectionViewCell
        cell.layer.cornerRadius = 15
        cell.tagView.textColor = .white
        cell.text = course.displayName
        let category = Category.getCategoryById(categoryId: course.category)
        if let cat = category {
            cell.tagView.text = cat.categoryName
            if(cat.categoryName.lowercased() == "ccs"){
                cell.tagView.color = .primary
            } else if (cat.categoryName.lowercased() == "generale") {
                cell.tagView.text = "Generic"
                cell.tagView.color = .systemOrange
            } else {
                cell.tagView.color = .systemGreen
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: MainViewController.safeAreaBottom+MainViewController.tabBarHeight+10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (realNumberOfItems == 0){
            return CGSize(width: collectionView.bounds.width-20, height: collectionView.bounds.height-20)
        }
        return CGSize(width: collectionView.bounds.width-20, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if (realNumberOfItems == 0) {return}
        var course: Course!
        if(self.selectedMenuIndex == 0){
            course = Course.courses[indexPath.item]
        } else if (self.selectedMenuIndex == 1){
            course = Course.favourite[indexPath.item]
        } else {
            course = Course.hidden[indexPath.item]
        }
        let detailVC = CourseContentViewController()
        detailVC.course = course
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension CoursesViewController: MVTopMenuDelegate, MVTopMenuDataSource {
    
    func topMenu(topMenuView: MVTopMenuView, titleForItemAtIndex itemIndex: Int) -> String {
        return self.menuItems[itemIndex]
    }
    
    func numberOfItemInMenu(topMenuView: MVTopMenuView) -> Int {
        return self.menuItems.count
    }
    
    func topMenu(topMenuView: MVTopMenuView, didSelectItemAtIndex itemIndex: Int) {
        self.selectedMenuIndex = itemIndex
        self.collectionView.reloadData()
    }
}
