//
//  SettingView.swift
//  JustChat
//
//  Created by 최준현 on 5/12/24.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var loginVM : LoginViewModel
    @State private var user = UserManager.shared.getCurrentUser()
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                    HStack{
                        
                        AsyncImage(url: URL(string:user.profileFile ?? "" )) { image in
                            image
                                .resizable()
                                .scaledToFill()
                            
                        } placeholder: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                
                        }//AsyncImage
                        .frame(width:90, height: 90)
                        .clipShape(Circle())
                        .overlay{
                            Circle().stroke(.white, lineWidth: 2)
                        }
                        .shadow(radius: 6)
                        .padding()
                        
                        VStack(alignment: .leading){
                            Text(user.nickName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                
                        }
                        Spacer()
                    }//HStack
                
                    
                
    
                    Label{
                        Text("Available")
                            .font(.title2)
                    }icon:{
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.green)
                            .frame(width: 20, height: 20)
                    }
                    .padding()
                    
                    Label{
                        Text("Notification")
                            .font(.title2)
                    }icon:{
                        Image(systemName: "bell")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .frame(width: 20, height: 20)
                    }
                    .padding()
                
                
                    
                            
                Spacer()
                
                Button{
                    loginVM.logOut()
                }label:{
                    Text("LogOut")
                }
                .padding()
                
            }
            .padding()
        }
    }
}

#Preview {
    SettingView(loginVM: LoginViewModel())
}
