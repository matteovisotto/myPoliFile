//
//  DownloadViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import UIKit
import QuickLook

class DownloadViewController: BaseViewController {

    private var collectionView: UICollectionView!
    private let quickLookController = QLPreviewController()
    private var realNumberOfFiles: Int = 0
    private var realNumberOfFolders: Int = 0
    private var files: [OfflineFile] = []
    private var folders: [OfflineFolder] = []
    private var currentPath: String = "/"
    private let refreshControl = UIRefreshControl()
    private let backView = UIView()
    private var backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        setupCollectionView()
        setupBackButton()
        self.quickLookController.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        loadContent()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        backView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        backView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        backView.backgroundColor = .clear
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.backView.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(OfflineFileCollectionViewCell.self, forCellWithReuseIdentifier: "fileCell")
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCell")
        collectionView.register(OfflineFolderCollectionViewCell.self, forCellWithReuseIdentifier: "folderCell")
        collectionView.register(SectionTitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "titleView")
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didAskRefresh), for: .valueChanged)
        refreshControl.tintColor = .primary.withAlphaComponent(0.5)
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
    }
    
    private func setupBackButton() {
        backView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 10).isActive = true
        backButton.topAnchor.constraint(equalTo: backView.topAnchor, constant: 5).isActive = true
        backButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -5).isActive = true
        backButton.setTitleColor(.primary, for: .normal)
        backButton.isEnabled = false
        backButton.setTitle("Main directory", for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        let calculatedPath = managePaths(forCurrentPath: self.currentPath)
        self.currentPath = calculatedPath
        if(calculatedPath == "/") {
            self.backButton.setTitle("Main directory", for: .normal)
            self.backButton.isEnabled = false
        }
        self.loadContent()
    }
    
    @objc private func didAskRefresh() {
        print(self.currentPath)
        loadContent()
        
        refreshControl.endRefreshing()
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }

        let p = gestureRecognizer.location(in: collectionView)

        if let indexPath = collectionView.indexPathForItem(at: p) {
            let section = indexPath.section
            let item = indexPath.item
            let deleteAlert = FileDeleteBottomSheet()
            if(section==0 && !(self.realNumberOfFolders==0)){
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                let folder = folders[item]
                deleteAlert.alertTitle = "Delete folder?"
                deleteAlert.alertDescription = "Are you sure you want to delete folder " + folder.folderName + " and all the files it contains?"
                deleteAlert.completion = {result in
                    if result {
                        let _ = DeviceFileManager.deleteFolder(using: folder)
                        self.loadContent()
                    }
                }
            } else if (section==1 && !(self.realNumberOfFiles==0)){
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                let file = files[item]
                deleteAlert.alertTitle = "Delete file?"
                deleteAlert.alertDescription = "Are you sure you want to delete " + file.fileName
                deleteAlert.completion = {result in
                    if result {
                        let _ = DeviceFileManager.deleteFile(using: file, inCourseFolder: self.currentPath)
                        self.loadContent()
                    }
                }
            } else {return}
            deleteAlert.modalPresentationStyle = .overFullScreen
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    private func loadContent() {
        guard let loaded = DeviceFileManager.loadFiles(forDirectoryPath: self.currentPath) else {return}
        self.files = loaded["files"] as? [OfflineFile] ?? []
        self.folders = loaded["folders"] as? [OfflineFolder] ?? []
        collectionView.reloadData()
        quickLookController.reloadData()
    }
    
    private func managePaths(forCurrentPath path: String) -> String{
        var parts = path.split(separator: "/")
        parts = parts.dropLast()
        var path: String = "/"
        if parts.count == 0 {return "/"}
        for part in parts {
            path = path + "/" + part
        }
        return path
    }
}

//MARK:- CollectionView Delegates and Data Source
extension DownloadViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            realNumberOfFolders = self.folders.count
            return realNumberOfFolders == 0 ? 1 : realNumberOfFolders
        }
        realNumberOfFiles = self.files.count
        return realNumberOfFiles == 0 ? 1 : realNumberOfFiles
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            if(realNumberOfFolders == 0){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCell", for: indexPath) as! GenericCollectionViewCell
                cell.text = "No folder available"
                cell.backgroundColor = .clear
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as!OfflineFolderCollectionViewCell
            cell.folder = folders[indexPath.item]
            cell.layer.cornerRadius = 15
            return cell
        }
        if(realNumberOfFiles == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCell", for: indexPath) as! GenericCollectionViewCell
            cell.text = "No files available"
            cell.backgroundColor = .clear
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fileCell", for: indexPath) as! OfflineFileCollectionViewCell
        cell.file = files[indexPath.item]
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            if(realNumberOfFolders == 0){
                return CGSize(width: collectionView.frame.width-20, height: 15)
            }
            return CGSize(width: collectionView.frame.width-20, height: 62)
        }
        
        if(realNumberOfFiles == 0){
            return CGSize(width: collectionView.frame.width-20, height: 15)
        }
        return CGSize(width: collectionView.frame.width-20, height: 62)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if (realNumberOfFolders==0){return}
            self.backButton.setTitle("< Back", for: .normal)
            self.backButton.isEnabled = true
            self.currentPath = folders[indexPath.item].folderURL
            loadContent()
            self.collectionView.reloadData()
            self.quickLookController.reloadData()
            return
        }
        if(realNumberOfFiles==0){return}
        let selectedFile = self.files[indexPath.item]
        let file = DeviceFileManager.getFileUrl(forFile: selectedFile, inCourseFolder: self.currentPath)
        if let fileToDisplay = file {
            if QLPreviewController.canPreview(fileToDisplay as QLPreviewItem) {
                quickLookController.currentPreviewItemIndex = indexPath.item
                navigationController?.navigationBar.isHidden = false
                navigationController?.pushViewController(quickLookController, animated: true)
            } else {
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [fileToDisplay], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView=self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        } else {
            let errorVC = ErrorAlertController()
            errorVC.isLoadingPhase = false
            errorVC.setContent(title: "Error", message: "Unable to find the file path")
            errorVC.modalPresentationStyle = .overFullScreen
            self.present(errorVC, animated: true, completion: nil)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

//MARK:- QLPreview Data Source
extension DownloadViewController: QLPreviewControllerDataSource{
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return files.count
    }
       
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let fileURL = DeviceFileManager.getFileUrl(forFile: self.files[index], inCourseFolder: self.currentPath)
        if let fURL = fileURL {
            return fURL as QLPreviewItem
        }
        return "" as! QLPreviewItem
    }
}
