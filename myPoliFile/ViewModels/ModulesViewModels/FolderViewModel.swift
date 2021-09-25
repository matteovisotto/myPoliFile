//
//  FolderViewModel.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 25/09/21.
//

import Foundation
import UIKit

class FolderViewModel {
    
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
    
    private var target: UIViewController!
    private var loader: Loader?
    private var collectionView: UICollectionView!
    private var realNumberOfFolders: Int = 0
    private var realNumberOfFiles: Int = 0
    var folderModule: ModuleFolder = ModuleFolder()
    open var viewPath: String = "/"
    open var folder: DisplayableFolder!
    
    required init(target: UIViewController, collectionView: UICollectionView, folderModule: ModuleFolder, loader: Loader?){
        self.target = target
        self.collectionView = collectionView
        self.folderModule = folderModule
        self.loader = loader
    }
    
    func registerCollectionViewElements() {
        collectionView.register(SectionTitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "titleView")
        collectionView.register(GenericCollectionViewCell.self, forCellWithReuseIdentifier: "genericCVCell")
        collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: "fileCell")
        collectionView.register(FolderCollectionViewCell.self, forCellWithReuseIdentifier: "folderCell")
    }
    
    func getNumberOfElements(inSection section: Int) -> Int {
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
    
    func getCollectionViewCel(atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section == 0){
            if(realNumberOfFolders == 0){
                //No folder, load empty
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genericCVCell", for: indexPath) as! GenericCollectionViewCell
                cell.text = NSLocalizedString("global.nofolder", comment: "No folder")
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
            cell.text = NSLocalizedString("global.nofile", comment: "No file")
            cell.backgroundColor = .clear
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fileCell", for: indexPath) as! FileCollectionViewCell
        cell.file = self.folder.files[indexPath.item]
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func getCollectionViewHeader(atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        let myView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "titleView", for: indexPath) as! SectionTitleCollectionReusableView
        if(indexPath.section == 0) {
            myView.sectionTitle = NSLocalizedString("global.folders", comment: "Folders")
        } else {
            myView.sectionTitle = NSLocalizedString("global.files", comment: "Files")
        }
        return myView
    }
    
    func performActionForCell(atIndexPath indexPath: IndexPath, completion: (_ section: Int)->Void) -> Void {
        if (indexPath.section == 0){
            if(realNumberOfFolders==0){return}
            completion(indexPath.section)
            return
        }
        if(realNumberOfFiles==0){return}
        let selectedFile = self.folder.files[indexPath.item]
        let fileAction = FileOpenAction(target: target, moduleContent: selectedFile, loader: self.loader)
        fileAction.displayActions()
    }
}
