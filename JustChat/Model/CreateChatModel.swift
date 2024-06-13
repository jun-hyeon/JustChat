//
//  CreateChatModel.swift
//  JustChat
//
//  Created by 최준현 on 6/1/24.
//

import Foundation
// MARK: - CreateChatModel
struct CreateChatModel: Codable {
    var memberID, channerName: String
    var connectKey: Int?
    var inviteMember: [String]

    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case channerName = "channer_name"
        case connectKey = "connect_key"
        case inviteMember = "invite_member"
    }
}

// MARK: - CreateChatResponseModel
struct CreateChatResponse: Codable {
    let success: Bool
    let message: String
}

