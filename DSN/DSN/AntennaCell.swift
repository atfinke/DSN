//
//  AntennaCell.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class AntennaCell: UICollectionViewCell {

    static let reuseIdentifier = "AntennaCell"

    let dishView = SquareView(title: "Dish")
    let azimuthView = SquareView(title: "Azimuth")

    let elevationView = SquareView(title: "Elevation")
    let windView = SquareView(title: "Wind Speed")

    var status: AntennaStatus? {
        didSet {
            guard let status = status else {
                [dishView, azimuthView, elevationView, windView].forEach({
                    $0.detail = nil
                })
                return
            }

            dishView.detail = status.name
            azimuthView.detail = status.azimuthAngle + " DEG"

            elevationView.detail = status.elevationAngle + " DEG"
            windView.detail = status.windSpeed + " km/hr"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let middleLine = ThinLineView.add(to: self)
        let bottomLine = ThinLineView.add(to: self, offset: 0)

        for (index, view) in [dishView, azimuthView, elevationView, windView].enumerated() {
            addSubview(view)
            addConstraints(to: view, toLeftAnchor: index % 2 == 0)
        }

        let constraints = [
            dishView.topAnchor.constraint(equalTo: topAnchor),
            azimuthView.topAnchor.constraint(equalTo: topAnchor),

            elevationView.topAnchor.constraint(equalTo: dishView.bottomAnchor),
            windView.topAnchor.constraint(equalTo: dishView.bottomAnchor),

            middleLine.topAnchor.constraint(equalTo: dishView.bottomAnchor),
            bottomLine.topAnchor.constraint(equalTo: windView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addConstraints(to view: UIView, toLeftAnchor isLeftSquare: Bool) {
        view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [
            view.heightAnchor.constraint(equalToConstant: SquareView.height),
            view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        ]
        if isLeftSquare {
            constraints.append(view.leftAnchor.constraint(equalTo: leftAnchor))
        } else {
            constraints.append(view.rightAnchor.constraint(equalTo: rightAnchor))
        }
        NSLayoutConstraint.activate(constraints)
    }
}
