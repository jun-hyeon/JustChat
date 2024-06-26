//
//  UserList.swift
//  JustChat
//
//  Created by 최준현 on 5/26/24.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var searchVM = SearchViewModel.shared
    @State private var user = UserManager.shared.getCurrentUser()
    var body: some View {
        
        NavigationStack{
            
            ScrollView{
            
                HStack{
                    
                    AsyncImage(url: URL(string:user.profileFile ?? "")) { image in
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
                    
                    
                    VStack(alignment: .leading){
                        Text(user.nickName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        
                    }
                    
                    Spacer()
                    
                    Button{
                        //추후 추가할지 안할지 논의
                        
                    }label:{
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            
                            .frame(width: 26, height: 26)
                            .padding()
                            .foregroundStyle(.black)
                    }
                }//HStack
                
                ForEach(searchVM.searchList, id: \.self) { member in
            
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
    UserListView()
}
