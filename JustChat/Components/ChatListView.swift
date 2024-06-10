//
//  ChatListView.swift
//  JustChat
//
//  Created by 최준현 on 5/12/24.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var chatListVM = ChatListViewModel.shared
    @State private var isShow = false
    var url = ""
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottomTrailing){
                ScrollView{
                    HStack{
                        AsyncImage(url: URL(string:"")) { image in
                        } placeholder: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width:48, height: 48)
                                .clipShape(Circle())
                                .overlay{
                                    Circle().stroke(.white, lineWidth: 2)
                                }
                                .shadow(radius: 6)
                                .padding()
                        }
                        Spacer()
                        
                        VStack(alignment: .leading){
                            Text("Amir-Zhen")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                            
                            Text("As long as it is a payment")
                                .font(.caption)
                                .fontWeight(.thin)
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        Button{
                            
                        }label:{
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                
                                .frame(width: 26, height: 26)
                                .padding()
                                .foregroundStyle(.black)
                        }
                    }//HStack
                    
                    ForEach(chatListVM.chatList, id: \.self){ chatData in
                        NavigationLink{
                            ChattingView()
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
            Task{
                 await chatListVM.fetchList()
            }
        }
      

    }
}

#Preview {
    ChatListView()
}
