//
//  ChatCreateView.swift
//  JustChat
//
//  Created by 최준현 on 6/1/24.
//

import SwiftUI

struct ChatCreateView: View {
    
    @ObservedObject var chatStore: ChatStore
    
    
    @Environment (\.dismiss) private var dismiss
    
    
    @State private var roomName = ""
    @State private var roomPwd = ""
    @State private var isPrivate = false
    @State private var openUserList = false
    @State private var searchText = ""
    @State private var selectedMember = Set<MemberData>()
    
    @State private var roomNameError = true
    @State private var roomPwdError = true
    @State private var inviteMemberError = true
    
    private let userData = UserManager.shared.getCurrentUser()
    
    private func createChat(){
        
    }
    
    var body: some View {
        
        NavigationStack{
            
            ScrollView{
                VStack{
                    Spacer()
                    
                    VStack{
                        Text("title")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        //id입력
                        TextField("방 제목을 입력해주세요", text: $roomName)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 8).stroke(.black)
                            }
                            .textInputAutocapitalization(.never)
                            .onChange(of: roomName){
                                roomNameError = roomName.count < 2 ? true : false
                            }
                        
                    }
                    .padding()
                    
                    
                    VStack{
                        Toggle("방 공개여부", isOn: $isPrivate)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 8).stroke(.black)
                            }
                    }
                    .padding()
                    
                    
                    if isPrivate{
                        VStack{
                            
                            Text("password")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            //id입력
                            SecureField("비밀번호를 입력해주세요", text: $roomPwd)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8).stroke(.black)
                                }
                                .textInputAutocapitalization(.never)
                                .textContentType(.password)
                                .keyboardType(.decimalPad)
                                .onChange(of: roomPwd) {
                                    roomPwdError = roomPwd.count < 2 ? true : false
                                }
                        }
                        .padding()
                    }
                    
                    
                    VStack{
                        //초대하기 버튼
                        Button{
                            openUserList.toggle()
                        }label:{
                            Text("초대하기")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Spacer()
                    
                    
                    HStack(spacing: 5){
                        ForEach(selectedMember.sorted{$0.nickName < $1.nickName}, id: \.self){ member in
                            CircleUserItem(memberData: member)
                            Spacer()
                        }
                        .onChange(of: selectedMember) {
                            inviteMemberError = selectedMember.count <= 0 ? true : false
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    
                    //방 생성 버튼
                    Button{
                        // 버튼이 눌렸을 때의 동작
                        if checkError(){
                            var chatModel = CreateChatModel(memberID: userData.memberID, channerName: roomName, inviteMember: selectedMember.map{$0.memberID})
                            if isPrivate{
                                
                                chatModel.connectKey = Int(roomPwd)
                            }
                            
                            Task{
                                
                                await chatStore.createChat(chatModel: chatModel)
                                
                            }
                            dismiss()
                        }
                        
                    }label: {
                        Text("방 생성하기")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(checkError() ? .blue : Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 16))
                    .shadow(radius: 10)
                    
                    
                }
                .navigationTitle("방 생성")
                .navigationBarTitleDisplayMode(.large)
                .sheet(isPresented: $openUserList){
                    InviteView(openUserList: $openUserList, selectedMember: $selectedMember)
                }
            }
        }//NavigationStack
        
        
    }
    
    func checkError() -> Bool{
        if roomNameError || inviteMemberError{
            return false
        }
        if isPrivate {
            if roomPwdError || inviteMemberError{
                return false
            }
        }
        return true
    }
}

#Preview {
    ChatCreateView(chatStore: ChatStore())
}
