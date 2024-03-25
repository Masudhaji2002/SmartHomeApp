import SwiftUI
struct ComponentCub: View {
    @State private var temperature: Int?
    @State private var humidity: Int?
    
    let nameImage: String
    
    var body: some View {
        VStack {
            HStack {
                Image(nameImage)
                    .resizable()
                    .frame(width: 26, height: 41)
                    .padding(.top, 0)
                    .padding(.horizontal, -8)
                    .padding(.leading, 37)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 110, height: 110)
                        .overlay(
                            Circle()
                                .stroke(Color.green, lineWidth: 2)
                        )
                    
                    if nameImage == "vlaj" {
                        if let temperature = temperature, let humidity = humidity {
                            Text("\(humidity)%") // Отображение данных о температуре и влажности
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.center)
                        } else {
                            Text("No data")
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.center)
                        }
                    } else if nameImage == "temperature" {
                        if let temperature = temperature {
                            Text("\(temperature)°C") // Отображение данных о температуре
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.center)
                        } else {
                            Text("No data")
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.top, 70)
                .padding(.trailing, 50)
            }
            .frame(height: 160)
            
            Spacer()
            
            HStack(spacing: 45) {
                Image(systemName: "plus.square")
                    .resizable()
                    .frame(width: 39, height: 39)
                    .onTapGesture {
                        fetchData() // Получение новых данных при нажатии на иконку плюса
                    }
                
                Image(systemName: "minus.square")
                    .resizable()
                    .frame(width: 39, height: 39)
                    .onTapGesture {
                        fetchData() // Получение новых данных при нажатии на иконку минуса
                    }
            }
            .padding()
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
        .frame(width: 170, height: 190)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
        )
        .onAppear {
            fetchData() // Загрузка данных при появлении компонента
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "http://90.156.215.236:9090/dashboard/7fbf5b40-e2b1-11ee-a123-59a6714c955b?publicId=419899c0-e2b2-11ee-a123-59a6714c955b") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decodedData = try? JSONDecoder().decode(SensorData.self, from: data) {
                DispatchQueue.main.async {
                    temperature = decodedData.temperature
                    humidity = decodedData.humidity
                }
            } else {
                print("Failed to decode JSON data")
            }
        }.resume()
    }
}

struct ComponentCub_Previews: PreviewProvider {
    static var previews: some View {
        ComponentCub(nameImage: "vlaj")
    }
}

struct SensorData: Codable {
    let temperature: Int
    let humidity: Int
}
