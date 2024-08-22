//
//  ChatListView.swift
//  JustChat
//
//  Created by 최준현 on 5/12/24.
//

import SwiftUI

struct ChatListView: View {
    
    @StateObject private var chatListVM = ChatStore.shared
    @ObservedObject var loginStore : LoginStore
    
    @State private var isShow = false
    @State private var searchText = ""
    @State private var scrollPosition: ChatData?
    @State private var int = 1
    
    private var list: [ChatData]{
        if !searchText.isEmpty{
            return chatListVM.chatList.filter{$0.channerName.contains(searchText)}
        }else{
            return chatListVM.chatList
        }
    }
    
    
    var body: some View {
        
        NavigationStack{
            
            ZStack(alignment: .bottomTrailing){
                VStack{
                    ChatSearchView(searchText: $searchText)
                        .padding()
                        
                    ScrollView{
                        LazyVStack{
                        
                            ForEach(list, id: \.self){ chatData in
                                NavigationLink{
                                    ChattingView(chatData: chatData)
                                }label:{
                                    ChatListItem(chatData: chatData)
                                }
                                
                                .buttonStyle(.plain)
                                .onAppear{
                                    if chatData.channerNo == chatListVM.chatList.last?.channerNo{
                                        chatListVM.chatListModel.pageCurrent += 1
                                        Task{
                                            await chatListVM.fetchList()
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                    
                    }//List
                    .scrollPosition(id: $scrollPosition, anchor: .top)
                }
                
                //채팅 생성버튼
                NavigationLink{
                    ChatCreateView(chatStore: chatListVM)
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
            .navigationTitle("ChatRoom")
            .navigationBarTitleDisplayMode(.large)
            
            
        }//NavigatioNStack
        
        .onAppear(){
            Task{
                chatListVM.chatListModel.memberID =  UserManager.shared.getCurrentUser().memberID
                
                await chatListVM.fetchList()
                
            }
        }
        .refreshable {
            await chatListVM.fetchList()
        }
        
    }
}

#Preview {
    ChatListView(loginStore: LoginStore())
}
