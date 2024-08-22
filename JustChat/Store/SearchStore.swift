//
//  SearchViewModel.swift
//  JustChat
//
//  Created by 최준현 on 6/5/24.
//

import Foundation

enum ProfileKeyError: Error{
    case isNil
}

class SearchStore: ObservableObject{
    
    @Published var searchModel = SearchModel(keyword: "", pageCurrent: 1, perPage: 20)
    @Published var searchList : [MemberData] = []
    @Published var totalCount = 0
    
    
    static let shared = SearchStore()
    private let networkManager = NetworkManager.shared
    private let loginVM = LoginStore.shared
    private let userManager = UserManager.shared
    private let imageManager = ImageManager.shared
    
    //유저 검색
    private func searchUser() async -> Result<SearchResponse, Error>{
        
        do{
            let params = await networkManager.convertToParameters(model: self.searchModel)
            print("유저검색 파라미터: \(String(describing: params))")
            
            let response = try await networkManager.request(method: .get,tokenRequired: .yes, path: "member/list", params: params, of: SearchResponse.self)
            
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
                
                let currentUser = userManager.getCurrentUser()
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
    
    
    func fetchImage() async throws -> String{
        guard let profileKey = userManager.getCurrentUser().profileKey else{
            throw ProfileKeyError.isNil
        }
        let result = await imageManager.keyToUrl(key: profileKey)
        return result
    }
}
