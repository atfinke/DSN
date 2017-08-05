//
//  Model.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation
import UIKit
//import Crashlytics

class Model: NSObject {

    // MARK: - Properties

    var dishes: [Dish] = []
    var loadedDishes: (() -> Void)?
    var failedLoadingDishes: (() -> Void)?

    private var fetchTimer: Timer?
    private var failedLastUpdate = false

    private var spacecraft = [Spacecraft]()

    private let signalFetcher = DSNSignalFetcher()
    private let configFetcher = DSNConfigFetcher()

    lazy var storyboard: UIStoryboard = {
        guard let name = Bundle.main.infoDictionary?["UIMainStoryboardFile"] as? String else { fatalError() }
        return UIStoryboard(name: name, bundle: nil)
    }()

    // MARK: - Data Fetching

    func restartFetch() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        failedLastUpdate = false

        fetchConfig()
        fetchSignals()

        fetchTimer?.invalidate()
        fetchTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            if self.failedLastUpdate {
                timer.invalidate()
            } else {
                self.fetchSignals()
            }
        }
    }

    private func fetchConfig() {
        configFetcher.fetch { (newDishes, spacecraft) in
            if let newDishes = newDishes {
                for dish in newDishes {
                    if let index = self.dishes.index(of: dish) {
                        dish.antennaUpdatedHandler = self.dishes[index].antennaUpdatedHandler
                    }
                }
                self.dishes = newDishes
            } else {
                self.updateFailed()
            }

            if let spacecraft = spacecraft {
                self.spacecraft = spacecraft
            } else {
                self.updateFailed()
            }
            //Answers.logCustomEvent(withName: "Config Fetch", customAttributes: nil)
        }
    }

    private func fetchSignals() {
        signalFetcher.fetch(with: self.spacecraft) { (antennaStatuses) in
            if let antennaStatuses = antennaStatuses, !antennaStatuses.isEmpty {
                for (dishIndex, dish) in self.dishes.enumerated() {
                    if let status = antennaStatuses.filter({ $0.name == dish.name }).first {
                        self.dishes[dishIndex].antennaStatus = status
                    }
                }
            } else {
                self.updateFailed()
            }

            self.loadedDishes?()
            //Answers.logCustomEvent(withName: "Signals Fetch", customAttributes: nil)
        }
    }

    private func updateFailed() {
        if !self.failedLastUpdate {
            failedLastUpdate = true
            self.failedLoadingDishes?()
        }
    }

    // MARK: - Formatting

    func title(for siteName: String) -> String {
        if siteName == "MADRID" {
            return "🇪🇸 " + siteName
        } else if siteName == "GOLDSTONE" {
            return "🇺🇸 " + siteName
        } else if siteName == "CANBERRA" {
            return "🇦🇺 " + siteName
        } else {
            return "🏳 " + siteName
        }
    }
    
}
