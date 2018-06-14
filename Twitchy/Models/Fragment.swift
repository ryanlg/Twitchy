//
//  Fragment.swift
//  Twitchy
//
//  Created by Ryan Liang on 6/20/18.
//  Copyright © 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Represent the type of the fragment, whether it is an emoticon, or just pure text
public enum FragmentType {

    case Emoticon
    case Text
}

public struct Fragment: Decodable {
    
    public let type: FragmentType
    
    public let text: String
    public let emoticon: Emoticon?
    
    enum CodingKeys: String, CodingKey {
        
        case text = "text"
        case emoticon = "emoticon"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decode(String.self, forKey: .text)
        emoticon = try Emoticon(from: decoder)

        type = (emoticon == nil) ? .Text : .Emoticon
    }
}
