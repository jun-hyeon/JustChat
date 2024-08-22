//
//  MemberEditModel.swift
//  JustChat
//
//  Created by 최준현 on 8/8/24.
//

import Foundation
struct MemberEditModel: Codable{
    var nickName, memberId: String
    var profileKey : String?
    
    enum CodingKeys: String, CodingKey {
        case memberId = "member_id"
        case nickName = "nick_name"
        case profileKey = "profile_key"
    }
}

struct MemberEditResponse: Codable{
    let success: Bool
    let message: String
}
