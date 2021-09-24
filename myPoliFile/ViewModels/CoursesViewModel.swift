//
//  CoursesViewModel.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 24/09/21.
//

import Foundation
import UIKit

class CoursesViewModel {
    
    private var loader: Loader? = nil
    private var target: UIViewController!
    private var collectionView: UICollectionView!
    private var courseTask: TaskManager!
    
    let menuItems: [String] = [NSLocalizedString("home.all", comment: "All"), NSLocalizedString("home.favourite", comment: "Favourite"), NSLocalizedString("home.hidden", comment: "Hidden")]
    var selectedMenuIndex = 0
    
    var realNumberOfItems = 0 {
        didSet{
            if realNumberOfItems==0 {
                isEmpty = true
            } else {
                isEmpty = false
            }
        }
    }
    
    var isEmpty: Bool = true
    
    required init(target: UIViewController, collectionView: UICollectionView, loader: Loader?){
        self.loader = loader
        self.target = target
        self.collectionView = collectionView
    }
    
    
    
    func loadContent() {
        if(AppData.courses.count == 0){
            downloadCourses()
        } else {
            if (PreferenceManager.getCoursesReloading()){
                downloadCourses()
            }
        }
    }
    
    func downloadCourses() {
        loader = CircleLoader.createGeometricLoader()
        loader?.startAnimation()
        AppData.clearCourses()
        let parameters: [String: Any] = ["userid":AppData.mySelf.userId]
        let urlString = LinkBuilder.build(serviceName: "core_enrol_get_users_courses", withParameters: LinkBuilder.prepareParameters(params: parameters))
        self.courseTask = TaskManager(url: URL(string: urlString)!)
        self.courseTask.delegate = self
        self.courseTask.execute()
    }
    
    func registerCollectionViewElements() {
        collectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: "courseCell")
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCell")
    }
    
    func getNumberOfElements() -> Int {
        if(self.selectedMenuIndex == 0){
            realNumberOfItems = AppData.courses.count
        } else if (self.selectedMenuIndex == 1){
            realNumberOfItems = AppData.favouriteCourses.count
        } else {
            realNumberOfItems = AppData.hiddenCourses.count
        }

        return (realNumberOfItems==0) ? 1 : realNumberOfItems
    }
    
    func getCollectionViewCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        if(isEmpty){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCell", for: indexPath) as! GenericCollectionViewCell
            cell.backgroundColor = .clear
            cell.text = NSLocalizedString("global.nocontent", comment: "Nothing to show")
            return cell
        }
        
        var course: Course!
        if(self.selectedMenuIndex == 0){
            course = AppData.courses[indexPath.item]
        } else if (self.selectedMenuIndex == 1){
            course = AppData.favouriteCourses[indexPath.item]
        } else {
            course = AppData.hiddenCourses[indexPath.item]
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCell", for: indexPath) as! CourseCollectionViewCell
        cell.layer.cornerRadius = 15
        cell.tagView.textColor = .white
        cell.text = course.displayName
        let category = Category.getCategoryById(categoryId: course.category)
        if let cat = category {
            cell.tagView.text = cat.categoryName
            if(cat.categoryName.lowercased() == "ccs"){
                cell.tagView.color = .buttonPrimary
            } else if (cat.categoryName.lowercased() == "generale") {
                cell.tagView.text = "Generic"
                cell.tagView.color = .systemOrange
            } else {
                cell.tagView.color = .systemGreen
            }
        }
        return cell
    }
    
    func performActionForCell(atIndexPath indexPath: IndexPath) -> Void {
        if isEmpty {return}
        var course: Course!
        if(self.selectedMenuIndex == 0){
            course = AppData.courses[indexPath.item]
        } else if (self.selectedMenuIndex == 1){
            course = AppData.favouriteCourses[indexPath.item]
        } else {
            course = AppData.hiddenCourses[indexPath.item]
        }
        let detailVC = CourseContentViewController()
        detailVC.course = course
        AppData.currentCourse = StringParser.parseCourseName(course.fullname).courseName
        target.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension CoursesViewModel: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        if result {
            let parser = CourseParser(target: target, stringData: stringContent)
            parser.parse {
                self.collectionView.reloadData()
                self.loader?.stopAnimation()
            }
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
