//
//  SignalCell.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class SignalCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "SignalCell"

    private static let twoDigitFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    private static let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowsNonnumericFormatting = false
        return formatter
    }()

    private let sourceView = SquareView(title: "source")
    private let typeView = SquareView(title: "type")
    private let dataRateView = SquareView(title: "data rate")
    private let frequencyView = SquareView(title: "frequency")
    private let powerView = SquareView(title: "power")

    var signal: Signal? {
        didSet {
            sourceView.detail = signal?.spacecraftName
            typeView.detail = signal?.type.rawValue
            frequencyView.detail = frequencyString(for: signal?.frequency)
            powerView.detail = powerString(for: signal?.power)

            guard let signal = signal else { return }

            if signal.isUploading {
                powerView.title = "POWER TRANSMITTED"
                dataRateView.detail = nil
            } else {
                powerView.title = "POWER RECEIVED"
                let byteCount = Int64(Double(signal.dataRate) ?? 0.0)
                dataRateView.detail = SignalCell.byteFormatter.string(fromByteCount: byteCount).lowercased() + "/s"
            }
            layoutIfNeeded()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        for (index, view) in [sourceView, typeView, dataRateView, frequencyView, powerView].enumerated() {
            addSubview(view)
            addConstraints(to: view, toLeftAnchor: index % 2 == 0)
        }

        let firstMiddleLine = ThinLineView.add(to: self)
        let secondMiddleLine = ThinLineView.add(to: self)
        let bottomLine = ThinLineView.add(to: self, offset: 0)

        let constraints = [
            sourceView.topAnchor.constraint(equalTo: topAnchor),
            typeView.topAnchor.constraint(equalTo: topAnchor),

            dataRateView.topAnchor.constraint(equalTo: sourceView.bottomAnchor),
            frequencyView.topAnchor.constraint(equalTo: sourceView.bottomAnchor),

            powerView.topAnchor.constraint(equalTo: dataRateView.bottomAnchor),

            firstMiddleLine.topAnchor.constraint(equalTo: sourceView.bottomAnchor),
            secondMiddleLine.topAnchor.constraint(equalTo: dataRateView.bottomAnchor),
            bottomLine.topAnchor.constraint(equalTo: powerView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Formatters

    private func frequencyString(for frequency: String?) -> String {
        guard let frequency = frequency,
            !frequency.characters.isEmpty,
            let value = Double(frequency) else {
                return "-"
        }
        if value < 1000 {
            let number = NSNumber(value: value)
            return SignalCell.twoDigitFormatter.string(from: number)! + " Hz"
        } else if value < 1000000 {
            let number = NSNumber(value: value / 1000)
            return SignalCell.twoDigitFormatter.string(from: number)! + " kHz"
        } else if value < 1000000000 {
            let number = NSNumber(value: value / 1000000)
            return SignalCell.twoDigitFormatter.string(from: number)! + " MHz"
        } else if value < 1000000000000 {
            let number = NSNumber(value: value / 1000000000)
            return SignalCell.twoDigitFormatter.string(from: number)! + " GHz"
        } else {
            return ">= 1 THz"
        }
    }

    private func powerString(for power: String?) -> String {
        guard let signal = signal,
            let power = power,
            !power.characters.isEmpty,
            let value = Double(power) else {
                return "-"
        }

        let unit: String
        if signal.isUploading {
            unit = " kW"
        } else {
            unit = " dBm"
        }

        let number = NSNumber(value: value)
        return SignalCell.twoDigitFormatter.string(from: number)! + unit
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
