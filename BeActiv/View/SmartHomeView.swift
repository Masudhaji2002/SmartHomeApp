//
//  SmartHomeView.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 15.03.2024.
//

import SwiftUI

struct SmartHomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                SmartCategories()
                    .frame(width: 400, height: 90)
                FullComponent(nameRoom: "Гостиная")
                
                
                Text("Спальня")
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
                
                HStack(spacing: -8) {
                    SmartCategoriesHome(title: "Камера", variable1: "Вкл", variable2: "Выкл", nameImage: "camera")
                        .frame(width: 200)
                    SmartCategoriesHome(title: "Торшеры", variable1: "Вкл", variable2: "Выкл", nameImage: "svet")
                        .frame(width: 200, height: 10)
                        
                }
                .padding(.bottom, 80)
                HStack() {
                    ComponentCub(nameImage: "temperatura")
                        .padding(.horizontal, 15)
                    ComponentCub(nameImage: "vlaj")
                       
                }
                .padding(.bottom)
                FullComponent(nameRoom: "Детская")
                FullComponent(nameRoom: "Кухня")
                
                
                
            }
        }
    }
}


struct SmartHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SmartHomeView()
    }
}
