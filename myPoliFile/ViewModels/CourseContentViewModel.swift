//
//  CoursesContentViewModel.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 24/09/21.
//

import Foundation
import UIKit

class CourseContentViewModel {
    
    private var loader: Loader?
    private var target: UIViewController!
    private var collectionView: UICollectionView!
    private var course: Course!
    private var courseTask: TaskManager!
    private var courseURL: String = ""
    
    required init(target: UIViewController, collectionView: UICollectionView, course: Course, loader: Loader?){
        self.target = target
        self.collectionView = collectionView
        self.loader = loader
        self.course = course
    }
    
    func loadContent() {
        if(self.course.sections.count == 0){
            downloadCourse()
        } else {
            if (PreferenceManager.getCoursesReloading()){
                downloadCourse()
            }
        }
    }
    
    private func downloadCourse() {
        self.course.sections.removeAll()
        loader = CircleLoader.createGeometricLoader()
        loader?.startAnimation()
        let parameters: [String: Any] = ["courseid":self.course.courseId]
        self.courseURL = LinkBuilder.build(serviceName: "core_course_get_contents", withParameters: LinkBuilder.prepareParameters(params: parameters))
        courseTask = TaskManager(url: URL(string: self.courseURL)!)
        courseTask.delegate = self
        courseTask.execute()
    }
    
    func registerCollectionViewElements() {
        collectionView.register(ModuleCollectionViewCell.self, forCellWithReuseIdentifier: "moduleCell")
        collectionView.register(SectionTitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionTitleView")
    }
    
    func numberOfSection() -> Int {
        return self.course.sections.count
    }
    
    func numberOfModulesInSection(section: Int) -> Int{
        return self.course.sections[section].content.count
    }
    
    func getCollectionViewCellForModule(atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moduleCell", for: indexPath) as! ModuleCollectionViewCell
        cell.layer.cornerRadius = 15
        let module = self.course.sections[indexPath.section].content[indexPath.item]
        cell.moduleName = module.name
        cell.moduleImage = module.icon
        return cell
    }
    
    func getCollectionViewHeader(forIndexPath indexPath: IndexPath) -> UICollectionReusableView{
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionTitleView", for: indexPath) as! SectionTitleCollectionReusableView
        header.sectionTitle = self.course.sections[indexPath.section].name
        return header
    }
    
    func performActionForCell(atIndexPath indexPath: IndexPath) -> Void {
        let module = self.course.sections[indexPath.section].content[indexPath.item]
        switch module.modname {
        case .url:
            let m = module as! ModuleURL
            if(m.contents.count == 1){
                UIApplication.shared.open(URL(string: m.contents.first!.contentURL)!, options: [:], completionHandler: nil)
            } else {
                //Load a menù
            }
            break
        case .forum:
            let forumController = ForumViewController()
            forumController.forum = (module as! ModuleForum)
            target.navigationController?.pushViewController(forumController, animated: true)
            break
        case .folder:
            //Open folder controller
            AppData.currentModule = module.name
            let folderController = FolderViewController()
            folderController.module = module
            folderController.folder = FolderViewController.prepareFiles(myFiles: (module as! ModuleFolder).contents, forCurrentPath: "/")
            target.navigationController?.pushViewController(folderController, animated: true)
            break
        case .resource:
            AppData.currentModule = ""
            let m = module as! ModuleResource
            guard let content = m.contents else {return}
            let fileAction = FileOpenAction(target: target, moduleContent: content, loader: self.loader)
            fileAction.displayActions()
            break
        default:
            return
        }
    }
    
}

extension CourseContentViewModel: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        if result {
            let detailParser = CourseDetailParser(target: target, stringData: stringContent, targetCourse: self.course)
            detailParser.parse {
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
