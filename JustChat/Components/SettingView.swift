//
//  SettingView.swift
//  JustChat
//
//  Created by 최준현 on 5/12/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        List{
            VStack(alignment: .leading){
                    HStack{
                        AsyncImage(url: URL(string:"")) { image in
                            
                        } placeholder: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width:90, height: 90)
                                .clipShape(Circle())
                                .overlay{
                                    Circle().stroke(.white, lineWidth: 2)
                                }
                                .shadow(radius: 6)
                                .padding()
                        }
                        
                        VStack(alignment: .leading){
                            Text("Amir-Zhen")
                                .font(.title2)
                                .fontWeight(.semibold)
                                
                            Text("As long as it is a payment")
                                .font(.caption)
                                .fontWeight(.thin)
                                .foregroundStyle(.gray)
                        }
                    }//HStack
                Spacer()
                    
                VStack(alignment:.leading, spacing: 32){
                    
                                Label{
                                    Text("Available")
                                        .font(.title2)
                                }icon:{
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.green)
                                }
                                
                                Label{
                                    Text("Notification")
                                        .font(.title2)
                                }icon:{
                                    Image(systemName: "bell")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.black)
                                }
                                
                                Label{
                                    Text("abcd@1234.com")
                                        .font(.title2)
                                        .tint(.black)
                                        
                                }icon:{
                                    Image(systemName: "envelope")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.black)
                                }
                                
                    
                            }.padding(.horizontal)
                
            }
            .listRowSeparator(.hidden, edges: .all)
            .padding(.horizontal)
            
        }
        .listStyle(.plain)
        
    }
}

#Preview {
    SettingView()
}
