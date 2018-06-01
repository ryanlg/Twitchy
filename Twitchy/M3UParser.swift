//
// Created by Ryan Liang on 5/31/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// A very bad implementation of a M3U parser
public struct M3UParser {

    /// A parse the Twitch stream playlist
    public static func parseTwitchStreamPlaylist(fromData data: Data) throws -> Stream {

        // unicode
        let sharp: UInt8 = 35
        let newline: UInt8 = 10
        let comma: UInt8 = 44
        let equalQuoteStart: [UInt8] = [61, 34] // "=\""
        let equalStart: [UInt8] = [61] // "="
        let quote: UInt8 = 34 // just a quote

        let header: [UInt8] = [35, 69, 88, 84, 77, 51, 85] // "#EXTM3U"
        let BROADCAST_ID: [UInt8] = [66, 82, 79, 65, 68, 67, 65, 83, 84, 45, 73, 68] // "BROADCAST-ID"
        let STREAM_TIME: [UInt8] = [83, 84, 82, 69, 65, 77, 45, 84, 73, 77, 69] //" STREAM-TIME"

        let videoHeader: [UInt8] = [35, 69, 88, 84, 45, 88, 45, 77, 69, 68, 73, 65]
        let bandwidth: [UInt8] = [66, 65, 78, 68, 87, 73, 68, 84, 72]
        let video: [UInt8] = [86, 73, 68, 69, 79]

        // second line, get live duration
        return try data.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Stream in

            var pointer = UnsafeBoundedPointer(base: pointer, count: data.count)

            // ============= HEADER VALIDATION ===========
            let headerCheck = try checkSequence(in: pointer, against: header, barrier: newline)
            if !headerCheck.0 { throw TwitchyError.playlistParsing(reason: .invalidHeader) }
            pointer = try advance(pointer: headerCheck.1, after: newline, barrier: nil) // next line

            // ============= Second Line ================
            pointer = try advance(pointer: pointer, after: sharp, barrier: newline)

            // ============= Stream time ================
            let streamTimeResult = try checkAndExtract(in: pointer,
                                                       key:STREAM_TIME,
                                                       starting: equalQuoteStart,
                                                       ending: quote,
                                                       deliminator: comma,
                                                       barrier: newline)

            let timeData = Data(bytes: streamTimeResult)
            guard let timeString = String(data: timeData, encoding: .utf8),
                  let floatTime = Float(timeString) else {

                throw TwitchyError.playlistParsing(reason: .conversionFailedAfterExtraction)
            }

            // ============= id ================
            let id = try checkAndExtract(in: pointer,
                    key:BROADCAST_ID,
                    starting: equalQuoteStart,
                    ending: quote,
                    deliminator: comma,
                    barrier: newline)

            let idData = Data(bytes: id)
            guard let idString = String(data: idData, encoding: .utf8) else {

                throw TwitchyError.playlistParsing(reason: .conversionFailedAfterExtraction)
            }

            var list = [Transcode]()
            pointer = try advance(pointer: pointer, after: newline, barrier: nil) // nextline
            while true {

                do {

                    let result = try checkSequence(in: pointer, against: videoHeader, barrier: newline)
                    if result.0 {
                        pointer = try advance(pointer: pointer, after: newline, barrier: nil) //next line

                        let bandwidth = try checkAndExtract(in: pointer, key: bandwidth, starting: equalStart, ending: comma, deliminator: comma, barrier: newline)
                        let bwData = Data(bytes: bandwidth)
                        guard let bandwidthString = String(data: bwData, encoding: .utf8),
                              let bwInt = Int(bandwidthString) else {
                            throw TwitchyError.playlistParsing(reason: .conversionFailedAfterExtraction)
                        }

                        let video = try checkAndExtract(in: pointer, key: video, starting: equalQuoteStart, ending: quote, deliminator: comma, barrier: newline)
                        let vData = Data(bytes: video)
                        guard let vString = String(data: vData, encoding: .utf8) else {
                            throw TwitchyError.playlistParsing(reason: .conversionFailedAfterExtraction)
                        }

                        pointer = try advance(pointer: pointer, after: newline, barrier: nil) //next line

                        let url = try extract(from: pointer, until: newline, barrier: nil)
                        let urlData = Data(bytes: url)
                        guard let urlString = String(data: urlData, encoding: .utf8),
                              let URL = URL(string: urlString) else {
                            throw TwitchyError.playlistParsing(reason: .conversionFailedAfterExtraction)
                        }

                        // @todo: make extract return pointer so that we dont have to traverse everything again
                        list.append(Transcode(quality: vString, url: URL, bandwidth: bwInt))
                        pointer = try advance(pointer: pointer, after: newline, barrier: nil)
                    }
                } catch UnsafeBoundedPointerError.outOfBounds {
                    break
                }
            }

            // sort by highest quality to lowest
            list.sort {
                lhs, rhs  in
                return lhs.bandwidth > rhs.bandwidth
            }
            return Stream(broadcastID: idString, liveDuration: Int(floatTime), transcodes: list)
        }
    }

    /// Check if key is present from the pointer with the value wrapped by starting and ending
    ///
    /// If the key is not present at the pointer, it will try to jump to the next deliminator,
    /// until it reaches the barrier
    ///
    /// For example: BROADCAST-ID="12313123132", BROADCAST-ID is the key, =" is starting, " is the ending
    private static func checkAndExtract<Element> (in pointer: UnsafeBoundedPointer<Element>,
                                           key: [Element],
                                           starting: [Element],
                                           ending: Element,
                                           deliminator: Element,
                                           barrier: Element) throws -> [Element] where Element: Comparable{

        do {
            let keyCheck = try checkSequence(in: pointer, against: key, barrier: barrier)
            if keyCheck.0 {

                // check if starting deliminator is present
                let startingCheck = try checkSequence(in: keyCheck.1, against: starting, barrier: barrier)
                if startingCheck.0 {

                    let result = try extract(from: startingCheck.1, until: ending, barrier: barrier)

                    return result
                } else {

                    throw TwitchyError.playlistParsing(reason: .missingStarting)
                }
            } else {

                // find next deliminator
                let next = try advance(pointer: pointer, after: deliminator, barrier: barrier)

                // recursive, not a good idea I know
                return try checkAndExtract(in: next,
                                           key: key,
                                           starting: starting,
                                           ending: ending,
                                           deliminator: deliminator,
                                           barrier: barrier)
            }
        } catch {

            // any error, no such key present
            throw TwitchyError.playlistParsing(reason: .noSuchKey("\(key)"))
        }
    }

    /// Check the if the next few characters is the same as the elements in against
    /// Stops immediately if one doesn't match, or throws error when hitting the barrier
    ///
    /// Return: a tuple with the a boolean indicating whether the operation is successful,
    /// and a pointer pointing to where the method has gone through
    private static func checkSequence<Element>(in pointer: UnsafeBoundedPointer<Element>,
                                               against: [Element],
                                               barrier: Element) throws -> (Bool, UnsafeBoundedPointer<Element>)
                                               where Element: Comparable {
        var success = true
        var pointer = pointer
        for element in against {
            if element == barrier { throw  _ParsingError.barrierHit }
            if element != pointer.pointee { success = false; break } else { pointer = try pointer.advanced(by: 1) }
        }

        return (success, pointer)
    }

    /// Extract value from the pointer, until it hit the until value, or it throws error when hitting the barrier
    private static func extract<Element>(from pointer: UnsafeBoundedPointer<Element>,
                                         until value: Element,
                                         barrier: Element?) throws -> [Element] where Element: Comparable {

        var pointer = pointer
        var iteration = 0
        var list = [Element]()
        while pointer.pointee != value {

            if let barrier = barrier, pointer.pointee == barrier { throw _ParsingError.barrierHit }

            list.append(pointer.pointee)

            iteration += 1
            pointer = try pointer.advanced(by: 1)
        }

        return list
    }

    /// Advance the pointer until it hits the after value, or throws error when hitting the barrier
    private static func advance<Element>(pointer: UnsafeBoundedPointer<Element>,
                                  after: Element,
                                  barrier: Element?) throws -> UnsafeBoundedPointer<Element> where Element: Comparable {

        var pointer = pointer
        while true {
            if pointer.pointee == barrier { throw _ParsingError.barrierHit }
            if pointer.pointee == after {
                pointer = try pointer.advanced(by: 1)

                if let barrier = barrier, pointer.pointee == barrier { throw _ParsingError.barrierHit }
                return pointer
            }
            pointer = try pointer.advanced(by: 1)
        }
    }
}

internal enum _ParsingError: Error {

    case barrierHit
}

/// A pointer that will throw error when advanced out of bounds
internal struct UnsafeBoundedPointer<Element>{

    private var _pointer: UnsafePointer<Element>

    public var pointee: Element {
        get {
            return self._pointer.pointee
        }
    }

    // size
    public let count: Int

    private var cursor: Int

    public mutating func advanced(by distance: Int) throws -> UnsafeBoundedPointer<Element> {

        if self.cursor + distance >= count { throw UnsafeBoundedPointerError.outOfBounds }

        self.cursor += distance; self._pointer += distance

        return self
    }

    public init(base: UnsafePointer<Element>, count: Int) {

        self._pointer = base
        self.count = count
        self.cursor = 0
    }
}

internal enum UnsafeBoundedPointerError: Error {
    case outOfBounds
}
