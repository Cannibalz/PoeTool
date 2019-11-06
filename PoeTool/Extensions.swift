//
//  Extensions.swift
//  PoeTool
//
//  Created by 高梵 on 2019/11/6.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation

extension Int
{
    mutating func returnAndPlusOne()->Int
    {
        let temp = self
        self += 1
        return temp
    }
}
