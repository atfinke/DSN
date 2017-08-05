//
//  HeaderReusableView.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {

    // MARK: - Properties

    static let reuseIdentifier = "HeaderView"

    private let titleLabel = UILabel()
    private var lineView: ThinLineView?

    var text: String? {
        set {
            titleLabel.text = newValue?.uppercased()
        }
        get {
            return titleLabel.text
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Dosis-SemiBold", size: 24.0)!
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        let lineView = ThinLineView.add(to: self, offset: 0)

        let constraints = [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

            lineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        self.lineView = lineView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
