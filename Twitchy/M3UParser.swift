//
// Created by Ryan Liang on 5/31/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct M3UParser {

    private let data: Data

    public init(data: Data) {

        self.data = data
    }

    public func parseTwitchStreamPlaylist(fromData data: Data) throws -> Stream {

        // #EXTM3U\n : 8 bytes
        try validateStreamPlaylist(data)

        let header: [UInt8] = [35, 69, 88, 84, 77, 51, 85] // "#EXTM3U"

        let afterHeader = 8

        // unicode
        let sharp: UInt8 = 35
        let newline: UInt8 = 10
        let comma: UInt8 = 44
        let valueStart: [UInt8] = [61, 34] // "=\""
        let quote: UInt8 = 34 // just a quote
        let BROADCAST_ID: [UInt8] = [66, 82, 79, 65, 68, 67, 65, 83, 84, 45, 73, 68] // "BROADCAST-ID"


        // second line, get live duration
        try data.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Stream in

            var broadcastID: String?

            var pointer = pointer

            // @todo: get rid of this
            pointer += afterHeader

            // validate
            let headerCheck = checkSequence(withStartingPointer: pointer, againstArray: header)
            if !headerCheck.0 { throw TwitchyError.playlistParsing(reason: .invalidHeader) }


            var cursor = afterHeader
            var goToComma = false
            while pointer.pointee != newline, cursor < data.count {

                cursor += 1
                pointer += 1
                
                if goToComma{
                    if pointer.pointee != comma {
                        continue
                        
                    } else {
                        goToComma = false
                        pointer += 1 // skip the comma
                    }
                }

                do {
                    let result = try checkAndExtract(withStartingPointer: pointer, key: BROADCAST_ID, starting: valueStart, ending: quote)

                    let data = Data(bytes: result)
                    guard let string = String(data: data, encoding: .utf8) else {

                        throw TwitchyError.playlistParsing(reason: .conversionFailedAfterExtraction)
                    }

                    broadcastID = string
                } catch TwitchyError.playlistParsing(reason: .noSuchKey) {
                    goToComma = true
                    continue
                }
            }

            // @todo
            return Stream(broadcastID: 1, liveDuration: 1, qualities: [])
        }

        return Stream(broadcastID: 1, liveDuration: 1, qualities: [])
    }

    private func validateStreamPlaylist(_ data: Data) throws {

        let headerSize = 7
        let header = Data(bytes: [35, 69, 88, 84, 77, 51, 85]) // "#EXTM3U"

        guard data.subdata(in: 0..<headerSize) == header else { throw TwitchyError.playlistParsing(reason: .invalidHeader)}
    }

    private func checkAndExtract<Element> (withStartingPointer pointer: UnsafePointer<Element>,
                                                  key: [Element],
                                                  starting: [Element],
                                                  ending: Element,
                                                  noLongerThan: Int = 20) throws -> [Element]
                                                  where Element: Comparable{
        let bound = UnsafeBufferPointer(start: pointer, count: 10)


        let keyCheck = checkSequence(withStartingPointer: pointer, againstArray: key)
        if keyCheck.0 {

            // check if starting deliminator is present
            let startingCheck = checkSequence(withStartingPointer: keyCheck.1, againstArray: starting)
            if startingCheck.0 {

                let result = try extract(fromPointer: startingCheck.1, untilValue: ending)

                return result
            } else {
                
                throw TwitchyError.playlistParsing(reason: .missingStarting)
            }
        } else {

            throw TwitchyError.playlistParsing(reason: .noSuchKey)
        }
    }

    private func checkSequence<Element>(withStartingPointer pointer: UnsafePointer<Element>,
                                               againstArray against: [Element]) -> (Bool, UnsafePointer<Element>)
                                            where Element: Comparable {
        var success = true
        var pointer = pointer
        for element in against {

            if element != pointer.pointee { success = false; break } else { pointer += 1 }
        }

        return (success, pointer)
    }

    private func extract<Element>(fromPointer pointer: UnsafePointer<Element>,
                                         untilValue value: Element,
                                         noLongerThan: Int = 20) throws -> [Element]
                                         where Element: Comparable{

        var pointer = pointer
        var iteration = 0
        var list = [Element]()
        while pointer.pointee != value {

            // overflow prevention
            if iteration > noLongerThan { throw TwitchyError.playlistParsing(reason: .missingEnding) }

            list.append(pointer.pointee)

            iteration += 1
            pointer += 1
        }

        return list
    }

    private func nextLine<Element>(fromPointer pointer: UnsafePointer<Element>) {

    }

    private func checkBounds<Element>(atPointer pointer: UnsafePointer<Element>) -> Bool {

    }
}

extension Data {

    public func pointer<Element>(from: Int, length: Int) -> Element {

        return self.subdata(in: from..<from+length).withUnsafeBytes { $0.pointee }
    }
}
