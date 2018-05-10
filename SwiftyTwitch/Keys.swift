//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public struct Keys {

    let auth: String
    let clientID: String

    static var sharedInstance = Keys()

    static var shared: Keys {

        get {
            return sharedInstance
        }

        set (newSharedKeys) {
            sharedInstance = newSharedKeys
        }
    }
    
    init() {
        
        self.auth = ""
        self.clientID = ""
    }

    init(auth: String, clientID: String) {

        self.auth = auth
        self.clientID = clientID
    }
}
