//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Errors
public enum TwitchyError: Error {

    // ========================
    // Networking
    public enum ParameterEncodingFailureReason {
        case missingURL
        case propertyListEncodingFailed(error: Error)
    }

    public enum ResponseCheckFailureReason {

        case missingError
        case missingValue
        case missingResponse

        case messageParsingFailed(payload: String)
    }

    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    case statusCode(Int, error: String, message: String)
    case APIMismatch(description: String)

    case responseCheck(reason: ResponseCheckFailureReason)

    // ========================
    // Parsing

    public enum ParsingFailureReason {

        case invalidHeader
        case missingStarting
        case missingEnding
        case conversionFailedAfterExtraction
        case noSuchKey
    }

    case playlistParsing(reason: ParsingFailureReason)

    case unknown
}
