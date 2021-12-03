//
//  FileOpenAction.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 26/11/21.
//

import Foundation
import UIKit

class FileOpenAction {
    
    private var target: UIViewController!
    private var file: ModuleContent!
    private var loader: Loader? = nil
    
    
    required init(target: UIViewController, moduleContent: ModuleContent, loader: Loader?) {
        self.target = target
        self.file = moduleContent
        self.loader = loader
        
    }
      
    func displayActions() -> Void {
        //0 - Open; 1 - Download; 2 - Ask
        if(!self.file.isOpenable) {
            downloadFile()
            return
        }
        let defaultOption = PreferenceManager.getFileDefaultAction() ?? 2
        switch defaultOption {
        case 0:
            openFile()
            break
        case 1:
            downloadFile()
            break
        default:
            ask()
            break
        }
    }
    
    private func downloadFile() {
        self.loader = CircleLoader.createGeometricLoader()
        self.loader?.startAnimation()
        let downloader = Downloader(file: self.file)
        downloader.delegate = self
        downloader.startDownload()
    }
    
    private func openFile() {
       let fileVC = FileViewerViewController()
        fileVC.file = self.file
        self.target.navigationController?.pushViewController(fileVC, animated: true)
    }
    
    private func ask() {
        let askAlert = FileOptionBottomSheet()
        askAlert.modalPresentationStyle = .overFullScreen
        askAlert.completion = { result, selection in
            if result {
                if selection == 0 {
                    self.openFile()
                } else {
                    self.downloadFile()
                }
            } else {
                return
            }
        }
        self.target.present(askAlert, animated: true, completion: nil)
    }
    
    
}

extension FileOpenAction: DownloaderDelegate {
    
    func didDownloaded(result: Bool, url: URL?) {
        DispatchQueue.main.async{
            self.loader?.stopAnimation()
            let resAlert = FeedbackAlert()
            resAlert.modalPresentationStyle = .overFullScreen
            if result {
                resAlert.setText(title: NSLocalizedString("global.done", comment: "Done"))
                resAlert.setIcon(icon: UIImage(named: "doneIcon")!)
            } else {
                resAlert.setText(title: NSLocalizedString("global.error", comment: "Error"))
                resAlert.setIcon(icon: UIImage(named: "cross")!)
            }
            self.target.present(resAlert, animated: true, completion: nil)
        }
        
    }
    
    
}
