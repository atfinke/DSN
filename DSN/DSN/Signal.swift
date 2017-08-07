//
//  Signal.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

struct Signal {

    // MARK: - Types

    enum SignalType: String {
        case data, carrier
    }

    // MARK: - Properties

    let isUploading: Bool
    let type: SignalType

    let dataRate: String
    let frequency: String
    let power: String

    let spacecraftName: String

}
