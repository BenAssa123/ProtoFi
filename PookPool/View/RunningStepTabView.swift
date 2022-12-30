//
//  RunningStepTabView.swift
//  PookPool
//
//  Created by Assa Bentzur on 26/07/2022.
//

import SwiftUI
import CoreData

struct RunningStepTabView: View {
        @Environment(\.managedObjectContext) private var viewContext
        @EnvironmentObject var lnManager: LocalNotificationManager
        //@EnvironmentObject var protoFi: ProtoFi
        
        @State var items: [Item]
        
        @Binding var isDone: [Bool]
        
        @State var firstStep: Int // get the first step to show
        
        @State var timerTime: [Double]
        @State var runningTime: Double = 0
        @State var initiatedTimerStep: Int = 0
        @State var timerRuning: Bool = false
        
        @State var errorShowing: Bool = false
        @State var addRunStepComment: Bool = false // for adding comments during run
        
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
                    // MARK: Done Button
                            Button(action: {
                                isDone[num].toggle()
                                self.hapticImpact.impactOccurred()
                            }) {
                                Image(uiImage: (isDone[num] ? UIImage(systemName:"checkmark.square") : UIImage(systemName:"square"))!)
                                    .resizable()
                                    .frame(minWidth: 20, idealWidth: 30, maxWidth: 40, minHeight: 20, idealHeight: 30, maxHeight: 40, alignment: .center)
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(isDone[num] ? .blue : .black)
                            .font(.title2)
                            //.padding()
//                            .padding(.top, 20)
//                            .padding(.horizontal, 40)
//                            .padding(.bottom, 20)
                            .background(isDone[num] ? .green : .secondary)
                            .cornerRadius(8)
                            //Spacer()
                    
                    Spacer(minLength: 35)
                } //: vstack
                .background(isDone[num] ? .cyan : .clear)
                .cornerRadius(5)
                .tag(Int(item.stepnumber))
                    // MARK: Add comment
                .sheet(isPresented: $addRunStepComment, content: {
                    AddRunCommentView(protocolName: "item.parent!", stepNumber: 1)
                    })
                } //: foreach
            } //: Tabview
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addRunStepComment = true
                    }) {
                        Label("Comment", systemImage: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                    .buttonStyle(.borderedProminent)
                }
            } //: toolbar
        } //: Body
}

//struct RunningStepTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        RunningStepTabView(items: Item(), isDone: , firstStep: , timerTime: )
//    }
//}
