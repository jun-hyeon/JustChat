//
//  SignUpView.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    
    @StateObject var signUpVM = SignUpViewModel()
    
    @State private var signUpId = ""
    @State private var signUpPwd = ""
    @State private var checkPwd = ""
    @State private var signUpName = ""
    @State private var signUpNickName = ""
    
    @State private var isIdError = true
    @State private var isPwdError = true
    @State private var isPwdCheckError = true
    @State private var isNameError = true
    @State private var isNickError = true
    
    @State private var photoItem : PhotosPickerItem?
    @State private var photoImage : UIImage?
    @State private var imageData : Data?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack{
            ScrollView{
                    VStack{
                        //앨범에서 이미지 선택
                        Spacer()
                        PhotosPicker(selection: $photoItem, photoLibrary: .shared()) {
                            
                            //이미지가 선택되었을때
                            if let image = photoImage{
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                                    .overlay{
                                        Circle().stroke(.white, lineWidth: 2)
                                    }
                                    .shadow(radius: 6)
                                    .padding()
                                
                            }else{
                                //이미지가 선택되지 않았을때
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                                    .overlay{
                                        Circle().stroke(.white, lineWidth: 1)
                                    }
                                    .shadow(radius: 6)
                                    .padding()
                                    .foregroundStyle(.black)
                            }
                            
                        }
                        
                        .onChange(of: photoItem){
                            Task{
                                if let data = try? await photoItem?.loadTransferable(type: Data.self){
                                    photoImage = UIImage(data: data)
                                    
                                    print("OnChange imageData: ", photoImage as Any)
                                }else{
                                    print("Failed")
                                }
                            }
                        }
                            
                        //name입력
                        VStack(alignment: .leading){
                            Text("Name")
                            TextField("이름을 입력해주세요", text: $signUpName)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8).stroke(.black)
                                }
                                .onChange(of: signUpName){
                                    isNameError = signUpName.count < 2 ? true : false
                                }
                                
                            Text("2자이상 입력해주세요.")
                                .font(.caption)
                                .foregroundStyle(isNameError ? .red : .clear )
                        }
                        .padding(.horizontal)
                        
                        //NickName 입력
                        VStack(alignment: .leading){
                            Text("NickName")
                            
                            TextField("NickName을 입력해주세요", text: $signUpNickName)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8).stroke(.black)
                                }
                                .onChange(of: signUpNickName){
                                    isNickError = signUpNickName.count < 2 ? true : false
                                }
                                
                            Text("2자이상 입력해주세요.")
                                .font(.caption)
                                .foregroundStyle(isNickError ? .red : .clear )
                        }
                        .padding(.horizontal)

                        
                        //id입력
                        VStack(alignment:.leading){
                            Text("ID")
                            TextField("ID를 입력해주세요", text: $signUpId)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8).stroke(.black)
                                }
                                .onChange(of: signUpId){
                                    isIdError = signUpId.count < 4 ? true : false
                                }
                                
                            Text("4자이상 입력해주세요.")
                                .font(.caption)
                                .foregroundStyle(isIdError ? .red : .clear )
                        }
                        .padding(.horizontal)
                        
                        //패스워드 입력
                        VStack(alignment: .leading){
                            Text("Password")
                            
                            
                            SecureField("Password를 입력해주세요", text: $signUpPwd)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8).stroke(.black)
                                }
                                .onChange(of: signUpPwd){
                                    isPwdError = signUpPwd.count < 4 ? true : false
                                }
                                
                            Text("2자이상 입력해주세요.")
                                .font(.caption)
                                .foregroundStyle(isPwdError ? .red : .clear )
                        }
                        .padding(.horizontal)
                            
                        
                        VStack(alignment: .leading){
                            Text("PasswordCheck")
                            //패스워드 확인
                            SecureField("Password를 입력해주세요", text: $checkPwd)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8).stroke(.black)
                                }
                                .onChange(of: checkPwd){
                                    isPwdCheckError = signUpPwd != checkPwd ? true : false
                                }
                                
                            Text("비밀번호를 정확하게 입력해주세요")
                                .font(.caption)
                                .foregroundStyle(isPwdCheckError ? .red : .clear )
                        }
                        .padding(.horizontal)
                        
                        
                        
                        // 회원가입 버튼
                        Button{
                            //TODO 회원가입 기능
                            if checkSignUp(){
                                
                                signUpVM.registerModel.memberID = signUpId
                                signUpVM.registerModel.memberName = signUpName
                                signUpVM.registerModel.memberPwd = signUpPwd
                                signUpVM.registerModel.nickName = signUpNickName
                                
                                
                                
                                Task{
                                    guard let image = photoImage else {
                                        print("NO ImageData!")
                                        return
                                    }
                                    print("Button imageData", image)
                                    await signUpVM.signUp(image: image)
                                }
                                
                                self.dismiss()
                                
                            }
                            
                        }label:{
                            Text("회원가입")
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonBorderShape(.roundedRectangle(radius: 8))
                        .controlSize(.large)
                        .buttonStyle(BorderedProminentButtonStyle())
                        .padding()
                        
                        
                    }//VStack
                    .padding()
                
            }
        }//NavigationStack
        .navigationTitle("회원가입")
    }
    
    func checkSignUp() -> Bool{
        if isIdError || isPwdError || isNameError || isPwdCheckError || isNickError{
            return false
        }
        return true
    }
}

#Preview {
    SignUpView()
}
