//
//  ContentView.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 29.02.2024.
//

import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                Section("Основные") {
                    HStack {
                        SettingRowView(imageName: "gear", title: "Версия", tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                
                Section("Аккаунт") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingRowView(imageName: "arrow.left.circle.fill", title: "Выйти", tintColor: .red)
                    }
                    
                    Button {
                        print("Удалить аккаунт")
                    } label: {
                        SettingRowView(imageName: "xmark.circle.fill", title: "Удалить аккаунт", tintColor: .red)
                    }
                    
                    
                }
            }
        }
    }
}


#Preview {
    ProfileView()
}
