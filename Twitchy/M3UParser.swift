//
// Created by Ryan Liang on 5/31/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct M3UParser {

    enum _ParsingError: Error {

        case newLine
    }

    private let data: Data

    public init(data: Data) {

        self.data = data
    }

    public static func parseTwitchStreamPlaylist(fromData data: Data) throws -> Stream {

        try data.withUnsafeBufferBytes { (pointer: UnsafeBufferPointer<UInt8>) -> Stream in

            let sharp: UInt8 = 35
            let valueStart: [UInt8] = [61, 34] // "=\""
            let quote: UInt8 = 34 // just a quote
            let newline: UInt8 = 10
            let comma: UInt8 = 44

            let header: [UInt8] = [35, 69, 88, 84, 77, 51, 85] // "#EXTM3U"
            let BROADCAST_ID: [UInt8] = [66, 82, 79, 65, 68, 67, 65, 83, 84, 45, 73, 68] // "BROADCAST-ID"

            // ========== Header Validation =============
            var iterator = pointer.makeIterator()

            let headerCheck = try checkSequence(in: iterator, equalTo: header, barredBy: newline)
            guard headerCheck.0 else { throw TwitchyError.playlistParsing(reason: .invalidHeader) }
            var temp = headerCheck.1
            iterator = nextLine(in: headerCheck.1)

            // ============== Extract broadcast id and live duration ===========
            do {
                // starting with #
                let sharpCheck = checkNext(in: iterator, equalTo: sharp)
                guard sharpCheck.0 else { throw TwitchyError.playlistParsing(reason: .missingSharp) }
                iterator = sharpCheck.1

                var copied = iterator
                // broadcast
                let id = try checkAndExtract(in: copied, keys: [BROADCAST_ID], starting: valueStart, ending: quote, deliminator: comma, barredBy: newline)
                print(id)


            } catch {

                print(error)
            }


            return Stream(broadcastID: 1, liveDuration: 1, qualities: [])
        }
//
//        // #EXTM3U\n : 8 bytes
//        try validateStreamPlaylist(data)
//
//        let header: [UInt8] = [35, 69, 88, 84, 77, 51, 85] // "#EXTM3U"
//
//        let afterHeader = 8
//
//        // unicode
//        let sharp: UInt8 = 35
//        let newline: UInt8 = 10
//        let comma: UInt8 = 44
//        let valueStart: [UInt8] = [61, 34] // "=\""
//        let quote: UInt8 = 34 // just a quote
//        let BROADCAST_ID: [UInt8] = [66, 82, 79, 65, 68, 67, 65, 83, 84, 45, 73, 68] // "BROADCAST-ID"
//
//
//        // second line, get live duration
//        try data.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Stream in
//
//            var broadcastID: String?
//
//            var pointer = pointer
//
//            // @todo: get rid of this
//            pointer += afterHeader
//
//            // validate
//            let headerCheck = checkSequence(withStartingPointer: pointer, againstArray: header)
//            if !headerCheck.0 { throw TwitchyError.playlistParsing(reason: .invalidHeader) }
//
//
//            var cursor = afterHeader
//            var goToComma = false
//            while pointer.pointee != newline, cursor < data.count {
//
//                cursor += 1
//                pointer += 1
//
//                if goToComma{
//                    if pointer.pointee != comma {
//                        continue
//
//                    } else {
//                        goToComma = false
//                        pointer += 1 // skip the comma
//                    }
//                }
//
//                do {
//                    let result = try checkAndExtract(withStartingPointer: pointer, key: BROADCAST_ID, starting: valueStart, ending: quote)
//
//                    let data = Data(bytes: result)
//                    guard let string = String(data: data, encoding: .utf8) else {
//
//                        throw TwitchyError.playlistParsing(reason: .conversionFailedAfterExtraction)
//                    }
//
//                    broadcastID = string
//                } catch TwitchyError.playlistParsing(reason: .noSuchKey) {
//                    goToComma = true
//                    continue
//                }
//            }
//
//            // @todo
//            return Stream(broadcastID: 1, liveDuration: 1, qualities: [])
//        }

        return Stream(broadcastID: 1, liveDuration: 1, qualities: [])
    }

    private func validateStreamPlaylist(_ data: Data) throws {

        let headerSize = 7
        let header = Data(bytes: [35, 69, 88, 84, 77, 51, 85]) // "#EXTM3U"

        guard data.subdata(in: 0..<headerSize) == header else { throw TwitchyError.playlistParsing(reason: .invalidHeader)}
    }

    private static func checkAndExtract<Element>(in iterator: UnsafeBufferPointerIterator<Element>,
                                                 keys: [[Element]],
                                                 starting: [Element],
                                                 ending: Element,
                                                 deliminator: Element,
                                                 barredBy bar: Element) throws -> [[Element]]
                                                 where Element: Comparable{

        let original = iterator
        var list = [[Element]]()
        for key in keys {

            do {

                var iterator = original
                while true {

                    let keyCheck = try checkSequence(in: iterator, equalTo: key, barredBy: bar)
                    if keyCheck.0 {

                        // check if starting deliminator is present
                        let startingCheck = try checkSequence(in: keyCheck.1, equalTo: key, barredBy: bar)
                        if startingCheck.0 {

                            let result = try extract(in: startingCheck.1, until: ending)
                            list.append(result.0)

                        } else {

                            throw TwitchyError.playlistParsing(reason: .missingStarting)
                        }
                    } else {

                        iterator = try iterateBarred(iterator, until: deliminator, barredBy: bar)
                    }
                }
            } catch _ParsingError.newLine {

                continue
            }
        }

        if list.count == keys.count { return list }
        throw TwitchyError.playlistParsing(reason: .noSuchKey)
    }

    private static func checkSequence<Element>(in iterator: UnsafeBufferPointerIterator<Element>,
                                               equalTo against: [Element],
                                               barredBy bar: Element) throws -> (Bool, UnsafeBufferPointerIterator<Element>)
                                        where Element: Comparable {

                                            
        var pointerIterator = iterator
        var againstIterator = against.makeIterator()

        var success = true
        while let pointee = pointerIterator.next(), let againstee = againstIterator.next() {
            
            print(UnicodeScalar(pointee as! UInt8))

            if pointee == bar { throw _ParsingError.newLine }

            if pointee != againstee { success = false; break }
        }

        return (success, pointerIterator)
    }

    private static func extract<Element>(in iterator: UnsafeBufferPointerIterator<Element>,
                                         until value: Element) throws -> ([Element], UnsafeBufferPointerIterator<Element>)
                                         where Element: Comparable {

        var iterator = iterator
        var list = [Element]()
        while let pointee = iterator.next() {
            if pointee != value {
                list.append(pointee)
            } else {
                return (list, iterator)
            }
        }

        // reached add but no ending deliminator
        throw TwitchyError.playlistParsing(reason: .missingEnding)
    }

    private static func iterate<Element>(_ iterator: UnsafeBufferPointerIterator<Element>,
                                         until: Element) -> UnsafeBufferPointerIterator<Element>
                                         where Element: Comparable{

        var iterator = iterator
        while let pointee = iterator.next() {

            if pointee == until { return iterator }
        }

        // reaches the end
        return iterator
    }

    private static func iterateBarred<Element>(_ iterator: UnsafeBufferPointerIterator<Element>,
                                               until: Element,
                                               barredBy stop: Element) throws -> UnsafeBufferPointerIterator<Element>
            where Element: Comparable{

        var iterator = iterator
        while let pointee = iterator.next() {

            if pointee == stop { throw _ParsingError.newLine }
            if pointee == until { return iterator }
            
            print(UnicodeScalar(pointee as! UInt8))
        }

        // reaches the end
        return iterator
    }

    private static func nextLine(in iterator: UnsafeBufferPointerIterator<UInt8>) -> UnsafeBufferPointerIterator<UInt8> {

        let newline: UInt8 = 10
        return iterate(iterator, until: newline)
    }

    private static func nextComma(in iterator: UnsafeBufferPointerIterator<UInt8>) throws -> UnsafeBufferPointerIterator<UInt8> {

        let comma: UInt8 = 44
        let newline: UInt8 = 10
        return try iterateBarred(iterator, until: comma, barredBy: newline)
    }

    private static func checkNext<Element>(in iterator: UnsafeBufferPointerIterator<Element>,
                                           equalTo against: Element) -> (Bool, UnsafeBufferPointerIterator<Element>)
                                            where Element: Comparable {

        var iterator = iterator
        return (iterator.next() == against, iterator)
    }
}

extension Data {

    public func withUnsafeBufferBytes<ResultType, ContentType>(_ body: (UnsafeBufferPointer<ContentType>) throws -> ResultType) rethrows -> ResultType {
        return try self.withUnsafeBytes { try body(UnsafeBufferPointer(start: $0, count: self.count)) }
    }
}
