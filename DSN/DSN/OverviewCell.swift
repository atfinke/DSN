//
//  OverviewCell.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class OverviewCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "OverviewCell"

    private let dishView = DishView()
    private let titleLabel = UILabel()
    private let offlineLabel = UILabel()

    var antennaStatus: AntennaStatus? {
        didSet {
            dishView.update(status: antennaStatus)
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        dishView.backgroundColor = UIColor.clear
        dishView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Dosis-SemiBold", size: 42.0)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        offlineLabel.text = "OFFLINE"
        offlineLabel.textAlignment = .center
        offlineLabel.textColor = UIColor.lightText
        offlineLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        offlineLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(dishView)
        addSubview(titleLabel)
        addSubview(offlineLabel)

        let constraints = [
            dishView.leftAnchor.constraint(equalTo: leftAnchor),
            dishView.rightAnchor.constraint(equalTo: rightAnchor),
            dishView.heightAnchor.constraint(equalToConstant: 180.0),
            dishView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),

            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 48),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            offlineLabel.leftAnchor.constraint(equalTo: leftAnchor),
            offlineLabel.rightAnchor.constraint(equalTo: rightAnchor),
            offlineLabel.heightAnchor.constraint(equalToConstant: 18),
            offlineLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Updates

    func update(title: String, offline isOffline: Bool) {
        titleLabel.text = title
        offlineLabel.isHidden = !isOffline
    }

}
