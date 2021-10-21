//
//  CourseCollectionViewCell.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    let tagView = TagView()
    
    private let label = UILabel()
    private let profLabel = UILabel()
    private let numberLabel = UILabel()
    
    open var text: String = "" {
        didSet {
            let courseName = StringParser.parseCourseName(text)
            numberLabel.text = courseName.courseNumber
            label.text = courseName.courseName
            profLabel.text = courseName.courseProf
        }
    }
    
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
        contentView.addSubview(tagView)
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        tagView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        tagView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        tagView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.leftAnchor.constraint(equalTo: tagView.rightAnchor, constant: 10).isActive = true
        numberLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: tagView.centerYAnchor).isActive = true
        numberLabel.font = .systemFont(ofSize: 15)
        numberLabel.textAlignment = .right
        if #available(iOS 13.0, *) {
            numberLabel.textColor = .secondaryLabel
        } else {
            numberLabel.textColor = .lightGray
        }
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
                
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = .zero
        
        contentView.addSubview(profLabel)
        profLabel.translatesAutoresizingMaskIntoConstraints = false
        profLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        profLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        profLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        profLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        profLabel.font = .systemFont(ofSize: 15)
        profLabel.numberOfLines = .zero
        if #available(iOS 13.0, *) {
            profLabel.textColor = .secondaryLabel
        } else {
            profLabel.textColor = .lightGray
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
}
