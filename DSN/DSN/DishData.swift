//
//  DishData.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

struct AntennaStatus {
    let name: String

    let windSpeed: String
    let azimuthAngle: String
    let elevationAngle: String

    var signals: [Signal]
    var targets: [Target]
}
