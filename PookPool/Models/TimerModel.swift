//
//  TimerManager.swift
//  PookPool
//
//  Created by Assa Bentzur on 06/07/2022.


import Foundation
import SwiftUI

class TimerModel: ObservableObject {
    @EnvironmentObject var lnManager: LocalNotificationManager

    //let startDate: Date = Date()
    //var currentDate: Date = Date()
    var isRunning: Bool = false
    //let totalTime: Double = 0.0
    //var timeRemainig: Double = 0.0



    func startTimer(totalTime: Double) async -> Double {
      //let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
      let startDate = Date()
      isRunning = true
        let timeRemainig = totalTime - Double(startDate.timeIntervalSinceNow)

        // send notification:
       let localNotification = LocalNotification(identifier: UUID().uuidString, title: "Timer Done!", body: "After \(Int(totalTime.rounded())) seconds", timeInterval: timeRemainig, repeats: false)
            await lnManager.schedule(localNotification: localNotification)

        return timeRemainig
    }

  

//    func pauseTimer() {
//        _ = false
//
//        // delete notification
//    }
//
//    func resumeTimer(timeRemaining: Double) {
//        var isRunning = true
//
//        // send notification
//    }
}

