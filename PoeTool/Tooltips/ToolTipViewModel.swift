//
//  ToolTipViewModel.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/12.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

enum PressState
{
    case inactive
    case pressing
    case dragging(translation: CGSize)

    var translation: CGSize?
    {
        switch self
        {
        case .inactive, .pressing:
            return nil
        case let .dragging(translation):
            return translation
        }
    }

    var isActive: Bool
    {
        switch self
        {
        case .inactive:
            return false
        case .pressing, .dragging:
            return true
        }
    }

    var isDragging: Bool
    {
        switch self
        {
        case .inactive, .pressing:
            return false
        case .dragging:
            return true
        }
    }
}

class ToolTipGesture: ObservableObject
{
//    @GestureState var dragState = PressState.inactive
//    @GestureState var dragState = CGSize.zero
    let minimumLongPressDuration = 0.1
    var longPressDrag = LongPressGesture(minimumDuration: 0.1)
    init()
    {
        
    }
}
