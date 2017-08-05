//
//  Spacecraft.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation
struct Spacecraft: Hashable {
    let name: String
    let displayName: String

    var range: Double?
    var lightTime: Double?

    var hashValue: Int {
        return name.hashValue ^ displayName.hashValue
    }

    static func == (lhs: Spacecraft, rhs: Spacecraft) -> Bool {
        return lhs.name == rhs.name && lhs.displayName == rhs.displayName
    }
}
