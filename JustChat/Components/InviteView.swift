//
//  InviteView.swift
//  JustChat
//
//  Created by 최준현 on 6/7/24.
//

import SwiftUI

struct InviteView: View {
    
    @StateObject private var searchVM = SearchViewModel.shared
    @State private var editMode = EditMode.active
    
    @Binding var openUserList : Bool
    @Binding var selectedMember : Set<MemberData>
    
    var body: some View {
        List(selection: $selectedMember){
                
                ZStack(alignment: .trailing){
                    TextField("유저 검색 2자이상", text: $searchVM.searchModel.keyword)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .overlay{
                            Capsule()
                                .stroke(.black, lineWidth: 1.0)
                        }
                        .onSubmit {
                            print("화면 입력: ", searchVM.searchModel.keyword)
                            Task{
                                await searchVM.fetchSearchUser()
                            }
                        }
                }
                .padding()
                    
                    
                ForEach(searchVM.searchList, id: \.self){ member in
                    UserListItem(memberData: member)
                }
                .listRowSeparator(.hidden,edges: .all)
            
                HStack{
                    Spacer()
                    Button{
                        print(selectedMember)
                        openUserList.toggle()
                    }label:{
                        Text("초대하기")
                            .font(.headline)
                            .foregroundColor(.white)
                            
                    }
                    .padding()
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 16))
                    .shadow(radius: 10)
                    Spacer()
                }
                .listRowSeparator(.hidden,edges: .all)
                
        }// List
        .environment(\.editMode, $editMode)
        .listStyle(.plain)
    }//sheet
}


