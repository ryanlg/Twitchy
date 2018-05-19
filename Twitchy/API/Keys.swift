//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct Keys {

    public let auth: String
    public let clientID: String

    fileprivate static var sharedInstance = Keys()

    public static var shared: Keys {

        get {
            return sharedInstance
        }

        set (newSharedKeys) {
            sharedInstance = newSharedKeys
        }
    }
    
    public init() {
        
        self.auth = ""
        self.clientID = ""
    }

    public init(auth: String, clientID: String) {

        self.auth = auth
        self.clientID = clientID
    }
}
