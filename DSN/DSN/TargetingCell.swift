//
//  TargetingCell.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class TargetingCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "TargetingCell"

    private static let twoDigitFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    private let targetingView = SquareView(title: "spacecraft")
    private let rangeView = SquareView(title: "Range")
    private let timeView = SquareView(title: "Round-trip light time")

    var target: Target? {
        didSet {
            guard let target = target, let spacecraft = target.spacecraft else {
                [rangeView, timeView].forEach({
                    $0.detail = nil
                })
                targetingView.detail = self.target?.name
                return
            }

            targetingView.detail = spacecraft.displayName.uppercased()
            if let range = target.range, let string = distanceString(for: range) {
                rangeView.detail = string
            } else {
                rangeView.detail = nil
            }

            if let lightTime = target.rtlt, let string = lightTimeString(for: lightTime) {
                timeView.detail = string
            } else {
                timeView.detail = nil
            }
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        let middleLine = ThinLineView.add(to: self)
        let bottomLine = ThinLineView.add(to: self, offset: 0)

        for (index, view) in [targetingView, rangeView, timeView].enumerated() {
            addSubview(view)
            addConstraints(to: view, toLeftAnchor: index % 2 == 0)
        }

        let constraints = [
            targetingView.topAnchor.constraint(equalTo: topAnchor),
            rangeView.topAnchor.constraint(equalTo: topAnchor),

            timeView.topAnchor.constraint(equalTo: targetingView.bottomAnchor),

            middleLine.topAnchor.constraint(equalTo: targetingView.bottomAnchor),
            bottomLine.topAnchor.constraint(equalTo: timeView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Formatters

    private func lightTimeString(for lightTime: Double) -> String? {
        if lightTime == -1.0 {
            return nil
        } else if lightTime < 60,
            let string = TargetingCell.twoDigitFormatter.string(from: NSNumber(value: lightTime)) {
            return string + " sec"
        } else if lightTime < 3600,
            let string = TargetingCell.twoDigitFormatter.string(from: NSNumber(value: lightTime / 60)) {
            return string + " minutes"
        } else if lightTime < 86400,
            let string = TargetingCell.twoDigitFormatter.string(from: NSNumber(value: lightTime / 3600)) {
            return string + " hours"
        } else if lightTime < 604800,
            let string = TargetingCell.twoDigitFormatter.string(from: NSNumber(value: lightTime / 86400)) {
            return string + " days"
        } else if lightTime >= 604800 {
            return ">= 1 week"
        }
        return nil
    }

    private func distanceString(for range: Double) -> String? {
        if range == -1.0 {
            return nil
        } else if range < 1000,
            let string = TargetingCell.twoDigitFormatter.string(from: NSNumber(value: range)) {
            return string + " km"
        } else if range < 1000000,
            let string = TargetingCell.twoDigitFormatter.string(from: NSNumber(value: range / 1000)) {
            return string + " k km"
        } else if range < 1000000000,
            let string = TargetingCell.twoDigitFormatter.string(from: NSNumber(value: range / 1000000)) {
            return string + " mn km"
        } else if range < 1000000000000,
            let string = TargetingCell.twoDigitFormatter.string(from: NSNumber(value: range / 1000000000)) {
            return string + " bn km"
        } else if range < 1000000000000000,
            let string = TargetingCell.twoDigitFormatter.string(from: NSNumber(value: range / 1000000000000)) {
            return string + " tn km"
        } else if range >= 1000000000000000 {
            return ">= 1 qd km"
        }
        return nil
    }

    // MARK: - Auto Layout

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
