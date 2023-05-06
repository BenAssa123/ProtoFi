//
//  Pook.swift
//  PookPool
//
//  Created by Assa Bentzur on 07/07/2022.
//

import Foundation
import SwiftUI
import CoreData

class StopWatchManager: ObservableObject {
    
    var secondsElapsed: Int = 0
//    var timer: Timer = Timer()
    
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    
    @Published var timeRemaining: Double = 0
    @Published var timerDone: Bool = false
    
    @Published var stepNumber: Int64 = 0
    @Published var parent: String = ""
    
    @Published var startDate: UserDefaults = UserDefaults.init()
    @Published var pauseDate: UserDefaults = UserDefaults.init()

    func start_timer(time: Double, stepNumber: Int64, parent: String) {
        self.timerDone = false
        self.isRunning = true
        if isPaused == false {
            self.stepNumber = stepNumber
            self.parent = parent
            timeRemaining = time
            startDate.set(Date(), forKey: "TimerStartDate")
        } else if isPaused == true { // if timer was paused substract the time paused form initial time (resume after pause):
            let deltaTime = (startDate.value(forKey: "TimerStartDate") as! Date).timeIntervalSince(pauseDate.value(forKey: "TimerPauseDate") as! Date)
            
            startDate.set(Date().addingTimeInterval(_: deltaTime), forKey: "TimerStartDate")
            pauseDate.removeObject(forKey: "TimerPauseDate")
            isPaused = false
        }
        // timer is not used when date is used
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//            self.secondsElapsed += 1
//            self.timeRemaining = time - Double(self.secondsElapsed)
//            if self.timeRemaining <= 0 {
//                self.timeRemaining = 0
//                self.isRunning = false
//                self.timerDone = true
//            }
//        }
    }

    func stop_timer() {
        isRunning = false
        isPaused = false
//        timer.invalidate()
        secondsElapsed = 0
        timeRemaining = 0
        startDate.removeObject(forKey: "TimerStartDate")
        pauseDate.removeObject(forKey: "TimerPauseDate")
        timerDone = true
    }

    func pause_timer() {
        isRunning = false
        isPaused = true
        pauseDate.set(Date(), forKey: "TimerPauseDate")
//        timer.invalidate()
    }
    
    func formatTime(timerTime: Double) -> [Double] {
        var formattedTime: [Double] = [0, 0, 0]
        let timerTimeSeconds = timerTime.truncatingRemainder(dividingBy: 60)
        var timerTimeMinutes: Double = 0
        var timerTimeHoures: Double = 0
        if timerTime >= 0 {
             timerTimeMinutes = (timerTime/60).rounded(.down)
             timerTimeHoures = (timerTimeMinutes/60).rounded(.down)
            if timerTimeHoures > 1 {
                timerTimeMinutes = timerTimeMinutes.truncatingRemainder(dividingBy: 60)
            }
        } else { // when time turns negative
             timerTimeMinutes = (timerTime/60).rounded(.up)
             timerTimeHoures = (timerTimeMinutes/60).rounded(.up)
            if timerTimeHoures < -1 {
                timerTimeMinutes = timerTimeMinutes.truncatingRemainder(dividingBy: 60)
            }
        }
        formattedTime[0] = timerTimeSeconds
        formattedTime[1] = timerTimeMinutes
        formattedTime[2] = timerTimeHoures
        
        return formattedTime
    }
}
