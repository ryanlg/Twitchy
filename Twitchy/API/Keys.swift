//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Represent Twitch keys related data
public struct Keys {

    /// User Auth Token
    public let auth: String?

    /// Client ID
    /// This has to be non-null, since all API endpoints require this
    public let clientID: String

    /// Singleton
    private static var sharedInstance = Keys()

    /// Shared
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
