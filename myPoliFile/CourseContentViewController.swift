//
//  CourseContentViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import UIKit

class CourseContentViewController: BaseViewController {
    
    public var course: Course!
    private var courseTask: TaskManager!
    private var courseURL: String = ""
    private let navigationBar = BackHeader()
    private var loader = Loader()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadCourse()
        
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
        navigationBar.titleLabel.text = "Detail"
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.backgroundColor = .clear
        collectionView.register(ModuleCollectionViewCell.self, forCellWithReuseIdentifier: "moduleCell")
        collectionView.register(SectionTitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionTitleView")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func downloadCourse() {
        self.course.sections.removeAll()
        loader = CircleLoader.createGeometricLoader()
        loader.startAnimation()
        let parameters: [String: Any] = ["courseid":self.course.courseId]
        self.courseURL = LinkBuilder.build(serviceName: "core_course_get_contents", withParameters: LinkBuilder.prepareParameters(params: parameters))
        courseTask = TaskManager(url: URL(string: self.courseURL)!)
        courseTask.delegate = self
        courseTask.execute()
    }
    
    
    @objc private func didTapBack(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension CourseContentViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        if result {
            let detailParser = CourseDetailParser(target: self, stringData: stringContent, targetCourse: self.course)
            detailParser.parse {
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

extension CourseContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.course.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.course.sections[section].content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moduleCell", for: indexPath) as! ModuleCollectionViewCell
        cell.layer.cornerRadius = 15
        let module = self.course.sections[indexPath.section].content[indexPath.item]
        cell.moduleName = module.name
        cell.moduleImage = module.icon
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-20, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionTitleView", for: indexPath) as! SectionTitleCollectionReusableView
        header.sectionTitle = self.course.sections[indexPath.section].name
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if(self.course.sections[section].content.count == 0) {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            self.navigationController?.pushViewController(forumController, animated: true)
            break
        case .folder:
            //Open folder controller
            AppGlobal.currentModule = module.name
            let folderController = FolderViewController()
            folderController.module = module
            folderController.files = FolderViewController.prepareFiles(myFiles: (module as! ModuleFolder).contents)
            self.navigationController?.pushViewController(folderController, animated: true)
            break
        case .resource:
            AppGlobal.currentModule = ""
            let m = module as! ModuleResource
            guard let content = m.contents else {return}
            let fileAction = FileOpenAction(target: self, moduleContent: content, loader: self.loader)
            fileAction.displayActions()
            break
        default:
            return
        }
    }
    
}

