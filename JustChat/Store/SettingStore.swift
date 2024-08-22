//
//  SettingStore.swift
//  JustChat
//
//  Created by 최준현 on 8/7/24.
//

import Foundation

class SettingStore: ObservableObject{
    
    private let userManager = UserManager.shared
    
    @Published var nickName = ""
    @Published var profileUrl = ""
    
    
    
    
}
