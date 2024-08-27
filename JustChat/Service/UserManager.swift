//
//  UserManager.swift
//  JustChat
//
//  Created by 최준현 on 6/15/24.
//

import Foundation
import SwiftUI

enum UserError: Error{
    case profileError
}

class UserManager{
    static let shared = UserManager()
    
    private let userDefaults = UserDefaults.standard
    private let keyManager = KeyChainManager.shared
    private let accessToken = "access_token"
    private let refreshToken = "refresh_token"
    private let profile = "profile"
    
    func getCurrentUser()->LoginData{
        return LoginData(
            memberID: userDefaults.string(forKey: "memberId") ?? "",
            memberName: userDefaults.string(forKey: "memberName") ?? "",
            nickName: userDefaults.string(forKey: "nickName") ?? "",
            regDate: userDefaults.string(forKey: "regDate") ?? "",
            refreshToken: keyManager.read(forAccount: refreshToken) ?? "",
            accessToken: keyManager.read(forAccount: accessToken) ?? "",
            profileKey: userDefaults.string(forKey: "profileFile") ?? ""
        )
    }
    
     
    func setUser(loginData: LoginData){
        userDefaults.setValue(loginData.memberID, forKey: "memberId")
        userDefaults.setValue(loginData.nickName, forKey: "nickName")
        userDefaults.setValue(loginData.memberName, forKey: "memberName")
        userDefaults.setValue(loginData.regDate, forKey: "regDate")
        userDefaults.setValue(loginData.profileKey, forKey: "profileFile")
        
        
        if (keyManager.read(forAccount: accessToken) != nil){
            print("액세스 토큰이 존재하므로 삭제합니다.")
            guard keyManager.delete(forAccount: accessToken) else{
                print("액세스 토큰 삭제 실패")
                return
            }
            guard keyManager.storeData(token: loginData.accessToken, forAccount: accessToken)else{
                print("액세스 토큰 저장 실패")
                return
            }
            print("액세스 토큰 저장 성공")
            print("액세스 토큰 \(keyManager.read(forAccount: accessToken) ?? "")")
        }else{
            guard keyManager.storeData(token: loginData.accessToken, forAccount: accessToken) else{
                print("토큰 저장 실패")
                return
            }
            print("토큰 저장 성공")
        }
        
        if (keyManager.read(forAccount: refreshToken) != nil){
            print("리프레시 토큰이 존재하므로 삭제합니다.")
            guard keyManager.delete(forAccount: refreshToken) else{
                print("리프레시 토큰 삭제 실패")
                return
            }
            guard keyManager.storeData(token: loginData.refreshToken, forAccount: refreshToken)else{
                print("리프레시 토큰 저장 실패")
                return
            }
            print("리프레시 토큰 저장 성공")
            print("리프레시 토큰 \(keyManager.read(forAccount: refreshToken) ?? "")")
        }else{
           guard keyManager.storeData(token: loginData.refreshToken, forAccount: refreshToken) else{
                print("토큰 저장 실패")
                return
            }
            print("토큰 저장 성공")
        }
        
        
    }
    
    
    func updateUser(nickname: String, profileFile: String){
        userDefaults.setValue(nickname, forKey: "nickName")
        userDefaults.setValue(profileFile, forKey: "profileFile")
    }
    
    func removeUser(){
        userDefaults.setValue("", forKey: "memberId")
        userDefaults.setValue("", forKey: "nickName")
        userDefaults.setValue("", forKey: "memberName")
        userDefaults.setValue("", forKey: "regDate")
        userDefaults.setValue("", forKey: "profileFile")
        if keyManager.delete(forAccount: accessToken){
            print("삭제 성공")
        }
        if keyManager.delete(forAccount: refreshToken){
            print("삭제 성공")
        }
    }
    
    func saveProfile(image: UIImage){
        let data = image.jpegData(compressionQuality: 0.5)
        userDefaults.setValue(data, forKey: profile)
    }
    
    func getProfile() throws -> Data{
        guard let data = userDefaults.data(forKey: profile)else{
            throw UserError.profileError
        }
        return data
    }
}
