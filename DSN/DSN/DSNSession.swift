//
//  DSNSession.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation
class DSNSession {
    static let shared: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 25
        config.urlCache = nil
        return URLSession(configuration: config)
    }()
}
