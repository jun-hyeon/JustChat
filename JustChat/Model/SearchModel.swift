//
//  SearchModel.swift
//  JustChat
//
//  Created by 최준현 on 6/1/24.
//

import Foundation


// MARK: - SearchModel
struct SearchModel: Codable {
    var keyword: String
    var pageCurrent, perPage: Int

    enum CodingKeys: String, CodingKey {
        case keyword
        case pageCurrent = "page_current"
        case perPage = "per_page"
        
        
    }
}


// MARK: - SearchModel
struct SearchResponse: Codable {
    
    let success: Bool
    let message: String
    let data: SearchResult
    
}

struct SearchResult : Codable{
    let list: [MemberData]
    let totalCount : Int
    
    enum CodingKeys: String, CodingKey{
        case list
        case totalCount = "total_count"
    }
}

// MARK: - Datum
struct MemberData: Codable, Hashable{
    let memberID, memberName, nickName: String
    let profileFile : String?
    

    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case memberName = "member_name"
        case nickName = "nick_name"
        case profileFile = "profile_file"
        
    }
}
