//
//  HomeView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/12/10.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI

struct HomeView : View
{
    @State var logInSuccess = false
    var body: some View
    {
        return Group
        {
            if PoEData.shared.isLogged
            {
                CharactersListView()
            }
            else
            {
                LogInView(logInSuccess: $logInSuccess)
            }
        }
        
        
    }

}
