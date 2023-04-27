//
//  PlanetTableViewCell.swift
//  JPMorganTest
//
//  Created by Praveen Kumar on 27/04/23.
//

import UIKit

class PlanetTableViewCell: UITableViewCell {

    private(set) var label: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyDefaultConfiguration()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyDefaultConfiguration()
    }

    private func applyDefaultConfiguration() {
        selectionStyle = .none
        contentView.addSubview(label)
        addConstraints()
    }

    private func addConstraints() {
        let labelInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: labelInsets.left),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: labelInsets.top),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -labelInsets.right),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -labelInsets.bottom),
        ])

        setNeedsLayout()
    }
    
    func configureLabelText(text: String) {
        label.text = text
    }

}
