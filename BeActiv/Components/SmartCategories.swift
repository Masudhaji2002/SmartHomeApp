//
//  SmartCategories.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 22.03.2024.
//

import SwiftUI

struct SmartCategories: View {
    @State private var onRobot = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: -3) {
                Text("Робот")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(.black)
                Text(onRobot ? "Включен" : "Выключен") // Текст меняется в зависимости от состояния
                    .font(.title2)
                    .fontWeight(.light)
                    .foregroundColor(onRobot ? .green : .gray)
            }
            .padding()
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(onRobot ? Color.green : Color.white) // Цвет круга меняется в зависимости от состояния
                    
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(onRobot ? Color.green : Color.gray)
                    )
                
                Image("iconRobot")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .onTapGesture {
                    onRobot.toggle() // Изменение состояния при нажатии
                }
        )
        .padding()
    }
}


#Preview {
    SmartCategories()
}
