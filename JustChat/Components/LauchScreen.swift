//
//  LauchScreen.swift
//  JustChat
//
//  Created by 최준현 on 8/18/24.
//

import SwiftUI

struct LauchScreen: View {
    
    let title = "Just Chat"
    private var initialDelays = [0.0, 0.04, 0.012, 0.18, 0.28, 0.35]
    var body: some View {
        ZStack{
            ZStack{
                AnimatedView(title: title, color: .teal, initialDelay: initialDelays[5], animationType: .spring(duration: 1))
                AnimatedView(title: title, color: .mint, initialDelay: initialDelays[4], animationType: .spring(duration: 1))
                AnimatedView(title: title, color: .indigo, initialDelay: initialDelays[2], animationType: .spring(duration: 1))
                AnimatedView(title: title, color: .cyan, initialDelay: initialDelays[1], animationType: .spring(duration: 1))
            }
            AnimatedView(title: title, color: .black, initialDelay: initialDelays[0], animationType: .spring)
        }
    }
}


struct AnimatedView: View{
    let title: String
    let color: Color
    let initialDelay: Double
    let animationType: Animation
    @State var scall = false
    @State private var show = false
    private var delayStep = 0.1
    init(title: String,color: Color, initialDelay: Double, animationType: Animation) {
        self.title = title
        self.color = color
        self.initialDelay = initialDelay
        self.animationType = animationType
    }
    var body: some View{
        HStack(spacing: 0){
            ForEach(0..<title.count, id: \.self){ index in
                Text(String(title[title.index(title.startIndex, offsetBy: index)]))
                    .font(.system(size: 70)).bold()
                    .opacity(show ? 1 : 0)
                    .offset(y: show ? -30 : 30)
                    .animation(animationType.delay(Double(index) * delayStep + initialDelay), value: show)
                    .foregroundStyle(color)
            }
        }
        .scaleEffect(scall ? 1 : 1.2)
        .onAppear{
            show.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                withAnimation{
                    scall.toggle()
                }
            }
        }
    }
}

#Preview {
    LauchScreen()
}
