//
//  ChatListView.swift
//  JustChat
//
//  Created by 최준현 on 5/12/24.
//

import SwiftUI

struct ChatListView: View {
    
    @StateObject private var chatListVM = ChatListViewModel.shared
    @ObservedObject var loginVM : LoginViewModel
    
    @State private var isShow = false
    
    var url = ""
    var body: some View {
        
        NavigationStack{
            
            ZStack(alignment: .bottomTrailing){
                
                ScrollView{
                   
                    ForEach(chatListVM.chatList, id: \.self){ chatData in
                        NavigationLink{
                            ChattingView(chatData: chatData)
                        }label:{
                            ChatListItem(chatData: chatData)
                        }
                        .buttonStyle(.plain)
                    
                    }
                    .listRowSeparator(.hidden)
                    
                }//List
                .listStyle(.plain)
                
                //채팅 생성버튼
                NavigationLink{
                    ChatCreateView()
                }label:{
                    Image(systemName: "plus")
                        .font(.title.weight(.bold))
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
                .padding()
            }//ZStack
        }//NavigatioNStack
        .onAppear{
            chatListVM.chatListModel.memberID =  UserManager.shared.getCurrentUser().memberID
            print("nae,",UserManager.shared.getCurrentUser().memberID)
            Task{
                 await chatListVM.fetchList()
            }
        }
      

    }
}

#Preview {
    ChatListView(loginVM: LoginViewModel())
}
