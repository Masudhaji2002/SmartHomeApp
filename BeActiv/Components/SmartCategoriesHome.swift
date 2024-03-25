import SwiftUI

struct SmartCategoriesHome: View {
    @State private var onOrOff = false
    let title: String
    let variable1: String
    let variable2: String
    let nameImage: String
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.system(size: geometry.size.width * 0.08)) // Размер шрифта зависит от ширины капсулы
                        .fontWeight(.light)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text(onOrOff ? variable1 : variable2)
                        .font(.system(size: geometry.size.width * 0.06)) // Размер шрифта зависит от ширины капсулы
                        .fontWeight(.light)
                        .foregroundColor(onOrOff ? .green : .gray)
                        .lineLimit(1)
                }
                .padding()
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(onOrOff ? Color.green : Color.white)
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                        .overlay(
                            Circle()
                                .stroke(onOrOff ? Color.green : Color.gray)
                        )
                    
                    Image(nameImage)
                        .resizable()
                        .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                        .foregroundColor(.white)
                }
                .padding()
            }
            .frame(width: geometry.size.width * 0.92)
            .background(
                Capsule()
                    .fill(Color.white)
                    .overlay(
                        Capsule()
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .onTapGesture {
                        onOrOff.toggle()
                    }
            )
            .padding()
        }
    }
}

struct SmartCategoriesHome_Previews: PreviewProvider {
    static var previews: some View {
        SmartCategoriesHome(title: "Люстра", variable1: "Вкл", variable2: "Выкл", nameImage: "svet")
    }
}
