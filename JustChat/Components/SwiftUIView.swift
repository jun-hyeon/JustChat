//
//  SwiftUIView.swift
//  JustChat
//
//  Created by 최준현 on 6/1/24.
//

import SwiftUI

struct CreateChatRoomView: View {
//    @EnvironmentObject var viewModel: ChatRoomViewModel
    @State private var chatRoomName = ""
    @State private var chatRoomDescription = ""

    var body: some View {
        VStack {
            TextField("Chat Room Name", text: $chatRoomName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            TextField("Description", text: $chatRoomDescription)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            Button(action: {
//                viewModel.addChatRoom(name: chatRoomName, description: chatRoomDescription)
//                chatRoomName = ""
//                chatRoomDescription = ""
            }) {
                Text("Create")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Create Chat Room")
    }
}
#Preview {
    CreateChatRoomView()
}
