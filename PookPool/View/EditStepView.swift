//
//  AddStepView.swift
//  PookPool
//
//  Created by Assa Bentzur on 13/07/2022.
//

import SwiftUI
import CoreData

struct EditStepView: View {
    
    // MARK: Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
        
    // This should not be changed:
    let stepNumber: Int64
    let parent: String
    // variables to change in step:
    @State var description: String
    @State var comment: String
    @State var timer: Double
    
    // error if step description is empty:
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
       
        //MARK: Body
    var body: some View {
            NavigationView {
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        ScrollView {
                        // MARK: Protocol name:
                        Text("\(parent)")
                            .underline()
                            .font(.title)
                            .opacity(0.5)
                            .multilineTextAlignment(.center)
                        //MARK: Step Description
                        Text("Edit Description:")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            
                        TextEditor(text: $description) // input text goes into name var
                            .frame(minHeight: 30, idealHeight: 150, maxHeight: 250, alignment: .center)
                            .padding()
                            .background(Color(UIColor.systemCyan))
                            .cornerRadius(9)
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .multilineTextAlignment(.leading)
                            
                            Spacer(minLength: 20)
                            
                        // MARK: Step Comments
                        Text("Edit Comments:")
                        TextEditor(text: $comment) // input text goes into name var
                            .frame(minHeight: 30, idealHeight: 50, maxHeight: 150, alignment: .center)
                            .padding()
                            .background(Color(UIColor.lightGray))
                            .cornerRadius(9)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .multilineTextAlignment(.leading)
                        
                        // TODO: Add Links
                        // TODO: Timer time
                            
                            Spacer(minLength: 10)
                        HStack {
                            Spacer()
                            Text("Edit Timer:")
                            TextField(
                                   "Seconds",
                                   value: $timer,
                                   format: .number
                            )
                            .multilineTextAlignment(.center)
                            .textFieldStyle(.roundedBorder)
                            .border(.tertiary)
                            .border(.gray, width: 1.5)
                            .cornerRadius(4)
                            .padding(.horizontal, 70)
                            
                            Spacer()
                        } //: Hstack

                        // TODO: Media - Audio, Video, Picture
                        } //: Scroll View
                        // MARK: Save button
                        Button(action: {
                            if self.description != "" {
                                Item.editStep(parent, stepnumber: stepNumber, newTimer: timer, newComment: comment, newDescription: description, context: managedObjectContext)
                                managedObjectContext.refreshAllObjects()
                            } else { // toggle the alert window
                                self.errorShowing = true
                                self.errorTitle = "Invalid Step"
                                self.errorMessage = "Enter a Descrption!"
                                return
                            }
                            self.presentationMode.wrappedValue.dismiss() // closeing the AddTodoView after saving
                        }) {
                            Text("Save Changes")
                                .font(.system(size: 24,weight: .bold, design: .default))
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity) // Stretches button over all of screen
                                .background(Color.blue)
                                .cornerRadius(9)
                                .foregroundColor(Color.white)

                        }//:Save button
                        .buttonStyle(.bordered)
                    }//: Vstack
                    .padding(.horizontal)
                    .padding(.vertical, 30)
     
                }//: Vastack
                .navigationTitle("Edit Step \(stepNumber)")
                .font(.title2)
                .navigationBarTitleDisplayMode(.automatic)
                .navigationBarItems(trailing:
                 Button(action: { // Closing the sheet when user taps
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Label("Dismiss", systemImage: "trash")
                })
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $errorShowing) { // showing the alert message when no input is used to save
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }//: Navigation
        }
    }


struct EditStepView_Previews: PreviewProvider {
    static var previews: some View {
        EditStepView(stepNumber: 1, parent: "Pook", description: "", comment: "", timer: 2.0)
    }
}
