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
    @State var loginFail = false
    @State var dropDown = false
    @ObservedObject var viewModel = LoginViewModel()
    var autoAuth = true
    var body: some View
    {
//        NavigationView
//        {
        ZStack
        {
            VStack(spacing: 20)
            {
                HStack(spacing: 22)
                {
                    Image(systemName: "person.fill").resizable().frame(width: 20, height: 20)
                    TextField("Account Name", text: $viewModel.accName)
                    Image(systemName: "arrowtriangle.down.fill").resizable().frame(width: 20, height: 15).onTapGesture { self.dropDown.toggle() }
                }
                .padding(12).overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1))

                HStack(spacing: 22)
                {
                    Image(systemName: "lock.fill").resizable().frame(width: 20, height: 20)
                    TextField("POESESSID", text: $viewModel.POESESSID)
                        // .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.default)
                }
                .padding(12).overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1))

                Toggle(isOn: $viewModel.wannaStore)
                {
                    Text("Remeber me")
                }.frame(width: 200.0)
                Button(action: {
                    self.viewModel.accountAuth
                    { _ in
                        self.loginFail = !self.viewModel.authed
                        self.logInSuccess = self.viewModel.authed
                    }
                    print("Authed : \(self.viewModel.authed)")
                    print("log In Success : \(self.logInSuccess)")
                })
                {
                    Text("Authenticate")
                }
//                    })
            }.frame(width: Screen.Width * 0.8)

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
            VStack
            {
                if dropDown
                {
                    Spacer().fixedSize().frame(height: 70)
                    HStack
                    {
                        Image(systemName: "lock.fill").resizable().frame(width: 20, height: 20).hidden()
                        List
                        {
                            ForEach(self.viewModel.dataSource.fetchedObjects)
                            { Acc in
                                Text(Acc.name).onTapGesture {
                                    self.viewModel.accName = Acc.name
                                    self.viewModel.POESESSID = Acc.poesessid
                                    self.dropDown = false
                                }
                            }
                        }.background(Color.black).border(Color.white, width: 1)
                    }.frame(width: Screen.Width * 0.8, height: Screen.Height * 0.2)
                }
            }
            // }.navigationBarTitle(Text(""), displayMode: .inline)
        }.toast(isShowing: $loginFail, text: Text("Login Fail"))
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
