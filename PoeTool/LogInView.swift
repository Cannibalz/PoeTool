//
//  ContentView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/13.
//  Copyright © 2019 KaFn. All rights reserved.
//

import SwiftUI



struct LogInView: View {
    @State private var accName = "niuwencong1"
    @State private var POESSID = "f2b5f9a200793c5b0f33ad660f8b31a8"
    @State private var segue : Int? = 0
    @State var accountInfo : AccountInfo = AccountInfo()
    @State var remeberPass = true
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView
        {
            VStack
            {
                NavigationLink(destination: CharacterSelectView(account:self.$accountInfo), tag: 1, selection: $segue) {
                    EmptyView()
                }
                TextField("Account Name",text: $accName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                TextField("POESSID",text: $POESSID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                Button(action: {
                    self.viewModel.login(accName:self.accName, POESESSID: self.POESSID)
                    {isError in
                        print(isError)
                        if isError
                        {
                            
                        }
                        else if !isError
                        {
                            self.segue = Int(1)
                        }
                    }
                })
                {
                    Text("Log In")
                }
                
                Toggle(isOn: $remeberPass) {
                    Text("Remeber me")
                }
                .frame(width: 200.0)
                
            }
        }

    }
}
#if DEBUG
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
#endif
