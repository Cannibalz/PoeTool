//
//  Account.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/18.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class AccountInfo : Codable
{
    static let shared = AccountInfo()
    var characters : [CharacterInfo] = [CharacterInfo]()
    var accountName : String = ""
    var leagues = Array<String>()
    public init(characters:[CharacterInfo], accountName:String, leagues:[String])
    {
        self.characters = characters
        self.accountName = accountName
        self.leagues = leagues
    }
    public init()
    {}
}
