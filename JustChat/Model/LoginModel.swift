//
//  LoginModel.swift
//  JustChat
//
//  Created by 최준현 on 5/17/24.
//

import Foundation

struct LoginModel: Codable {
    var memberID, memberPwd: String

    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case memberPwd = "member_pwd"
    }
}

// MARK: - LoginResponseModel
struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let data : LoginData?
}

// MARK: - DataClasse
struct LoginData: Codable {
    let memberID, memberName, nickName, regDate: String
    let profileFile : String?

    enum CodingKeys: String, CodingKey {
        case memberID = "member_id"
        case memberName = "member_name"
        case nickName = "nick_name"
        case regDate = "reg_date"
        case profileFile = "profile_file"
    }
    
}

