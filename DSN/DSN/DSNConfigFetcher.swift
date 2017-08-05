//
//  DSNConfigFetcher.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation

class DSNConfigFetcher: NSObject, XMLParserDelegate {

    // MARK: - Properties

    private enum ParserKey: String {
        case site, dish, name, friendlyName, longitude, latitude, type, spacecraft
    }

    private var completion: (([Dish]?, [Spacecraft]?) -> Void)?

    private var activeKey: ParserKey?
    private var activeSite: Site?

    private var allDishes = [Dish]()
    private var allSpacecraft = [Spacecraft]()

    // MARK: - Fetching

    func fetch(completion: @escaping ([Dish]?, [Spacecraft]?) -> Void) {
        self.completion = completion

        let url = URL(string: "http://eyes.jpl.nasa.gov/dsn/config.xml")!
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }

    // MARK: - Parser

    //swiftlint:disable:next line_length
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == ParserKey.spacecraft.rawValue,
            let name = attributeDict[ParserKey.name.rawValue],
            let displayName = attributeDict[ParserKey.friendlyName.rawValue] {
            let spacecraft = Spacecraft(name: name, displayName: displayName, range: nil, lightTime: nil)
            
            allSpacecraft.append(spacecraft)
        } else if elementName == ParserKey.site.rawValue,
            let name = attributeDict[ParserKey.name.rawValue],
            let displayName = attributeDict[ParserKey.friendlyName.rawValue],
            let latitude = attributeDict[ParserKey.latitude.rawValue],
            let longitude = attributeDict[ParserKey.longitude.rawValue] {

            activeSite = Site(name: name, displayName: displayName, latitude: latitude, longitude: longitude)
        } else if elementName == ParserKey.dish.rawValue, let site = activeSite,
            let name = attributeDict[ParserKey.name.rawValue],
            let displayName = attributeDict[ParserKey.friendlyName.rawValue],
            let type = attributeDict[ParserKey.type.rawValue] {

            let dish = Dish(name: name, displayName: displayName, type: type, site: site)
            allDishes.append(dish)
        }
    }

    //swiftlint:disable:next line_length
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == ParserKey.site.rawValue, activeSite != nil {
            activeSite = nil
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        allDishes = allDishes.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.name < rhs.name
        }).sorted(by: { (lhs, rhs) -> Bool in
            return lhs.site.displayName > rhs.site.displayName
        })

        self.completion?(allDishes, allSpacecraft)
        allDishes = []
        allSpacecraft = []
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.completion?(nil, nil)
    }
}
