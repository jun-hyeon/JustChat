//
//  ChatListItem.swift
//  JustChat
//
//  Created by 최준현 on 5/13/24.
//

import SwiftUI

struct ChatListItem: View {
    var chatData: ChatData
    var body: some View {
        VStack{
        
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
                    
                }//asyncImage
                
                VStack(alignment: .leading){
                    Text(chatData.channerName)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
            }//HStack
            
            Divider()
                
            
        }// VStack
    }
}

#Preview {
    ChatListItem(chatData: ChatData(channerNo: "4C2bBONchzGBGep_if7yI", channerName: "1234", memberID: "qwer"))
}
