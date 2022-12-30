//
//  AddStepView.swift
//  PookPool
//
//  Created by Assa Bentzur on 22/05/2022.
//

import SwiftUI
import CoreData

struct AddTodoView: View {
    // MARK: Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext // connects to the ContentView managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    @State private var description: String = ""
    @State private var comment: String = ""
    @State private var access: String = "Private"
    @State var timer: Double
    
    @State var timerUnitsPicker: Int = 0
    let timerUnits: [String] = ["Seconds", " Minutes", "Hours"]
   
    @State var parent: String
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    //MARK: Body
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    ScrollView {
                    // MARK: Protocol name:
                    Text("\(parent)")
                        .font(.body)
                        .opacity(0.5)
                    //MARK: Step Description
                    Text("Description:")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        
                    TextEditor(text: $description)
                        .frame(minHeight: 30, idealHeight: 150, maxHeight: 250, alignment: .center)
                        .padding()
                        .background(.quaternary)
                        //.cornerRadius(8)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .multilineTextAlignment(.leading)
                        
                        Spacer(minLength: 40)
                        
                    // MARK: Step Comments
                        
                    Text("Comments:")
                    TextEditor(text: $comment)
                        .frame(minHeight: 30, idealHeight: 50, maxHeight: 150, alignment: .center)
                        .padding()
                        .background(.quaternary)
                        //.cornerRadius(8)
                        .multilineTextAlignment(.leading)
                    
                    // TODO: Add Links
                    // TODO: Timer time
                        Spacer(minLength: 30)
                    HStack {
                        Text("Set Timer:")
                        Spacer()
                        TextField(
                               "\(timerUnits[timerUnitsPicker])",
                               value: $timer,
                               format: .number
                        )
                        .frame(width: 100, alignment: .center)
                            .multilineTextAlignment(.center)
                            .border(.gray, width: 0.5)
                            .padding(.horizontal)
                            .keyboardType(.numberPad)
                        
                        Spacer()
                        
                        Picker("Units", selection: $timerUnitsPicker) {
                            ForEach(timerUnits, id: \.self) {
                                Text($0)
                            } //: Foreach
                        } //: Picker
                        .pickerStyle(.menu)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(.quaternary)
                        .cornerRadius(4)
                        // TODO: Save timer units to step and use this for timer
                        Spacer()
                    } //: Hstack

                    // TODO: Media - Audio, Video, Picture
                    
                    // MARK: Save button
                    Button(action: {
                        if self.description != "" {
                            let step = Item(context: self.managedObjectContext)
                            step.stepdescription = self.description
                            step.stepcomment = self.comment
                            step.timer = self.timer
                            step.stepnumber = Int64(Item.getSteps(parent, context: managedObjectContext).count + 1)
                            step.parent = parent
                            do {
                                try self.managedObjectContext.save()
                                managedObjectContext.refreshAllObjects() // update view
                            } catch {
                                print(error)
                            }
                        } else { // toggle the alert window
                            self.errorShowing = true
                            self.errorTitle = "Invalid Step"
                            self.errorMessage = "Make sure to enter something in\nthe Descrption !"
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss() // closeing the AddTodoView after saving
                    }) {
                        Text("Save")
                            .font(.system(size: 24,weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity) // Stretches button over all of screen
                            .background(Color.blue)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)

                    }//:Save button
                }//: Vstack
                .padding(.horizontal)
                .padding(.vertical, 30)
                } //: Scroll View
            }//: Vastack
            .navigationTitle("Create new Step")
            .font(.title2)
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(trailing:
             Button(action: { // Closing the sheet when user taps
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            }
            )
            .alert(isPresented: $errorShowing) { // showing the alert message when no input is used to save
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }//: Navigation
    }
}
//MARK: Preview
//struct AddTodoView_Previews: PreviewProvider {
//    @Binding var isDone: [Bool]
//    static var previews: some View {
//        AddTodoView(isDone: $isDone, timer: 2.0, parent: "Pook")
//    }
//}
