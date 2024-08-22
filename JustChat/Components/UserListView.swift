//
//  UserList.swift
//  JustChat
//
//  Created by 최준현 on 5/26/24.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var searchVM = SearchStore.shared
    @ObservedObject var loginStore: LoginStore
    @State private var searchText = ""
    @State private var userProfile = ""
    
    @State private var nickName = ""
    private let imageManager = ImageManager.shared
    
    private var userList : [MemberData]{
        if !searchText.isEmpty{
            return searchVM.searchList.filter{$0.nickName.contains(searchText)}
        }else{
            return searchVM.searchList
        }
    }
    var body: some View {
        
        NavigationStack{
            
            ScrollView{
                HStack{
                    Spacer()
                    VStack{
                        TextField("유저검색", text: $searchText)
                        Divider()
                    }
                    
                    Spacer()

                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                        
                            .frame(width: 26, height: 26)
                            .padding()
                            .foregroundStyle(.black)
                }
                .padding()
            
                HStack{
                    
                    AsyncImage(url: URL(string: userProfile)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                        
                    } placeholder: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                        
                    }.frame(width:48, height: 48)
                        .clipShape(Circle())
                        .overlay{
                            Circle().stroke(.white, lineWidth: 2)
                        }
                        .shadow(radius: 6)
                        .padding()
                        .onAppear{
                            Task{
                                try await userProfile = searchVM.fetchImage()
                            }
                        }
                    
                        Text(nickName)
                            .font(.title2)
                            .fontWeight(.semibold) 
                            .foregroundStyle(.black)
                        
                    Spacer()
                    
                    
                }//HStack
                .onAppear{
                    guard let key = loginStore.getCurrentUser().profileKey else{
                        return
                    }
                    userProfile = key
                    nickName = loginStore.getCurrentUser().nickName
                }
                
                ForEach(userList, id: \.self) { member in
                    
                    NavigationLink{
                        
                    }label: {
                        UserListItem(memberData: member)
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(.plain)
        }
        .onAppear{
            Task{
                searchVM.searchModel.keyword = ""
                await searchVM.fetchSearchUser()
                
            }
        }
    }
}

#Preview {
    UserListView(loginStore: LoginStore())
}
