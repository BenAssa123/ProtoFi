//
//  StepTabView.swift
//  PookPool
//
//  Created by Assa Bentzur on 23/05/2022.
//

import SwiftUI
import CoreData
// TODO: Maybe replace tabView to step view that changes with swipe action
struct StepTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    @State var items: [Item]
    
    @State var firstStep: Int // get the first step to show
    
    @State var timerTime: [Double]
    @State var runningTime: Double = 0
    @State var initiatedTimerStep: Int = 0
    @State var timerRuning: Bool = false
    
    @State var isEditing: Bool = false
    @State var errorShowing: Bool = false
    
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        TabView(selection: $firstStep) {
            ForEach(items) { item in
                let num: Int = Int(item.stepnumber) - 1 // this is the array index for the current step
            VStack {
                Text("Step  \(item.stepnumber)")
                    .font(.title3)
                    .underline()
                    .frame(width: 500.0) // so that the background color will cover most of the screen
                Spacer()
                ScrollView {
                Text(item.stepdescription ?? "No Description")
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
                Text(item.stepcomment ?? "No Comments")
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
      
                // MARK: Timer
                    if timerTime[num] > 0 {
                    VStack {
                        Text("Timer:")
                            .underline()
                        TimerView(StartTimeTimer: timerTime[num], step: item)
                    }
                        .padding()
                        .background(.tertiary)
                        .cornerRadius(8)
                } else {
                    IsTimerRunningView()
                }
                } //: ScrollView
                Spacer(minLength: 35)
            } //: vstack
            .background(.clear)
            .cornerRadius(5)
            .tag(Int(item.stepnumber))
            .sheet(isPresented: $isEditing, content: {
                    EditStepView(stepNumber: item.stepnumber, parent: item.parent!, description: item.stepdescription!, comment: item.stepcomment ?? "No Comment", timer: item.timer)
                })
            } //: foreach
        } //: Tabview
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                        isEditing.toggle()
                }) {
                    Text("Edit")
                        .foregroundColor(.cyan)
                }
                .buttonStyle(.borderedProminent)
            }
        } //: toolbar
    } //: Body
}

//struct StepTabView_Previews: PreviewProvider {
//    let item: Item = Item()
//    @State var isDone: [Bool] = [false, true]
//    static var previews: some View {
//        StepTabView(items: [Item()], isDone: , firstStep: 1,  timerTime: [1.0])
//    }
//}
