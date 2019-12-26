//
//  ToastView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/12/25.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI

struct Toast<Presenting>: View where Presenting: View
{
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text

    var body: some View
    {
        if self.isShowing
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
            {
                self.isShowing = false
            }
        }
        return
            GeometryReader
        { geometry in
            ZStack(alignment: .center)
            {
                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)

                VStack
                {
                    self.text
                }
                .frame(width: geometry.size.width / 1.5,
                       height: geometry.size.height / 7)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .border(Color.white, width: 10)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 5 * 4)
            }
        }
    }
}

extension View
{
    func toast(isShowing: Binding<Bool>, text: Text) -> some View
    {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }
}
