//
//  DishViewController+CollectionView.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

//swiftlint:disable line_length
extension DishViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        let width = collectionView.frame.width - (collectionView.contentInset.left * 2) - 5
        return CGSize(width: width, height: section.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }
        let width = collectionView.frame.width - (collectionView.contentInset.left * 2) - 5
        return CGSize(width: width, height: 90.0)
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        if kind == UICollectionElementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {
                fatalError()
            }
            headerView.text = section.title
            return headerView
        } else {
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]

        switch section {
        case .overview:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCell.reuseIdentifier, for: indexPath) as? OverviewCell else {
                fatalError()
            }
            cell.update(title: dish.displayName, offline: sections.count <= 1)
            cell.antennaStatus = dish.antennaStatus
            return cell
        case .targets(let targets):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TargetingCell.reuseIdentifier, for: indexPath) as? TargetingCell else {
                fatalError()
            }
            cell.target = targets[indexPath.row]
            return cell
        case .uplinks(let signals):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignalCell.reuseIdentifier, for: indexPath) as? SignalCell else {
                fatalError()
            }
            cell.signal = signals[indexPath.row]
            return cell
        case .downlinks(let signals):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignalCell.reuseIdentifier, for: indexPath) as? SignalCell else {
                fatalError()
            }
            cell.signal = signals[indexPath.row]
            return cell
        case .antenna(let status):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AntennaCell.reuseIdentifier, for: indexPath) as? AntennaCell else {
                fatalError()
            }
            cell.status = status
            return cell
        }
    }

}
