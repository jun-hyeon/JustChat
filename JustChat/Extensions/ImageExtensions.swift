//
//  ImageExtensions.swift
//  JustChat
//
//  Created by 최준현 on 8/19/24.
//

import Foundation
import SwiftUI

extension UIImage{
    func resize(newWidth: CGFloat) -> UIImage{
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
    
        return renderImage
    }
}
