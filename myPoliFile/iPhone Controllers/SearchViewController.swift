//
//  SearchViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    
    private var courses: [Course] = []
    private var realNumberOfItems: Int = 0
    private var taskManeger: TaskManager!
    private var loader = Loader()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupSearchBar()
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width-20, height: 10)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        setupCollectionView()
    }
    

    private func setupSearchBar() {
        searchBar.searchBarStyle = .minimal
        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchBar.delegate = self
        
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
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

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.realNumberOfItems = self.courses.count
        return (realNumberOfItems==0) ? 1 : realNumberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(realNumberOfItems == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCell", for: indexPath) as! GenericCollectionViewCell
            cell.backgroundColor = .clear
            cell.text = NSLocalizedString("global.noresult", comment: "No result")
            return cell
        }
        
        let course: Course = self.courses[indexPath.item]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if (realNumberOfItems == 0) {return}
        let course = self.courses[indexPath.item]
        let enrollAlert = EnrollAlertController()
        enrollAlert.course = course
        enrollAlert.callback = { result in
            if(result){
                let feedback = FeedbackAlert()
                feedback.setIcon(icon: UIImage(named: "doneIcon")!)
                feedback.setText(title: NSLocalizedString("global.done", comment: "Done"))
                feedback.modalPresentationStyle = .overFullScreen
                feedback.modalTransitionStyle = .crossDissolve
                self.present(feedback, animated: true, completion: nil)
            } else {
                let feedback = FeedbackAlert()
                feedback.setIcon(icon: UIImage(named: "cross")!)
                feedback.setText(title: NSLocalizedString("global.error", comment: "Error"))
                feedback.modalPresentationStyle = .overFullScreen
                feedback.modalTransitionStyle = .crossDissolve
                self.present(feedback, animated: true, completion: nil)
            }
        }
        enrollAlert.modalPresentationStyle = .overFullScreen
        enrollAlert.modalTransitionStyle = .crossDissolve
        self.present(enrollAlert, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if (searchBar.text == nil || searchBar.text == "" ) {
        view.endEditing(true)
        self.courses.removeAll()
        collectionView.reloadData()
       }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text == nil || searchBar.text == "" ) {
            view.endEditing(true)
            self.courses.removeAll()
            collectionView.reloadData()
        } else {
            searchBar.resignFirstResponder()
            loader = CircleLoader.createGeometricLoader()
            loader.startAnimation()
            let parameters: [String: Any] = ["criterianame": "search", "criteriavalue": searchBar.text!]
            let urlString = LinkBuilder.build(serviceName: "core_course_search_courses", withParameters: LinkBuilder.prepareParameters(params: parameters))
            self.taskManeger = TaskManager(url: URL(string: urlString.replacingOccurrences(of: " ", with: "%20"))!)
            self.taskManeger.delegate = self
            self.taskManeger.execute()
        }
    }
}

extension SearchViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        DispatchQueue.main.async {
            self.loader.stopAnimation()
        }
        if result {
            let parser = SearchCourseParser(target: self, stringData: stringContent)
            parser.parse { results in
                self.courses = results
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
