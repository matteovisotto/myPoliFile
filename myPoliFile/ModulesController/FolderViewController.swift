//
//  FolderViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit

class FolderViewController: BaseViewController {
    
    public class DisplayableFolder {
        var name: String = ""
        var path: String = ""
        var subfolders: [DisplayableFolder] = []
        var files: [FolderContent] = []
    }
    
    
    public static func prepareFiles(myFiles: [FolderContent], forCurrentPath path: String) -> DisplayableFolder {
        var fileOk: Bool = false
        let displayableFolder = DisplayableFolder()
        displayableFolder.path = path
        displayableFolder.name = ""
        for f in myFiles {
            fileOk = false
            let filePath = f.contentPath
            if(filePath == "/"){
                displayableFolder.files.append(f)
            } else {
                //The file is not in the root
                for s in displayableFolder.subfolders {
                    if(s.path == filePath){
                        s.files.append(f)
                        fileOk = true
                        break
                    }
                }
                if(!fileOk){
                    let newDF = DisplayableFolder()
                    newDF.files.append(f)
                    newDF.name = filePath.replacingOccurrences(of: "/", with: "")
                    newDF.path = filePath
                    displayableFolder.subfolders.append(newDF)
                    fileOk = true
                }
            }
        }
        return displayableFolder
    }
    
    open var module: Module! {
        didSet{
            self.folderModule = module as! ModuleFolder
        }
    }
    
    private var loader = Loader()
    private var folderModule: ModuleFolder = ModuleFolder()
    private var navigationBar = BackHeader()
    private var collectionView: UICollectionView!
    private var realNumberOfFolders: Int = 0
    private var realNumberOfFiles: Int = 0
    
    open var viewPath: String = "/"
    open var folder: DisplayableFolder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        setupNavigationBar()
        setupCollectionView()
        
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
        navigationBar.titleLabel.text = folderModule.name
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.backgroundColor = .clear
        collectionView.register(SectionTitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "titleView")
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCVCell")
        collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: "fileCell")
        collectionView.register(FolderCollectionViewCell.self, forCellWithReuseIdentifier: "folderCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FolderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0){
            realNumberOfFolders = self.folder.subfolders.count
            if(realNumberOfFolders == 0){
                return 1
            }
            return realNumberOfFolders
        }
        realNumberOfFiles = self.folder.files.count
        if(realNumberOfFiles == 0){
            return 1
        }
        return realNumberOfFiles
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section == 0){
            if(realNumberOfFolders == 0){
                //No folder, load empty
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCVCell", for: indexPath) as! GenericCollectionViewCell
                cell.text = "No folder available"
                cell.backgroundColor = .clear
                return cell
            }
            //One or more folder exists
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCollectionViewCell
            cell.layer.cornerRadius = 15
            cell.folderName = self.folder.subfolders[indexPath.item].name
            return cell
        }
        //Files
        if(realNumberOfFiles == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCVCell", for: indexPath) as! GenericCollectionViewCell
            cell.text = "No files available"
            cell.backgroundColor = .clear
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fileCell", for: indexPath) as! FileCollectionViewCell
        cell.file = self.folder.files[indexPath.item]
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let myView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "titleView", for: indexPath) as! SectionTitleCollectionReusableView
        if(indexPath.section == 0) {
            myView.sectionTitle = "Folders"
        } else {
            myView.sectionTitle = "Files"
        }
        return myView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.section == 0){
            return CGSize(width: collectionView.frame.width-20, height: 54)
        }
        return CGSize(width: collectionView.frame.width-20, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section == 0){
            if(realNumberOfFolders==0){return}
            let newFolderVC = FolderViewController()
            newFolderVC.module = self.module
            newFolderVC.viewPath = self.folder.subfolders[indexPath.item].path
            newFolderVC.folder = self.folder.subfolders[indexPath.item]
            self.navigationController?.pushViewController(newFolderVC, animated: true)
            return
        }
        if(realNumberOfFiles==0){return}
        let selectedFile = self.folderModule.contents[indexPath.item]
        let fileAction = FileOpenAction(target: self, moduleContent: selectedFile, loader: self.loader)
        fileAction.displayActions()
    }
}

