//
//  ChartsView.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 10.03.2024.
//

import SwiftUI
import Charts

struct DailyStepView: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
}

enum ChartOptions {
    case oneWeek
    case oneMonth
    case threeMonth
    case yearToDate
    case oneYear
}

struct ChartsView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedChart: ChartOptions = .oneMonth
    @State var averageSteps: Double = 0
    @State var totalSteps: Double = 0
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                
                VStack {
                    Text("Average")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("\(Int(averageSteps)) steps")
                }
                
                Spacer()
                
                VStack {
                    Text("Total")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("\(Int(totalSteps)) steps")
                }
                
                Spacer()
            }
            .padding(.bottom)
            ZStack {
                switch selectedChart {
                case .oneWeek:
                    Chart {
                        ForEach(manager.oneWeekChartData) { daily in
                            BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                        }
                    }
                    .onAppear {
                        if manager.oneWeekChartData.count > 0 {
                            totalSteps = manager.oneWeekChartData.reduce(0.00, { $0 + $1.stepCount })
                            averageSteps = totalSteps / Double(manager.oneWeekChartData.count)
                        }
                    }
                case .oneMonth:
                    Chart {
                        ForEach(manager.oneMonthChartData) { daily in
                            BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                        }
                    }
                    .onAppear {
                        if manager.oneMonthChartData.count > 0 {
                            totalSteps = manager.oneMonthChartData.reduce(0.00, { $0 + $1.stepCount })
                            averageSteps = totalSteps / Double(manager.oneMonthChartData.count)
                        }
                    }
                case .threeMonth:
                    Chart {
                        ForEach(manager.threeMonthChartData) { daily in
                            BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                        }
                    }
                    .onAppear {
                        if manager.threeMonthChartData.count > 0 {
                            totalSteps = manager.threeMonthChartData.reduce(0.00, { $0 + $1.stepCount })
                            averageSteps = totalSteps / Double(manager.threeMonthChartData.count)
                        }
                    }
                case .yearToDate:
                    Chart {
                        ForEach(manager.yearToDateChartData) { daily in
                            LineMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                        }
                    }
                    .onAppear {
                        if manager.yearToDateChartData.count > 0 {
                            totalSteps = manager.yearToDateChartData.reduce(0.00, { $0 + $1.stepCount })
                            averageSteps = totalSteps / Double(manager.yearToDateChartData.count)
                        }
                    }
                case .oneYear:
                    Chart {
                        ForEach(manager.oneYearChartData) { daily in
                            LineMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                        }
                    }
                    .onAppear {
                        if manager.oneYearChartData.count > 0 {
                            totalSteps = manager.oneYearChartData.reduce(0.00, { $0 + $1.stepCount })
                            averageSteps = totalSteps / Double(manager.oneYearChartData.count)
                        }
                    }
                }
            }
            .foregroundColor(.green)
            .frame(height: 350)
            .padding(.horizontal)
            
            HStack {
                Button("1W") {
                    withAnimation {
                        selectedChart = .oneWeek
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneWeek ? .white : .green)
                .background(selectedChart == .oneWeek ? .green : .clear)
                .cornerRadius(10)
                
                Button("1M") {
                    withAnimation {
                        selectedChart = .oneMonth
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneMonth ? .white : .green)
                .background(selectedChart == .oneMonth ? .green : .clear)
                .cornerRadius(10)
                
                Button("3M") {
                    withAnimation {
                        selectedChart = .threeMonth
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .threeMonth ? .white : .green)
                .background(selectedChart == .threeMonth ? .green : .clear)
                .cornerRadius(10)
                
                Button("YTD") {
                    withAnimation {
                        selectedChart = .yearToDate
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .yearToDate ? .white : .green)
                .background(selectedChart == .yearToDate ? .green : .clear)
                .cornerRadius(10)
                
                Button("1Y") {
                    withAnimation {
                        selectedChart = .oneYear
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneYear ? .white : .green)
                .background(selectedChart == .oneYear ? .green : .clear)
                .cornerRadius(10)
            }
        }
        .onAppear {
            manager.fetchPastWeekStepData()
            manager.fetchPastThreeMonthsStepData()
            manager.fetchYearToDateStepData()
        }
    }
}

#Preview {
    ChartsView()
}
