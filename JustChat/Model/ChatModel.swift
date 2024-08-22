//
//  ChatSendModel.swift
//  JustChat
//
//  Created by 최준현 on 6/15/24.
//

import Foundation
struct ChatModel: Codable, Hashable{
    var memberId, message: String
    
    
    enum CodingKeys: String, CodingKey{
        case memberId = "member_id"
        case message
    }
}


