//
//  UserList.swift
//  JustChat
//
//  Created by 최준현 on 5/26/24.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var searchVM = SearchViewModel.shared
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach(searchVM.searchList, id: \.self) { member in
            
                    NavigationLink{
                        
                    }label: {
                        UserListItem(memberData: member)
                    }
                    .buttonStyle(.plain)
                    
                }
                .padding()
            }
        }
        .onAppear{
            Task{
                await searchVM.fetchSearchUser()
            }
        }
        
    }
}

#Preview {
    UserListView()
}
