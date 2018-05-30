//
// Created by Ryan Liang on 5/31/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct Stream {

    public typealias Quality = [String: String]

    let broadcastID: Int

    var liveDuration: Int

    let qualities: [Quality]
}