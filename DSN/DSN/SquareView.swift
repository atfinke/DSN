//
//  SquareView.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class SquareView: UIView {

    // MARK: - Properties

    static var height: CGFloat = 80.0

    private let titleLabel = UILabel(frame: .zero)
    private let detailLabel = UILabel(frame: .zero)

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            if let text = newValue?.uppercased() {
                titleLabel.text = text
            } else {
                titleLabel.text = "-"
            }
        }
    }

    var detail: String? {
        get {
            return detailLabel.text
        }
        set {
            if let text = newValue?.uppercased(), !text.isEmpty {
                detailLabel.text = text
            } else {
                detailLabel.text = "-"
            }
        }
    }

    // MARK: - Initialization

    init(title: String) {
        super.init(frame: .zero)

        titleLabel.text = title.uppercased()
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.lightText
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14.0, weight: UIFontWeightRegular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        detail = "-"
        detailLabel.numberOfLines = 3
        detailLabel.textAlignment = .left
        detailLabel.textColor = UIColor.white
        detailLabel.font = UIFont.systemFont(ofSize: 24.0)
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.translatesAutoresizingMaskIntoConstraints = false

        isUserInteractionEnabled = false
        addSubview(titleLabel)
        addSubview(detailLabel)

        let constraints = [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20.0),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),

            detailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            detailLabel.rightAnchor.constraint(equalTo: rightAnchor),
            detailLabel.heightAnchor.constraint(equalToConstant: 40.0),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
