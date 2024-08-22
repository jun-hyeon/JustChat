//
//  ChatSearchView.swift
//  JustChat
//
//  Created by 최준현 on 7/23/24.
//

import Foundation
import SwiftUI

struct ChatSearchView: View {
    @Binding var searchText: String
    var body: some View {
        HStack{
            TextField("채팅방을 검색해주세요", text: $searchText)
                .textInputAutocapitalization(.never)
            Spacer()
            Button{
                //search function
            }label:{
                Image(systemName: "magnifyingglass")
                    
            }.foregroundStyle(.primary)
            
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay{
            RoundedRectangle(cornerRadius: 24)
                .stroke(.gray, lineWidth: 1.0)
        }
        
        
    }
}

#Preview {
    ChatSearchView(searchText: .constant("Hello"))
}
