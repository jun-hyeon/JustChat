//
//  ChatListModel.swift
//  JustChat
//
//  Created by 최준현 on 6/1/24.
//

import Foundation
// MARK: - ChatListModel
struct ChatListModel: Codable {
    var memberID: String
    var pageCurrent, perPage: Int

    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case pageCurrent = "page_current"
        case perPage = "per_page"
    }
}

// MARK: - ChatListResponse
struct ChatListResponse: Codable {
    let success: Bool
    let message: String
    let data: ResponseData
}

// MARK: - DataClass
struct ResponseData: Codable {
    let list: [ChatData]
    let totalCount: Int
    let totalPage: Int

    enum CodingKeys: String, CodingKey {
        case list = "list"
        case totalCount = "total_count"
        case totalPage = "total_page"
    }
}

// MARK: - List
struct ChatData: Codable, Hashable {
    let channerNo, channerName, memberID: String

    enum CodingKeys: String, CodingKey {
        case channerNo = "channer_no"
        case channerName = "channer_name"
        case memberID = "member_id"
    }
}

