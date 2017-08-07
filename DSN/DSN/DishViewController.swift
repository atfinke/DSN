//
//  DishViewController.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class DishViewController: UIViewController {

    // MARK: - Types

    enum Section {
        case overview
        case targets([Target])
        case uplinks([Signal])
        case downlinks([Signal])
        case antenna(AntennaStatus)

        var title: String {
            switch self {
            case .overview:     return ""
            case .targets:      return "targeting"
            case .uplinks:    return "uplinks"
            case .downlinks:  return "downlinks"
            case .antenna:      return "antenna"
            }
        }

        var height: CGFloat {
            switch self {
            case .overview:     return 280.0
            case .targets:      return SquareView.height * 2
            case .uplinks:    return SquareView.height * 3
            case .downlinks:  return SquareView.height * 3
            case .antenna:      return SquareView.height * 2
            }
        }

        var items: Int {
            switch self {
            case .overview: return 1
            case .targets(let targets): return targets.count
            case .uplinks(let signals): return signals.count
            case .downlinks(let signals): return signals.count
            case .antenna: return 1
            }
        }
    }

    // MARK: - Properties

    var sections = [Section]()

    var dish: Dish! {
        didSet {
            dish.antennaUpdatedHandler = { status in
                self.antennaStatusUpdated(status: status)
            }
            antennaStatusUpdated(status: dish.antennaStatus)
        }
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self

            collectionView.register(SignalCell.self, forCellWithReuseIdentifier: SignalCell.reuseIdentifier)
            collectionView.register(AntennaCell.self, forCellWithReuseIdentifier: AntennaCell.reuseIdentifier)
            collectionView.register(OverviewCell.self, forCellWithReuseIdentifier: OverviewCell.reuseIdentifier)
            collectionView.register(TargetingCell.self, forCellWithReuseIdentifier: TargetingCell.reuseIdentifier)
            collectionView.register(HeaderReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                    withReuseIdentifier: HeaderReusableView.reuseIdentifier)

        }
    }

    // MARK: View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInsets(newSize: view.frame.size)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateInsets(newSize: size)

        }, completion: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }

    private func updateInsets(newSize: CGSize) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let multiplier: CGFloat
            if newSize.width > 1000 {
                multiplier = 0.25
            } else if newSize.width > 520 {
                multiplier = 0.15
            } else {
                multiplier = 0
            }
            let inset = newSize.width * multiplier
            collectionView?.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
    }

    // MARK: - Section Construction

    private func antennaStatusUpdated(status: AntennaStatus?) {
        buildSections(for: status)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }

    func buildSections(for status: AntennaStatus?) {
        var updatedSections: [Section] = [.overview]
        defer {
            sections = updatedSections
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }

        guard let antennaStatus = status else { return }

        let targets = antennaStatus.targets.sorted(by: { (one, two) -> Bool in
            return one.spacecraft?.displayName ?? "" < two.spacecraft?.displayName ?? ""
        })

        if !targets.isEmpty {
            updatedSections.append(.targets(targets))
        }

        if !antennaStatus.azimuthAngle.isEmpty, !antennaStatus.elevationAngle.isEmpty {
            updatedSections.append(.antenna(antennaStatus))
        }

        let upSignals = antennaStatus.signals.filter { $0.isUploading }
        if !upSignals.isEmpty {
            updatedSections.append(.uplinks(upSignals))
        }

        let downSignals = antennaStatus.signals.filter { !$0.isUploading }
        if !downSignals.isEmpty {
            updatedSections.append(.downlinks(downSignals))
        }
    }

}
