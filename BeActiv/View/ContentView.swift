//
//  ContentView.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 21.03.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var temperature: Int?
    @State private var humidity: Int?
    
    var body: some View {
        VStack {
            if let temperature = temperature {
                Text("Temperature: \(temperature)°C")
                    .font(.title)
            } else {
                Text("Temperature: No data")
                    .font(.title)
            }
            
            if let humidity = humidity {
                Text("Humidity: \(humidity)%")
                    .font(.title)
            } else {
                Text("Humidity: No data")
                    .font(.title)
            }
        }
        .onAppear {
            fetchData()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

