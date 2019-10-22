//
//  ContentView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/13.
//  Copyright © 2019 KaFn. All rights reserved.
//
import SwiftUI



struct LogInView: View {
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView
        {
            ZStack
            {
                VStack
                {
                    TextField("Account Name",text: $viewModel.accName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    TextField("POESSID",text: $viewModel.POESSID)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    Toggle(isOn: $viewModel.isToggle) {
                        Text("Remeber me")
                    }.frame(width: 200.0)
                    NavigationLink(destination: CharacterSelectView(), isActive: $viewModel.authed, label: {
                        Button(action: {
                            self.viewModel.accountAuth(accName: self.viewModel.accName, POESESSID: self.viewModel.POESSID)
                            print(self.viewModel.authed)
                        })
                        {
                            Text("Authenticate")
                        }
                    })
                }
                Image(systemName: "arrow.2.circlepath.circle")
                    .resizable()
                    .frame(width: 200.0, height: 200.0)
                    .rotationEffect(.degrees(360))
                    .animation(.linear)
                    .onAppear(){}
                    //.hidden()
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
