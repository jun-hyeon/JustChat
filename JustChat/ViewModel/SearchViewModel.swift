//
//  SearchViewModel.swift
//  JustChat
//
//  Created by 최준현 on 6/5/24.
//

import Foundation
class SearchViewModel: ObservableObject{
    
    @Published var searchModel = SearchModel(keyword: "", pageCurrent: 1, perPage: 20)
    @Published var searchList : [MemberData] = []
    @Published var totalCount = 0
    
    
    static let shared = SearchViewModel()
    private let networkManager = NetworkManager.shared
    private let loginVM = LoginViewModel.shared
    
    //유저 검색
    func searchUser() async -> Result<SearchResponse, Error>{
        
        do{
            let params = await networkManager.convertToParameters(model: self.searchModel)
            print("유저검색 파라미터: \(String(describing: params))")
            
            let response = try await networkManager.request(method: .get, path: "member/list", params: params, of: SearchResponse.self)
            
            return .success(response)
            
        }catch{
            
            print("유저 검색에러!")
            print(error.localizedDescription)
            return .failure(error)
        }
    }
    
    //검색 리스트 데이터 넣기
    @MainActor
    func fetchSearchUser() async {
        
        let result = await searchUser()
        
        switch result{
            
        case .success(let response):
            
            if response.success{
                
                let currentUser = loginVM.currentUserInfo()
                print(currentUser.memberName)
                
                //검색리스트
                searchList = response.data.list.filter{$0.memberName != currentUser.memberName}.sorted(by: {$0.memberID < $1.memberID})
                
                //총 개수
                totalCount = response.data.totalCount
            }
            
        case .failure(let error):
            print(error)
        }
    }
}
