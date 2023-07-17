//
//  PookPoolApp.swift
//  PookPool
//
//  Created by Assa Bentzur on 22/05/2022.
//

import SwiftUI

@main
struct PookPoolApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var lnManager = LocalNotificationManager()
    @StateObject var timer = TimerModel() // start counting every second. then i can calculate the difference between this number and the end date for each timer I want to set
    // TODO: add another timer model for second timer? probably best to start more timers in one class
    @StateObject var stopWatch = StopWatchManager()  // is this necessary?
    @StateObject var protoFi = ProtoFi()
    @StateObject var photoPicker = PhotoPickerManager()
    @StateObject var recognizeTextManager = RecognizeTextManager()
    @StateObject var calculator = Calculator()
    @StateObject var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(lnManager)
                .environmentObject(timer)
                .environmentObject(stopWatch)
                .environmentObject(protoFi)
                .environmentObject(photoPicker)
                .onAppear {
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
                .environmentObject(recognizeTextManager)
                .environmentObject(calculator)
                .environmentObject(userManager)
        }
    }
}
