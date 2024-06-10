//
//  MainView.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginVM : LoginViewModel
    @State private var showMessage = false
        
    var body: some View {
        if loginVM.isLoading {
            
            ProgressView()
                .controlSize(.large)
                .padding()
            
        }else{
            
            NavigationStack{
                ScrollView{
                    
                    VStack {
                        
                        VStack{
                            
                            Text("Just Chat")
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            
                            Text("Login to\n your account")
                                .font(.system(size: 30))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        .padding()
                        
                        VStack{
                            
                            Text("E-Mail Address*")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            //id입력
                            TextField("ID를 입력해주세요", text: $loginVM.loginModel.memberID)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8).stroke(.black)
                                }
                                .textInputAutocapitalization(.never)
                        }
                        .padding()
                        
                        
                        VStack{
                            
                            Text("Password*")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            //패스워드 입력
                            TextField("Password를 입력해주세요", text: $loginVM.loginModel.memberPwd)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8).stroke(.black)
                                }
                                .textInputAutocapitalization(.never)
                        }
                        .padding()
                        
                        
                        VStack(spacing: 25){
                            
                            //회원가입버튼
                            NavigationLink{
                                //TODO SignUp
                                SignUpView()
                            }label: {
                                Text("회원가입")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                
                            }
                            .buttonBorderShape(.roundedRectangle(radius: 8))
                            .controlSize(.large)
                            .buttonStyle(BorderedProminentButtonStyle())
                            
                            
                            
                            //로그인 버튼
                            Button{
                                //TODO 로그인 함수
                                
                                    print(loginVM.loginModel.memberID)
                                    print(loginVM.loginModel.memberPwd)
                                    showMessage.toggle()
                                Task{
                                    await loginVM.login()
                                }
                                
                            }label:{
                                Text("로그인")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                
                            }
                            .buttonBorderShape(.roundedRectangle(radius: 8))
                            .controlSize(.large)
                            .buttonStyle(BorderedProminentButtonStyle())
                            
                            
                            //구글로그인
                            Button{
                                //TODO Login Method
                                
                            
                            }label:{
                                Text("Continue With Google")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .clipShape(Capsule())
                            .controlSize(.large)
                            .buttonStyle(BorderedProminentButtonStyle())
                            .tint(.blue.opacity(0.5))
                            
                        }//ButtonVStack
                        .padding()
                        
                    }
                    }
                }//Vstack
                .padding()
                
                if showMessage{
                    withAnimation(.spring(duration: 1)){
                        ToastMessageView(type: .info, title: "Login", message: loginVM.loginInfo){
                            showMessage.toggle()
                        }
                    }

            }//ScrollView
            
            
        }//NavigationStack
        
    }
        
}

#Preview {
    LoginView(loginVM: LoginViewModel())
}
