//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

// This struct represent a Game object, with modification for a more intuitive interface from Twitch's JSON.
public struct Game {

    let id: Int
    let name: String
    let popularity: Int
    let giantbombId: Int

    let locale: Locale
    let localizedName: String

    let viewers: Int
    let channels: Int

    let box: BoxArt

    // Omitted "logo" and "_links" field because it is empty for most games
}

/// This struct encapsulates four addresses with different size of the game's art
public struct BoxArt{

    let large: String // 272x380
    let medium: String // 136x190
    let small: String // 52x72
    let template: String

    func with(width: Int, height: Int) -> String {

        let index =  template.index(template.endIndex, offsetBy: -20)
        let segment = template[..<index]
        return "\(segment)-\(width)x\(height).jpg"
    }
}

extension Game: Decodable {

    private enum CodingKeys: String, CodingKey {

        case game
        case viewers
        case channels
    }

    private enum GameCodingKeys: String, CodingKey {

        case name
        case popularity
        case id = "_id"
        case giantbombId = "giantbomb_id"
        case localizedName = "localized_name"
        case locale = "locale"
        case boxArt = "box"
    }

    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        viewers = try values.decode(Int.self, forKey: .viewers)
        channels = try values.decode(Int.self, forKey: .channels)

        let game = try values.nestedContainer(keyedBy: GameCodingKeys.self, forKey: .game)
        name = try game.decode(String.self, forKey: .name)
        popularity = try game.decode(Int.self, forKey: .popularity)
        id = try game.decode(Int.self, forKey: .id)
        giantbombId = try game.decode(Int.self, forKey: .giantbombId)
        localizedName = try game.decode(String.self, forKey: .localizedName)
        locale = try Locale(identifier: game.decode(String.self, forKey: .locale))

        box = try game.decode(BoxArt.self, forKey: .boxArt)
    }
}

extension BoxArt: Decodable {

    enum BoxArtCodingKeys: String, CodingKey {

        case large
        case medium
        case small
        case template
    }

    public init(from decoder: Decoder) throws {

        let boxArt = try decoder.container(keyedBy: BoxArtCodingKeys.self)

        large = try boxArt.decode(String.self, forKey: .large)
        medium = try boxArt.decode(String.self, forKey: .medium)
        small = try boxArt.decode(String.self, forKey: .small)
        template = try boxArt.decode(String.self, forKey: .template)
    }
}
