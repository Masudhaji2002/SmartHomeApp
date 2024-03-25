//
//  LoginView.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 15.03.2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject var viewModel = AuthViewModel()
    @State private var isProfileViewActive = false
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        ZStack {
                            
                            HStack {
                                Image("logo")
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                    .padding(.leading)
                                    .padding(.vertical)
                                    .padding(.horizontal, -10)
                                   // .padding(.horizontal)
                                VStack(alignment: .leading) {
                                    Text("Ваш")
                                        .bold()
                                        .font(.title)
                                        .padding(.horizontal)
                                    Text("Умный дом")
                                        .bold()
                                        .font(.title)
                                        .padding(.horizontal)
                                }
                                
                            }
                        }
                    }
                    //Form fields(компонент input)
                    InputView(text: $email, title: "Email адрес", placeHolder: "Введите email").textInputAutocapitalization(.none)
                    
                    InputView(text: $password, title: "Пароль", placeHolder: "    Введите пароль", isSecureField: true)
                   
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // sign in button
                // sign in button с переходом на ProfileView
                Button {
                                   Task {
                                       try await viewModel.signIn(withEmail: email, password: password)
                                       isProfileViewActive = true // Активируем переход на ProfileView
                                   }
                               } label: {
                                   HStack {
                                       Text("Войти")
                                           .fontWeight(.semibold)
                                       Image(systemName: "arrow.right")
                                   }
                                   .foregroundStyle(.white)
                                   .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                               }
                               .background(.gray)
                               .clipShape(Capsule())
                               .padding(.top, 24)
                               .fullScreenCover(isPresented: $isProfileViewActive, content: {
                                   BeActivTabView()
                               })
                Spacer()
                
                //sign up buttons
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 5) {
                        Text("У вас нет аккаунта?")
                        Text("Зарегистрироваться")
                            .fontWeight(.bold)
                            
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
                }
               
                
            }
            
        }
    }
}

#Preview {
    LoginView()
}
