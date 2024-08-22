//
//  SettingView.swift
//  JustChat
//
//  Created by 최준현 on 5/12/24.
//

import SwiftUI
import PhotosUI

struct SettingView: View {
    
    @ObservedObject var loginVM : LoginStore
    @State private var profileKey = ""
    @State private var isEdit = false
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var myImage: UIImage?
    @State private var nickName = ""
    private let imageManager = ImageManager.shared
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading){
                    HStack{
                        if isEdit{
                            PhotosPicker(selection: $photosPickerItem, photoLibrary: .shared()){
                                if let image = myImage{
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                    
                                }else{
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.black)
                                }
                            }
                            .frame(width:90, height: 90)
                            .clipShape(Circle())
                            .overlay{
                                Circle().stroke(.white, lineWidth: 2)
                            }
                            .shadow(radius: 6)
                            .padding()
                            .onChange(of: photosPickerItem){
                                Task{
                                    if let data = try? await photosPickerItem?.loadTransferable(type: Data.self){
                                        myImage = UIImage(data: data)
                                        print("OnChange imageData: ", myImage as Any)
                                    }else{
                                        print("Failed")
                                    }
                                }
                            }
                            
                            
                            TextField(nickName, text: $nickName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                        }else{
                            AsyncImage(url: URL(string: profileKey)) { image in
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
                            .task{
                                
                                let result = await imageManager.imageDownload(key: profileKey)
                                switch result{
                                case .success(let response):
                                    if response.success{
                                        profileKey = response.url
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                            
                            Text(nickName)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                    }//HStack
                    
                    Spacer()
                    
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
                .onAppear{
                    nickName = loginVM.getCurrentUser().nickName
                    guard let key = loginVM.getCurrentUser().profileKey else{
                        return
                    }
                    profileKey = key
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            isEdit.toggle()
                            
                        }label:{
                            Text(isEdit ? "cancel" : "Edit")
                        }
                    }
                    if isEdit{
                        ToolbarItem(placement: .topBarTrailing){
                            Button("저장"){
                                Task{
                                    guard let image = myImage else{
                                        print("no Image")
                                        return
                                    }
                                    await loginVM.updateProfile(nickName: nickName, image: image)
                                }
                            }
                        }
                    }
                }
                .padding()
                .onAppear{
                    print(UserManager.shared.getCurrentUser())
                }
            }
        }//navigationStack
    }
}

#Preview {
    
    SettingView(loginVM: LoginStore())
    
}
