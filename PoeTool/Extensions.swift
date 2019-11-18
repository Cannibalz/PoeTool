//
//  Extensions.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/6.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
extension Int
{
    mutating func returnAndPlusOne()->Int
    {
        let temp = self
        self += 1
        return temp
    }
}
extension View
{
    func size()
    {

    }
}
extension Color
{
    static func frameTypeColor(_ frameType : Int)->Color
    {
        switch frameType
        {
            case 0:
                return Color.white
            case 1:
                return Color.blue
            case 2:
                return Color.yellow
            case 3:
                return Color.orange
            case 4:
                return Color.green
            default:
                return Color.white
        }
    }
}
