//
//  HomeView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/12/10.
//  Copyright © 2019 KaFn. All rights reserved.
//

import Foundation
import SwiftUI

struct HomeView: View
{
    @State var logInSuccess = false
    @Environment(\.managedObjectContext) var managedObjectContext
    var body: some View
    {
        VStack
        {
            return Group
            {
                if logInSuccess
                {
                    CharactersListView(logInSuccess: $logInSuccess)
                }
                else
                {
                    LogInView(logInSuccess: $logInSuccess)
                }
            }
        }.onAppear(perform: {
             if let wannaStore: Bool = UserDefaults.standard.bool(forKey: "wannaStore")
             {

                if let _: String = UserDefaults.standard.string(forKey: "accName"), let _: String = UserDefaults.standard.string(forKey: "POESESSID"), wannaStore
                 {
                     PoEData.shared.ValidByUserDefault()
                     self.logInSuccess = true
                 }
             }
         })
         .onDisappear(perform: {
         })


    }

}
