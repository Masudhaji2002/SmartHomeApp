//
//  HealthManager.swift
//  BeActiv
//
//  Created by Масуд Гаджиев on 01.03.2024.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    // Starts on Monday
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 // Monday
        
        return calendar.date(from: components)!
    }
    
    static var oneWeekAgo: Date {
        let calendar = Calendar.current
        let oneWeek = calendar.date(byAdding: .day, value: -6, to: Date())
        return calendar.startOfDay(for: oneWeek!)
    }
    
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let oneMonth = calendar.date(byAdding: .month, value: -1, to: Date())
        return calendar.startOfDay(for: oneMonth!)
    }
    
    static var threeMonthsAgo: Date {
        let calendar = Calendar.current
        let threeMonths = calendar.date(byAdding: .month, value: -3, to: Date())
        return calendar.startOfDay(for: threeMonths!)
    }
    
    static var yearToDate: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: Date())
        
        return calendar.date(from: components)!
    }
    
    static var oneYearAgo: Date {
        let calendar = Calendar.current
        let oneYear = calendar.date(byAdding: .year, value: -1, to: Date())
        return calendar.startOfDay(for: oneYear!)
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var activites: [String : Activity] = [:]
    
    @Published var oneWeekChartData = [DailyStepView]()
    @Published var oneMonthChartData = [DailyStepView]()
    @Published var threeMonthChartData = [DailyStepView]()
    @Published var yearToDateChartData = [DailyStepView]()
    @Published var oneYearChartData = [DailyStepView]()
    
    @Published var mockActivities: [String : Activity] = [
        "todaySteps": Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: ""),
        "todayCalories": Activity(id: 1, title: "Today calories", subtitle: "Goal 900", image: "flame", tintColor: .red, amount: "1,241"),
        "weekRunning": Activity(id: 2, title: "Running", subtitle: "This week", image: "figure.walk", tintColor: .green, amount: "60 minutes"),
        "weekLifting": Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", tintColor: .cyan, amount: "80 minutes"),
        "weekSoccer": Activity(id: 4, title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .blue, amount: "20 minutes"),
        "weekBasketball": Activity(id: 5, title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .orange, amount: "18 minutes"),
        "weekStairs": Activity(id: 6, title: "Stair Stepper", subtitle: "This week", image: "figure.stair.stepper", tintColor: .green, amount: "10 minutes"),
        "weekKickbox": Activity(id: 7, title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "25 minutes"),
    ]
    
    
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        let temperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature)!
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let healthTypes: Set = [steps, calories, workout, sleepType, glucoseType, temperatureType, heartRateType]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                //fetchCurrentWeekWorkoutStats()
                fetchPastMonthStepData()
                fetchSleepData()
                fetchBloodGlucose()
                fetchBodyTemperature()
                fetchHeartRateData()
            } catch {
                print("errror fetching health data")
            }
        }
        
    }
    
    func fetchDailySteps(startDate: Date, completion: @escaping ([DailyStepView]) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        
        let anchorDate = Calendar.current.startOfDay(for: startDate)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: anchorDate, intervalComponents: interval)
        
        query.initialResultsHandler = { query, result, error in
            guard let result = result, error == nil else {
                completion([])
                return
            }
            var dailySteps = [DailyStepView]()
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailySteps.append(DailyStepView(date: statistics.startDate, stepCount: statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.00))
            }
            completion(dailySteps)
        }
        healthStore.execute(query)
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays step data")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            let stepActivity = Activity(id: 0, title: "Шагов сегодня", subtitle: "Цель 10,000", image: "figure.walk", tintColor: .green, amount: stepCount.formattedString())
            
            DispatchQueue.main.async {
                self.activites["todaySteps"] = stepActivity
            }
        }
        
        healthStore.execute(query)
    }

    
    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays calorie data")
                return
            }
            
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let caloriesActivity = Activity(id: 1, title: "Калорий сегодня", subtitle: "Цель 900", image: "flame", tintColor: .red, amount: caloriesBurned.formattedString())
            
            DispatchQueue.main.async {
                self.activites["todayCalories"] = caloriesActivity
            }
        }
        healthStore.execute(query)
    }
    
//    func fetchCurrentWeekRunningStats() {
//        let workout = HKSampleType.workoutType()
//
//        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
//        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
//        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
//        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 20, sortDescriptors: nil) { _, sample, error in
//            guard let workouts = sample as? [HKWorkout], error == nil else {
//                print("error fetching week running data")
//                return
//            }
//
//            var count: Int = 0
//            for workout in workouts {
//                let duration = Int(workout.duration)/60
//                count += duration
//            }
//            let activity = Activity(id: 2, title: "Running", subtitle: "This week", image: "figure.walk", amount: "\(count) minutes")
//
//            DispatchQueue.main.async {
//                self.activites["weekRunning"] = activity
//            }
//        }
//        healthStore.execute(query)
//    }
    
    func fetchSleepData() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("Error fetching sleep data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            var totalSleepTime: TimeInterval = 0
            for sample in samples {
                totalSleepTime += sample.endDate.timeIntervalSince(sample.startDate)
            }
            
            let sleepActivity = Activity(id: 8, title: "Сон", subtitle: "Последняя ночь", image: "moon.zzz", tintColor: .purple, amount: "\(Int(totalSleepTime / 60)) мин")
            
            DispatchQueue.main.async {
                self.activites["sleep"] = sleepActivity
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchBloodGlucose() {
        guard let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose) else {
            print("Blood glucose type not available")
            return
            
        }
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let query = HKStatisticsQuery(quantityType: glucoseType, quantitySamplePredicate: predicate, options: .mostRecent) { _, result, error in
            guard let result = result, error == nil else {
                print("Error fetching blood glucose data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let quantity = result.mostRecentQuantity() {
                let glucoseLevelMg = quantity.doubleValue(for: HKUnit(from: "mg/dL"))
                let glucoseLevelMmol = (glucoseLevelMg * 0.056).rounded()
                let glucoseActivity = Activity(id: 9, title: "Уровень Глюкозы", subtitle: "Текущий", image: "drop.triangle", tintColor: .red, amount: "\(glucoseLevelMmol) ммол/Л")
                
                DispatchQueue.main.async {
                    self.activites["bloodGlucose"] = glucoseActivity
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchBodyTemperature() {
        let temperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature)!
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: temperatureType, quantitySamplePredicate: predicate, options: .mostRecent) { _, result, error in
            guard let result = result, error == nil else {
                print("Error fetching body temperature data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let quantity = result.mostRecentQuantity() {
                // Get temperature in Celsius
                let temperatureCelsius = quantity.doubleValue(for: HKUnit.degreeCelsius())
                
                let temperatureActivity = Activity(id: 10, title: "Температура тела", subtitle: "Текущий", image: "thermometer", tintColor: .orange, amount: "\(Int(temperatureCelsius))°C")
                
                DispatchQueue.main.async {
                    self.activites["bodyTemperature"] = temperatureActivity
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchHeartRateData() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, error in
            guard let result = result, error == nil else {
                print("Error fetching heart rate data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let averageHeartRate = result.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) ?? 0.0
            
            let heartRateActivity = Activity(id: 10, title: "Пульс", subtitle: "Средний", image: "heart.fill", tintColor: .red, amount: "\(Int(averageHeartRate)) BPM")
            
            DispatchQueue.main.async {
                self.activites["heartRate"] = heartRateActivity
            }
        }
        
        healthStore.execute(query)
    }






    
    func fetchCurrentWeekWorkoutStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: timePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("error fetching week running data")
                return
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0
            for workout in workouts {
                if workout.workoutActivityType == .running {
                    let duration = Int(workout.duration)/60
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    let duration = Int(workout.duration)/60
                    strengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    let duration = Int(workout.duration)/60
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    let duration = Int(workout.duration)/60
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    let duration = Int(workout.duration)/60
                    stairsCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    let duration = Int(workout.duration)/60
                    kickboxingCount += duration
                }
            }
            
            let runningActivity = Activity(id: 2, title: "Running", subtitle: "This week", image: "figure.walk", tintColor: .green, amount: "\(runningCount) minutes")
            let strengthActivity = Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", tintColor: .cyan, amount: "\(strengthCount) minutes")
            let soccerActivity = Activity(id: 4, title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .blue, amount: "\(soccerCount) minutes")
            let basketballActivity = Activity(id: 5, title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .orange, amount: "\(basketballCount) minutes")
            let stairActivity = Activity(id: 6, title: "Stair Stepper", subtitle: "This week", image: "figure.stair.stepper", tintColor: .green, amount: "\(stairsCount) minutes")
            let kickboxActivity = Activity(id: 7, title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "\(kickboxingCount) minutes")
            
            DispatchQueue.main.async {
                self.activites["weekRunning"] = runningActivity
                self.activites["weekStrength"] = strengthActivity
                self.activites["weekSoccer"] = soccerActivity
                self.activites["weekBasketball"] = basketballActivity
                self.activites["weekStairs"] = stairActivity
                self.activites["weekKickbox"] = kickboxActivity
            }
        }
        healthStore.execute(query)
    }
    
}

    // MARK: Chart Data
extension HealthManager {
    
    func fetchPastWeekStepData() {
        fetchDailySteps(startDate: .oneWeekAgo) { dailySteps in
            DispatchQueue.main.async {
                self.oneWeekChartData = dailySteps
            }
        }
    }
    
    func fetchPastMonthStepData() {
        fetchDailySteps(startDate: .oneMonthAgo) { dailySteps in
            DispatchQueue.main.async {
                self.oneMonthChartData = dailySteps
            }
        }
    }
    
    func fetchPastThreeMonthsStepData() {
        fetchDailySteps(startDate: .threeMonthsAgo) { dailySteps in
            DispatchQueue.main.async {
                self.threeMonthChartData = dailySteps
            }
        }
    }
    
    func fetchYearToDateStepData() {
        fetchDailySteps(startDate: .yearToDate) { dailySteps in
            DispatchQueue.main.async {
                self.yearToDateChartData = dailySteps
            }
        }
    }
    
    func fetchPastYearStepData() {
        fetchDailySteps(startDate: .oneYearAgo) { dailySteps in
            DispatchQueue.main.async {
                self.oneYearChartData = dailySteps
            }
        }
    }
    
    
    
}
