//
//  ContentView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/13.
//  Copyright © 2019 KaFn. All rights reserved.
//
import SwiftUI



struct LogInView: View {
    @State private var segue : Int? = 0
    @State var accountInfo : AccountInfo = AccountInfo()
    @State var remeberPass = true
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView
        {
            VStack
            {
                NavigationLink(destination: CharacterSelectView(account:self.$accountInfo), tag: 200, selection: $viewModel.statusCode) {
                    EmptyView()
                }
                TextField("Account Name",text: $viewModel.accName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                TextField("POESSID",text: $viewModel.POESSID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                
                
                Toggle(isOn: $viewModel.isToggle) {
                    Text("Remeber me")
                }
                .frame(width: 200.0)
                NavigationLink(destination: CharacterSelectView(account:self.$accountInfo), isActive: $viewModel.authed, label: {
                    Button(action: {
                        self.viewModel.accountAuth(accName: self.viewModel.accName, POESESSID: self.viewModel.POESSID)
                        {statusCode in
                            print(statusCode)
                        }
                    })
                    {
                        Text("Authenticate")
                    }
                })
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
