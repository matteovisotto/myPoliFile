//
//  FolderViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit

class FolderViewController: BaseViewController {
    
    public static func prepareFiles(myFiles: [FolderContent]) -> [String: [FolderContent]] {
        var dic: [String: [FolderContent]] = [:]
        for f in myFiles {
            if var arr = dic[f.contentPath]{
                arr.append(f)
            } else {
                var arr: [FolderContent] = []
                arr.append(f)
                dic[f.contentPath] = arr
            }
        }
        return dic
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
    open var files: [String: [FolderContent]] = [:]
    private var folderContents: [FolderContent]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        setupNavigationBar()
        setupCollectionView()
        if let c = files[viewPath]{
            folderContents = c
        } else {
            folderContents = []
        }
        files.removeValue(forKey: viewPath)
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
            realNumberOfFolders = self.files.keys.count
            if(realNumberOfFolders == 0){
                return 1
            }
            return realNumberOfFolders
        }
        realNumberOfFiles = self.folderContents.count
        if(realNumberOfFiles == 0){
            return 1
        }
        return self.folderContents.count
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
            cell.folderName = (Array(self.files.keys))[indexPath.item].replacingOccurrences(of: "/", with: "")
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
        cell.file = folderContents[indexPath.item]
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
            let newFolderVC = FolderViewController()
            newFolderVC.module = self.module
            newFolderVC.viewPath = (Array(self.files.keys))[indexPath.item]
            newFolderVC.files = [(Array(self.files.keys))[indexPath.item]: self.files[(Array(self.files.keys))[indexPath.item]]!]
            self.navigationController?.pushViewController(newFolderVC, animated: true)
            return
        }
        let selectedFile = folderContents[indexPath.item]
        let fileAction = FileAction(target: self, moduleContent: selectedFile, loader: self.loader)
        fileAction.displayActions()
    }
}

