//
//  PageViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 17/09/22.
//

import Foundation
import UIKit

class PageViewController: BaseViewController {
    private var navigationBar = BackHeader()
    
    private var displayLabel: UITextView = UITextView()
    
    private var testHTML = "<div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\"></p><h4>Data and Information Quality (DQ) 2022-2023</h4><p><br>    </p><table>    <caption></caption>    <thead>    <tr>    <th scope=\"col\">Date</th>    <th scope=\"col\">Topic</th>    <th scope=\"col\">Recolodings' link</th>    </tr>    </thead>    <tbody>    <tr>    <td>14 -09 - 2022</td>    <td>&nbsp;Introduction to the course (<a href=\"01%20intro.pdf\">slides</a>)&nbsp;</td>    <td><span style=\"font-size: 13.6px;\"><a href=\"https://bit.ly/3SmhiGn\" class=\"_blanktarget\">https://bit.ly/3SmhiGn</a></span></td>    </tr>    <tr>    <td>16 - 09 - 2022</td>    <td>Data Governance (<a href=\"02%20Data%20Governance.pdf\">slides</a>)</td>    <td></td>    </tr><tr>    <td>&nbsp;21 - 09 - 2022</td>    <td>&nbsp;DQ dimensions&nbsp;</td>    <td>&nbsp;</td>    </tr>    </tbody>    </table>    <br><br><p></p><br><p></p></div>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        setupLayout()
        displayLabel.attributedText = testHTML.html2Attributed
    }
    
    private func setupLayout() {
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = backgroundColor
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.backButton.addTarget(self, action: #selector(didTapback), for: .touchUpInside)
        
        self.view.addSubview(displayLabel)
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        displayLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        displayLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        displayLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        displayLabel.isEditable = false
        displayLabel.delegate = self
    }
    
    
    @objc private func didTapback(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension PageViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL.absoluteString)
        return false
    }
}
