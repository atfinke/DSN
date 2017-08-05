//
//  Dish.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

class Dish {

    // MARK: - Properties

    let name: String
    let displayName: String
    let type: String
    let site: Site

    var antennaStatus: AntennaStatus? {
        didSet {
            antennaUpdatedHandler?(antennaStatus)
        }
    }
    var antennaUpdatedHandler: ((AntennaStatus?) -> Void)?

    // MARK: - Initialization

    init(name: String, displayName: String, type: String, site: Site) {
        self.name = name
        self.displayName = displayName
        self.type = type
        self.site = site
    }

}

extension Dish: Equatable {
    //swiftlint:disable:next operator_whitespace
    static func ==(lhs: Dish, rhs: Dish) -> Bool {
        return lhs.name == rhs.name
    }
}
