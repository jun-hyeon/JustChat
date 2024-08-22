//
//  CircleUserItem.swift
//  JustChat
//
//  Created by 최준현 on 6/5/24.
//

import SwiftUI

struct CircleUserItem: View {
    var memberData: MemberData?
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: memberData?.profileKey ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                
            } placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                
            }//asyncImage
            .frame(width:48, height: 48)
            .clipShape(Circle())
            .overlay{
                Circle().stroke(.white, lineWidth: 2)
            }
            .shadow(radius: 6)
            
            
            Text(memberData?.nickName ?? "")
                .font(.body)
                .lineLimit(1)
                
        }
        
    }
}

#Preview {
    CircleUserItem(memberData: MemberData(memberID: "aaa", memberName: "aaa", nickName: "aaa",profileUrl: "" ,profileKey: "aaa" ))
}
