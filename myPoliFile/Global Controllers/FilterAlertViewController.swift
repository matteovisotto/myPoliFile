//
//  FilterAlertViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 19/09/22.
//

import Foundation
import UIKit

class FilterAlertViewController: AlertViewController {
    private let filters = ["all", "current", "old"]
    private var currentSelection = 0;
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let cancelButton = AppButton()
    private let confirmButton = AppButton()
    private var segmentControl: UISegmentedControl!
    var callback: (_ filter: String)->() = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var items: [String] = []
        for x in self.filters {
            items.append(NSLocalizedString("global.filter."+x, comment: ""))
        }
        self.segmentControl = UISegmentedControl(items: items)
        setupLayouts()
        self.currentSelection = filterToIndex(PreferenceManager.getCourseFilter())
        self.segmentControl.selectedSegmentIndex = self.currentSelection
    }
    
    private func setupLayouts() {
        alertView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .center
        titleLabel.text = NSLocalizedString("alert.filter.title", comment: "")
        
        alertView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        messageLabel.text = NSLocalizedString("alert.filter.message", comment: "")
        messageLabel.numberOfLines = .zero
        
        alertView.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15).isActive = true
        segmentControl.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = .primaryBackground
            segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBackground], for: UIControl.State.selected)
        } else {
            segmentControl.tintColor = .primaryBackground
            segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        }
        segmentControl.addTarget(self, action: #selector(didSegmentChanged), for: .valueChanged)
        
        let stackView = UIStackView()
        alertView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 15).isActive = true
        stackView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        cancelButton.normalColor = .systemRed
        cancelButton.highlightedColor = .systemOrange
        
        cancelButton.setTitle(NSLocalizedString("global.cancel", comment: "Cancel"), for: .normal)
        confirmButton.setTitle(NSLocalizedString("global.apply", comment: ""), for: .normal)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(confirmButton)
        
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    @objc private func didTapCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapLogin() {
        self.dismiss(animated: true, completion: nil)
        callback(indexToFilter(self.currentSelection))
    }
    
    @objc private func didSegmentChanged(_ sender: UISegmentedControl) {
        self.currentSelection = sender.selectedSegmentIndex
    }
    
    private func filterToIndex(_ filter: String) -> Int {
        if filter == "current" {
            return 1
        } else if filter == "old" {
            return 2
        }
        
        return 0
    }
    
    private func indexToFilter(_ index: Int) -> String {
        switch index {
        case 1:
            return "current"
        case 2:
            return "old"
        default:
            return "all"
        }
    }
}
