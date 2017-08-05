//
//  DSNSignalFetcher.swift
//  DSN
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import Foundation
class DSNSignalFetcher: NSObject, XMLParserDelegate {

    // MARK: - Properties

    private let timestampDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()

    private enum ParserKey: String {
        case config, sites, spacecraftMap
        case dish, name, friendlyName, type, spacecraft, explorerName, uplegRange, downlegRange, rtlt
        case upSignal, downSignal, signalType, signalTypeDebug, dataRate, frequency, power, target
    }

    private var spacecraft = [Spacecraft]()
    private var completion: (([AntennaStatus]?) -> Void)?

    private var activeStatus: AntennaStatus?
    private var allAntennaStatuses = [AntennaStatus]()

    // MARK: - Fetching

    func fetch(with spacecraft: [Spacecraft], completion: @escaping ([AntennaStatus]?) -> Void) {
        self.spacecraft = spacecraft
        self.completion = completion

        let url = URL(string: "http://eyes.jpl.nasa.gov/dsn/data/dsn.xml?r=\(Date().timeIntervalSince1970)")!
        let task = DSNSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    // MARK: - Parser

    //swiftlint:disable:next line_length function_body_length
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == ParserKey.dish.rawValue,
            let name = attributeDict["name"],
            let updatedString = attributeDict["updated"],
            let azimuthAngle = attributeDict["azimuthAngle"],
            let elevationAngle = attributeDict["elevationAngle"],
            let windSpeed = attributeDict["windSpeed"] {

            activeStatus = AntennaStatus(name: name,
                                         windSpeed: windSpeed,
                                         azimuthAngle: azimuthAngle,
                                         elevationAngle: elevationAngle,
                                         signals: [],
                                         targets: [])

        } else if elementName == ParserKey.upSignal.rawValue || elementName == ParserKey.downSignal.rawValue,
            let typeString = attributeDict[ParserKey.signalType.rawValue],
            let type = Signal.SignalType(rawValue: typeString),
            let dataRate = attributeDict[ParserKey.dataRate.rawValue],
            let frequency = attributeDict[ParserKey.frequency.rawValue],
            let power = attributeDict[ParserKey.power.rawValue],
            let spacecraftName = attributeDict[ParserKey.spacecraft.rawValue] {

            let isUploading = elementName == ParserKey.upSignal.rawValue
            let signal = Signal(isUploading: isUploading,
                                type: type,
                                dataRate: dataRate,
                                frequency: frequency,
                                power: power,
                                spacecraftName: spacecraftName)

            activeStatus?.signals.append(signal)
        } else if elementName == ParserKey.target.rawValue,
            let spacecraftName = attributeDict[ParserKey.name.rawValue],
            spacecraftName != "TEST" && spacecraftName != "DSN" {
            var range: Double?
            if let upRangeString = attributeDict[ParserKey.uplegRange.rawValue],
                let downRangeString = attributeDict[ParserKey.downlegRange.rawValue],
                let upRange = Double(upRangeString),
                let downRange = Double(downRangeString) {
                range = (upRange + downRange) / 2
            }

            var rtlt: Double?
            if let rtltString = attributeDict[ParserKey.rtlt.rawValue] {
                rtlt = Double(rtltString)
            }

            let targetSpacecraft = spacecraft.filter({ $0.name.lowercased() == spacecraftName.lowercased() }).first

            activeStatus?.targets.append(Target(name: spacecraftName, range: range, rtlt: rtlt, spacecraft: targetSpacecraft))
        }
    }

    //swiftlint:disable:next line_length
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == ParserKey.dish.rawValue, let dishData = activeStatus {
            allAntennaStatuses.append(dishData)
            activeStatus = nil
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        self.completion?(allAntennaStatuses)
        allAntennaStatuses = []
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.completion?(nil)
    }
}
