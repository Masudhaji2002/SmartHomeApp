//
//  FullComponent.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 25.03.2024.
//

import SwiftUI

struct FullComponent: View {
    let nameRoom: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(nameRoom)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, -10)
                .padding(.horizontal, 10)
            
            HStack(spacing:-8) {
                SmartCategoriesHome(title: "Люстра", variable1: "Вкл", variable2: "Выкл", nameImage: "svet")
                    .frame(width: 200)
                SmartCategoriesHome(title: "Подсветка", variable1: "Вкл", variable2: "Выкл", nameImage: "svet")
                    .frame(width: 200, height: 10)
            }
            .padding(.bottom, 60)
            
            HStack {
                SmartCategoriesHome(title: "Камера", variable1: "Вкл", variable2: "Выкл", nameImage: "camera")
                    .frame(width: 200)
                    
            }
            .padding(.bottom, 80)
            HStack() {
                ComponentCub(nameImage: "temperatura")
                    .padding(.horizontal, 15)
                ComponentCub(nameImage: "vlaj")
                   
            }
            .padding(.bottom)
        }
        
    }
}

#Preview {
    FullComponent(nameRoom: "Десткая")
}
