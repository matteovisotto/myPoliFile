//
//  SettingsViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import UIKit
import MessageUI

class SettingsViewController: BaseViewController {

    private let navigationBar = BackHeader()
    private let profileView = UserInfoView()
    
    private lazy var tableView: UITableView = {
        if #available(iOS 13.0, *){
            return UITableView(frame: .zero, style: .insetGrouped)
        } else {
            return UITableView(frame: .zero, style: .grouped)
        }
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        setNavigationBar()
        setProfileView()
        setTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    private func setNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = .groupTableViewBackground
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        navigationBar.titleLabel.text = ""
       
    }

    private func setProfileView() {
        self.view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.backgroundColor = .groupTableViewBackground
        profileView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        profileView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        profileView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        profileView.email = User.mySelf.email
        profileView.fullname = User.mySelf.fullname
        
    }
    
    private func setTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let appBundle = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        footerLabel.text = "Version " + appVersion + " ("+appBundle+")"
        footerLabel.textAlignment = .center
        footerLabel.font = .systemFont(ofSize: 12)
        tableView.tableFooterView = footerLabel
    }
    
    @objc private func didTapBack() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        PreferenceManager.setFileDefaultAction(defaultAction: sender.selectedSegmentIndex)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = SegmentTableViewCell()
            cell.selectedIndex = PreferenceManager.getFileDefaultAction() ?? 2
            cell.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
            return cell
        } else if (indexPath.section == 1) {
            if(indexPath.row == 0){
                let cell = UITableViewCell()
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "Contact app developer"
                return cell
            }
            return UITableViewCell()
        } else {
            let cell = UITableViewCell()
            cell.accessoryType = .none
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = .red
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Default file action"
        case 1:
            return "Information"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Set the default action for a file that can be opended in preview. If it can't it will alwayes be downloaded"
        case 1:
            return ""
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
         if (indexPath.section == 1) {
            if(indexPath.row == 0) {
                let mailComposeViewController = configureMailController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    print("Unable to send mail")
                }
            }
         } else if (indexPath.section == 2){
            //Logout
            PreferenceManager.removeToken()
            PreferenceManager.removePersonalCode()
            PreferenceManager.removeFileDefaultAction()
            User.mySelf = User()
            Category.categories.removeAll()
            Course.clear()
            
            let rootVC = UINavigationController(rootViewController: WelcomeViewController())
            rootVC.navigationBar.isHidden = true
            let ad = UIApplication.shared.delegate as! AppDelegate
            let window = ad.window
            window?.rootViewController = rootVC
            window?.makeKeyAndVisible()
            
        }
    }
    
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    //Function to send an email
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["matteo.visotto@mail.polimi.it"])
        mailComposerVC.setSubject("[myPoliFile]")
        mailComposerVC.setMessageBody("", isHTML: true)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
