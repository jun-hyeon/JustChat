//
//  UserManager.swift
//  JustChat
//
//  Created by 최준현 on 6/15/24.
//

import Foundation

class UserManager{
    static let shared = UserManager()
    
    private let userDefaults = UserDefaults.standard
    
    func getCurrentUser()->LoginData{
        return LoginData(
            memberID: userDefaults.string(forKey: "memberId") ?? "",
            memberName: userDefaults.string(forKey: "memberName") ?? "",
            nickName: userDefaults.string(forKey: "nickName") ?? "",
            regDate: userDefaults.string(forKey: "regDate") ?? "",
            profileFile: userDefaults.string(forKey: "profileFile") ?? ""
        )
    }
     
    func storeUser(loginData: LoginData){
        userDefaults.setValue(loginData.memberID, forKey: "memberId")
        userDefaults.setValue(loginData.nickName, forKey: "nickName")
        userDefaults.setValue(loginData.memberName, forKey: "memberName")
        userDefaults.setValue(loginData.regDate, forKey: "regDate")
        userDefaults.setValue(loginData.profileFile, forKey: "profileFile")
    }
    
    func removeUser(){
        userDefaults.setValue("", forKey: "memberId")
        userDefaults.setValue("", forKey: "nickName")
        userDefaults.setValue("", forKey: "memberName")
        userDefaults.setValue("", forKey: "regDate")
        userDefaults.setValue("", forKey: "profileFile")
    }
}
