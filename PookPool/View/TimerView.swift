//
//  TimerView.swift
//  PookPool
//
//  Created by Assa Bentzur on 05/07/2022.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var lnManager: LocalNotificationManager
    //@EnvironmentObject var timer: TimerModel
    @EnvironmentObject var stopWatch: StopWatchManager
    @EnvironmentObject var protoFi: ProtoFi
    
    //let timerCount = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    let StartTimeTimer: Double
    @State var timerTime: Double = 0
    @State var formattedTime: [Double] = [0, 0, 0]
    @State var isRunning: Bool = false
    @State var started: Bool = false // if timer was initialized
    
    @State var alertIsShowing: Bool = false
    
    let step: Item
    
    var body: some View {
        VStack {
            if timerTime >= 0 {
                Text(started ? "\(Int(stopWatch.formatTime(timerTime:(stopWatch.startDate.value(forKey: "TimerStartDate") as! Date).timeIntervalSinceNow +  StartTimeTimer)[2].rounded())):\(Int(stopWatch.formatTime(timerTime:(stopWatch.startDate.value(forKey: "TimerStartDate") as! Date).timeIntervalSinceNow +  StartTimeTimer)[1].rounded())):\(Int(stopWatch.formatTime(timerTime:(stopWatch.startDate.value(forKey: "TimerStartDate") as! Date).timeIntervalSinceNow + StartTimeTimer)[0].rounded()))"
                     : "\(Int(stopWatch.formatTime(timerTime:StartTimeTimer)[2].rounded())):\(Int(stopWatch.formatTime(timerTime: StartTimeTimer)[1].rounded())):\(Int(stopWatch.formatTime(timerTime: StartTimeTimer)[0].rounded()))")
                    .font(.system(size: 30, weight: .heavy, design: .default))
                    .frame(width: 180, height: 100, alignment: .center)
                    .background(isRunning ? .green : .gray)
                    .cornerRadius(30)
                    .animation(.interactiveSpring(), value: isRunning)
                    .padding(.bottom, 10)
            } else {
                // TODO: Save how much overtime happened in this step to documentation
                Text(started ? "\(Int(0))" : "\(Int(StartTimeTimer.rounded()))")
                    .font(.system(size: 60, weight: .heavy, design: .default))
                    .foregroundColor(stopWatch.timerDone ? .red : .black)
                    .frame(width: 150, height: 150, alignment: .center)
                    .background(isRunning ? .green : .gray)
                    .cornerRadius(30)
                    .animation(.interactiveSpring(), value: isRunning)
                    .padding(.bottom, 10)
            }
            HStack {
                // MARK: Start/Stop Button
                Button(action: {
                    if (protoFi.protocolRunning.value(forKey: "isPookRunning") != nil) && (protoFi.protocolRunning.value(forKey: "PookID") != nil) {
                        if stopWatch.isRunning || stopWatch.isPaused { // check if timer working
                            if stopWatch.stepNumber == step.stepnumber { // only allow access if it is the step that  initiated the timer
                                if isRunning == false {
                                    stopWatch.start(time: StartTimeTimer, stepNumber: step.stepnumber, parent: step.parent ?? "")
                                    //timerTime = stopWatch.timeRemainingByDate // changed this from timeRemaining
                                    timerTime = (stopWatch.startDate.value(forKey: "TimerStartDate") as! Date).timeIntervalSinceNow + StartTimeTimer
                                    isRunning = stopWatch.isRunning
                                    started = true
                                    self.hapticImpact.impactOccurred()
                                    if timerTime > 0 {
                                        Task { // Set Notification
                                            let localNotification = LocalNotification(identifier: UUID().uuidString, title: "Timer Done!", body: "After \(Int(timerTime.rounded())) seconds in Step \(step.stepnumber)", timeInterval: timerTime, repeats: false)
                                            await lnManager.schedule(localNotification: localNotification)
                                        } //: Set Notification
                                    } //: if
                                } else {
                                    stopWatch.pause()
                                    isRunning = stopWatch.isRunning
                                    self.hapticImpact.impactOccurred()
                                    lnManager.clearRequests() // Remove notification
                                }
                            }
                        } else {
                            if isRunning == false {
                                stopWatch.start(time: StartTimeTimer, stepNumber: step.stepnumber, parent: step.parent ?? "")
                                timerTime = stopWatch.timeRemaining
                                isRunning = stopWatch.isRunning
                                started = true
                                self.hapticImpact.impactOccurred()
                                if timerTime > 0 {
                                    Task { // Set Notification
                                        let localNotification = LocalNotification(identifier: UUID().uuidString, title: "Timer Done!", body: "After \(Int(timerTime.rounded())) seconds in Step \(step.stepnumber)", timeInterval: timerTime, repeats: false)
                                        await lnManager.schedule(localNotification: localNotification)
                                    } //: Set Notification
                                } //: if
                            } else {
                                stopWatch.pause()
                                isRunning = stopWatch.isRunning
                                lnManager.clearRequests() // Remove notification
                            }
                        }
                    } else {
                        alertIsShowing = true
                    }
                }, label: {
                    isRunning ? Text("Pause") : Text("Start")
                })
                .animation(.interactiveSpring(), value: isRunning)
                .foregroundColor(isRunning ? .red : .white)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .padding()
                .padding(.horizontal, 30)
                .background(.blue)
                .opacity(1.5)
                .cornerRadius(10)
                .alert(isPresented: $alertIsShowing) {
                    Alert(
                        title: Text("Timer Disabled"),
                    message: Text("Start Protocol to enable timer"),
                        dismissButton: .default(Text("OK"))
                    )}
                // MARK: Reset Button
                if isRunning == false && started {
                    Button(action: {
                        stopWatch.stop()
                        started = false
                        lnManager.clearRequests() // Remove notification
                    }, label: {
                         Text("Reset")
                    })
                    .animation(.interactiveSpring(), value: isRunning)
                    .foregroundColor(.black)
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .padding()
                    .padding(.horizontal, 30)
                    .background(.gray)
                    .opacity(1.5)
                    .cornerRadius(10)
                }
            } //: Hstack
        } //: Vstack
    }
}

//struct TimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerView(StartTimeTimer: 10, step: Item())
//    }
//}
