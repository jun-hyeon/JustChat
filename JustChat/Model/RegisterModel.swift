//
//  RegisterModel.swift
//  JustChat
//
//  Created by 최준현 on 5/16/24.
//

import Foundation
struct RegisterModel: Codable {
    
    var memberID, memberPwd, memberName, nickName: String
    var profileFile : String?

    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case memberPwd = "member_pwd"
        case memberName = "member_name"
        case nickName = "nick_name"
        case profileFile = "profile_file"
    }
}

struct RegisterResponse: Decodable {
    let success: Bool
    let message: String
}

// MARK: - FileDownloadResponse
struct FileDownloadResponse: Decodable {
    let success: Bool
    let message: String
    let url: String
}

struct FileDownloadModel: Encodable{
    let key : String
}

// MARK: - FileUploadResponse
struct FileUploadResponse: Decodable {
    let success: Bool
    let message, key: String
}

