//
//  MainView.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import SwiftUI

struct Message: Codable, Hashable{
    var currentUser : Bool
    var msg : String
}


struct ChattingView: View {
    @State var str = ""
    @State private var messages = [
        
                        Message(currentUser: true, msg: "Helloaaaaaasdfasdfasdfasdfasdfasdfasdfasdf"),
                        
                        Message(currentUser: false, msg: "bbbcv,xmn asdm,.dfhnjkdsm,qafnkl;asdhnvm,zxc f,;asddmh"),
                        
                        Message(currentUser: true, msg: "Are you Okay?"),
                        
                        Message(currentUser: false, msg:"Yes")
                        
                            ]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach(messages, id: \.self){ message in
                    
                    VStack{
                        MessageCell(currentUser: message.currentUser, msg: message.msg)
                            .padding()

                    }//VStack
                    
                }//ForEach
                .padding()
                
            }//ScrollView
            HStack{
                
                Button{
                    //select image func
                    
                }label:{
                    Image(systemName: "plus")
                }
                
                Spacer()
                
                TextField("Chat", text: $str)
                    .padding(8)
                    
                    .overlay{
                        Capsule()
                            .stroke(.black, lineWidth: 1.0)
                    }
                    
                    Spacer()
                    
                Button{
                    //send message func
                    
                }label:{
                    Image(systemName: "paperplane")
                        .background(.white)
                        .clipShape(Circle())
                        
                }
            }
            .padding(.horizontal)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                
                HStack(alignment: .center){
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                        .padding(8)
                    
                    VStack{
                        
                        Text("aasdf")
                    }
                    .padding()
                }
            }
        }
        
        .onAppear{
            Task{
//                let socketManager = await WebsocketManager()
//                messages = socketManager.messages
            }
        }
    }
}

struct MessageCell: View {
    var currentUser : Bool
    var msg : String
    //후에 이미지 추가
    
    var body: some View {
        
        if currentUser {
            
            HStack(alignment: .top){
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(msg)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .lineLimit(17)
                        
                }
                .padding(8)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            

        }else{
            
            HStack(alignment: .top){
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                
                VStack{
                    Text(msg)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .lineLimit(17)
                }
                .padding(8)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
                    
            }
        }
        
    }
}


#Preview {
    ChattingView()
}
    
