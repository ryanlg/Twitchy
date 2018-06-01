//
// Created by Ryan Liang on 5/31/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct Stream {

    let broadcastID: String

    var liveDuration: Int

    let transcodes: [Transcode]
}

public struct Transcode {

    public let quality: String

    public let url: URL

    public let bandwidth: Int
}