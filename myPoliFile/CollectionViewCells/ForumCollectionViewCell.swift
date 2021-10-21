//
//  ForumCollectionViewCell.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 15/09/21.
//

import Foundation
import UIKit

class ForumCollectionViewCell: UICollectionViewCell {
    var discussion: Discussion! {
        didSet{
            label.text = discussion.subject
            timeLabel.text = discussion.date
            userLabel.text = discussion.sender
        }
    }
    
    private let label = UILabel()
    private let timeLabel = UILabel()
    private let userLabel = UILabel()
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            backgroundColor = .secondarySystemGroupedBackground
        } else {
            backgroundColor = .white
        }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        contentView.addSubview(userLabel)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        userLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        userLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        if #available(iOS 13.0, *) {
            userLabel.textColor = .secondaryLabel
        } else {
            userLabel.textColor = .lightGray
        }
        userLabel.font = .systemFont(ofSize: 15)
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = .zero
        
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        timeLabel.font = .systemFont(ofSize: 15)
        timeLabel.numberOfLines = .zero
        timeLabel.textAlignment = .right
        if #available(iOS 13.0, *) {
            timeLabel.textColor = .secondaryLabel
        } else {
            timeLabel.textColor = .lightGray
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
