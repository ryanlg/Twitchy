//
// Created by Ryan Liang on 5/21/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public enum AuthType {

    case oauth2
}

public enum AuthResponseType: String {

    case code
}

public struct Scopes: OptionSet, CustomStringConvertible{

    public let rawValue: UInt32

    public init(rawValue: UInt32) {

        self.rawValue = rawValue
    }

    public static let channelCheckSubscription = Scopes(rawValue: 1 << 0)
    public static let channelCommercial = Scopes(rawValue: 1 << 1)
    public static let channelEditor = Scopes(rawValue: 1 << 2)
    public static let channelFeedEdit = Scopes(rawValue: 1 << 3)
    public static let channelFeedRead = Scopes(rawValue: 1 << 4)
    public static let channelRead = Scopes(rawValue: 1 << 5)
    public static let channelStream = Scopes(rawValue: 1 << 6)
    public static let channelSubscriptions = Scopes(rawValue: 1 << 7)
    public static let chatLogin = Scopes(rawValue: 1 << 8)
    public static let collectionsEdit = Scopes(rawValue: 1 << 9)
    public static let communitiesEdit = Scopes(rawValue: 1 << 10)
    public static let communitiesModerate = Scopes(rawValue: 1 << 11)
    public static let openid = Scopes(rawValue: 1 << 12)
    public static let userBlocksEdit = Scopes(rawValue: 1 << 13)
    public static let userBlocksRead = Scopes(rawValue: 1 << 14)
    public static let userFollowsEdit = Scopes(rawValue: 1 << 15)
    public static let userRead = Scopes(rawValue: 1 << 16)
    public static let userSubscriptions = Scopes(rawValue: 1 << 17)
    public static let viewingActivityRead = Scopes(rawValue: 1 << 18)

    public var description: String {

        var result = ""

        if self.contains(.channelCheckSubscription) {
            result += ScopeString.channelCheckSubscription.rawValue + "+"
        }
        if self.contains(.channelCommercial) {
            result += ScopeString.channelCommercial.rawValue + "+"
        }
        if self.contains(.channelEditor) {
            result += ScopeString.channelEditor.rawValue + "+"
        }
        if self.contains(.channelFeedEdit) {
            result += ScopeString.channelFeedEdit.rawValue + "+"
        }
        if self.contains(.channelFeedRead) {
            result += ScopeString.channelFeedRead.rawValue + "+"
        }
        if self.contains(.channelRead) {
            result += ScopeString.channelRead.rawValue + "+"
        }
        if self.contains(.channelStream) {
            result += ScopeString.channelStream.rawValue + "+"
        }
        if self.contains(.channelSubscriptions) {
            result += ScopeString.channelSubscriptions.rawValue + "+"
        }
        if self.contains(.chatLogin) {
            result += ScopeString.chatLogin.rawValue + "+"
        }
        if self.contains(.collectionsEdit) {
            result += ScopeString.collectionsEdit.rawValue + "+"
        }
        if self.contains(.communitiesEdit) {
            result += ScopeString.communitiesEdit.rawValue + "+"
        }
        if self.contains(.communitiesModerate) {
            result += ScopeString.communitiesModerate.rawValue + "+"
        }
        if self.contains(.openid) {
            result += ScopeString.openid.rawValue + "+"
        }
        if self.contains(.userBlocksEdit) {
            result += ScopeString.userBlocksEdit.rawValue + "+"
        }
        if self.contains(.userBlocksRead) {
            result += ScopeString.userBlocksRead.rawValue + "+"
        }
        if self.contains(.userFollowsEdit) {
            result += ScopeString.userFollowsEdit.rawValue + "+"
        }
        if self.contains(.userSubscriptions) {
            result += ScopeString.userSubscriptions.rawValue + "+"
        }
        if self.contains(.viewingActivityRead) {
            result += ScopeString.viewingActivityRead.rawValue + "+"
        }

        // remove trailing +
        if result.endIndex != result.startIndex {
            result = String(result[..<result.index(before: result.endIndex)])
        }

        return result
    }

    private enum ScopeString: String {

        case channelCheckSubscription = "channel_check_subscription"
        case channelCommercial = "channelCommercial "
        case channelEditor = "channel_editor"
        case channelFeedEdit = "channel_feed_edit"
        case channelFeedRead = "channel_feed_read"
        case channelRead = "channel_read"
        case channelStream = "channel_stream"
        case channelSubscriptions = "channel_subscriptions"
        case chatLogin = "chat_login"
        case collectionsEdit = "collections_edit"
        case communitiesEdit = "communities_edit"
        case communitiesModerate = "communities_moderate"
        case openid = "openid"
        case userBlocksEdit = "user_blocks_edit"
        case userBlocksRead = "user_blocks_read"
        case userFollowsEdit = "user_follows_edit"
        case userRead = "user_read"
        case userSubscriptions = "user_subscriptions"
        case viewingActivityRead = "viewing_activity_read"
    }
}

//public enum Scope: String, CustomStringConvertible {
//
//    case channelCheckSubscription = "channel_check_subscription"
//    case channelCommercial = "channelCommercial "
//    case channelEditor = "channel_editor"
//    case channelFeedEdit = "channel_feed_edit"
//    case channelFeedRead = "channel_feed_read"
//    case channelRead = "channel_read"
//    case channelStream = "channel_stream"
//    case channelSubscriptions = "channel_subscriptions"
//    case chatLogin = "chat_login"
//    case collectionsEdit = "collections_edit"
//    case communitiesEdit = "communities_edit"
//    case communitiesModerate = "communities_moderate"
//    case openid = "openid"
//    case userBlocksEdit = "user_blocks_edit"
//    case userBlocksRead = "user_blocks_read"
//    case userFollowsEdit = "user_follows_edit"
//    case userRead = "user_read"
//    case userSubscriptions = "user_subscriptions"
//    case viewingActivityRead = "viewing_activity_read"
//
//    public var description: String { return self.rawValue }
//}
