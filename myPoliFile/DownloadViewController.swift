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
    private var files: [OfflineFile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        setupCollectionView()
        self.quickLookController.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.files = DeviceFileManager.loadFiles() ?? []
        collectionView.reloadData()
        quickLookController.reloadData()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(OfflineFileCollectionViewCell.self, forCellWithReuseIdentifier: "fileCell")
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCell")
    }
    

}

extension DownloadViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        realNumberOfFiles = self.files.count
        return realNumberOfFiles == 0 ? 1 : realNumberOfFiles
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
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
        if(realNumberOfFiles == 0){
            return CGSize(width: collectionView.frame.width-20, height: collectionView.frame.height-20)
        }
        return CGSize(width: collectionView.frame.width-20, height: 62)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if(realNumberOfFiles==0){return}
        let selectedFile = self.files[indexPath.item]
        let file = DeviceFileManager.getFileUrl(forFile: selectedFile)
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
}

extension DownloadViewController: QLPreviewControllerDataSource{
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return files.count
    }
       
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let fileURL = DeviceFileManager.getFileUrl(forFile: self.files[index])
        if let fURL = fileURL {
            return fURL as QLPreviewItem
        }
        return "" as! QLPreviewItem
    }
}
