//
//  Extensions.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/6.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
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
struct Screen
{
    static let Width = UIScreen.main.bounds.width - 10
    static let Height = UIScreen.main.bounds.height - 10
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
