//
//  UserListItem.swift
//  JustChat
//
//  Created by 최준현 on 5/26/24.
//

import SwiftUI

struct UserListItem: View {
    let memberData : MemberData?
    var body: some View {
        VStack{
          
            HStack{
                AsyncImage(url: URL(string: memberData?.profileFile ?? "")) { image in
                    
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
                    Text(memberData?.nickName ?? "")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    
                }
                
                Spacer()
                
               
            }//HStack
            
            Divider()
        }
    }
}

#Preview {
    UserListItem(memberData: MemberData(memberID: "", memberName: "", nickName: "", profileFile: ""))
}
