//
//  ContentView.swift
//  PoeTool
//
//  Created by 高梵 on 2019/10/13.
//  Copyright © 2019 KaFn. All rights reserved.
//
import SwiftUI
struct loadingCircle: View
{
    @State var spin = false

    var body: some View
    {
        VStack
        {
            Image(systemName: "arrow.2.circlepath.circle")
                .resizable()
                .frame(width: 200.0, height: 200.0)
                .rotationEffect(.degrees(spin ? 360 : 0))
                .animation(loadingAnimation)
                .onAppear { self.spin.toggle() }
                .cornerRadius(25)
            Text("loading...")
        }
        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }

    var loadingAnimation: Animation
    {
        Animation.linear(duration: 0.5)
            .speed(0.5)
            .repeatForever(autoreverses: false)
    }
}

struct LogInView: View
{
    @Binding var logInSuccess: Bool
    @ObservedObject var viewModel = LoginViewModel()
    var autoAuth = true
    var body: some View
    {
//        NavigationView
//        {
        ZStack
        {
            VStack
            {
                TextField("Account Name", text: $viewModel.accName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("POESESSID", text: $viewModel.POESESSID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.default)

                Toggle(isOn: $viewModel.wannaStore)
                {
                    Text("Remeber me")
                }.frame(width: 200.0)
                Button(action: {
                    print(self.viewModel.accName)
                    print(self.viewModel.POESESSID)
                    _ = UserAcc.createUserAcc(name: self.viewModel.accName, poesessid: self.viewModel.POESESSID, order: UserAcc.nextOrder())

                    self.viewModel.accountAuth
                    { _ in
                        self.logInSuccess = self.viewModel.authed
                    }
                    print("Authed : \(self.viewModel.authed)")
                    print("log In Success : \(self.logInSuccess)")
                })
                {
                    Text("Authenticate")
                }
//                    })
            }
            VStack
            {
                if viewModel.isLoading
                {
                    loadingCircle()
                }
                else
                {
                    loadingCircle().hidden()
                }
                Button(action: {
                    print("asdf")
                })
                {
                    Text("cancel")
                }
            }
            // }.navigationBarTitle(Text(""), displayMode: .inline)
        }
        .onAppear(perform: {
        })
        .onDisappear(perform: {
        })
    }

    private func endEditing()
    {
        UIApplication.shared.endEditing()
    }
}

#if DEBUG
    struct LogInView_Previews: PreviewProvider
    {
        static var previews: some View
        {
            LogInView(logInSuccess: .constant(false))
        }
    }
#endif
