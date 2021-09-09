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
    
    open var text: String = "" {
        didSet {
            label.text = parseText(text)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        addSubview(tagView)
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        tagView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        tagView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        tagView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = .zero
    }
    
    private func parseText(_ text: String) -> String{
        if (text.contains("{mlang}")){
            var regex = "\\{mlang\\}\\{mlang [a-z]{2}\\}"
            var repl = "\n"
            let txt = text.replacingOccurrences(of: regex, with: repl, options: [.regularExpression])
            regex = "\\{mlang[ ]?[a-z]*\\}"
            repl = ""
            return txt.replacingOccurrences(of: regex, with: repl, options: [.regularExpression])
        }
        return text
    }
}
