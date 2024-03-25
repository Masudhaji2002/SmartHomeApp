//
//  RegistrationView.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 18.03.2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
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
                    
                    InputView(text: $fullName, title: "Имя", placeHolder: "Введите полное имя")
                    
                    InputView(text: $password, title: "Пароль", placeHolder: "    Введите пароль", isSecureField: true)
                    
                    InputView(text: $confirmPassword, title: "Подтвердите пароль", placeHolder: "   Введите повторно пароль", isSecureField: true)
                   
                }
                .padding(.horizontal)
                .padding(.top, 12)
            
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, fullname: fullName)
                }
            } label: {
                HStack {
                    Text("Зарегистрироваться")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(.gray)
            .clipShape(Capsule())
            .padding(.top, 24)
                
        }
        Spacer()
        
        Button {
            dismiss()
        } label: {
            HStack(spacing: 5) {
                Text("У вас есть аккаунта?")
                Text("Войти")
                    .fontWeight(.bold)
                    
            }
            .font(.system(size: 14))
            .foregroundStyle(.black)
        }
        
    }
}

#Preview {
    RegistrationView()
}
