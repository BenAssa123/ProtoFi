//
//  AddProtocolView.swift
//  PookPool
//
//  Created by Assa Bentzur on 08/06/2022.
//

import SwiftUI

struct AddProtocolView: View {
    // MARK: Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProtocolPook.name, ascending: true)],
        animation: .default)
    
    private var protocols: FetchedResults<ProtocolPook>
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var access: String = "Private"
    
    let accessibility: [String] = ["Private", "Public"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    
    // MARK: Body
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Protocol name
                    TextField("Protocol Name", text: $name)
                        .padding()
                        .border(.tertiary, width: 5)
                        .background(Color(UIColor.systemCyan).opacity(0.4))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    // MARK: Todo Accessibility
                    Picker("Accessibility", selection: $access) {
                        ForEach(accessibility, id: \.self) {
                            Text($0) // $0 is the first parameter passed into the closure
                        } //: Foreach
                    } //: Picker
                    .pickerStyle(SegmentedPickerStyle())
                    .background(.quaternary)
                    .cornerRadius(8)
                    
                    // MARK: Add Protocol Description
                    Text("General Description:")
                        .padding(.top)
                        .font(.title3)
                    TextEditor(text: $description)
                        .frame(minHeight: 40, idealHeight: 150, maxHeight: 250, alignment: .center)
                        .padding()
                        .background(Color(UIColor.lightGray))
                        .cornerRadius(9)
                        .font(.system(size: 15, weight: .regular, design: .default))
                    
                    // TODO: Add Protocol Comments
                    
                    // TODO: Add Protocol Links
                    
                    // TODO: Link to other Protocols?
                    
                    //MARK: Save button
                    Spacer()
                    Button(action: {
                        if self.name != "" {
                            let protocolpook = ProtocolPook(context: self.managedObjectContext)
                            protocolpook.name = self.name
                            protocolpook.generalDescription = self.description
                            protocolpook.id = UUID()
                            protocolpook.timeStamp = Date()
                            do {
                                try self.managedObjectContext.save()
                                //print("new todo: \(todo.name ?? ""), Priority: \(todo.priority ?? "")")
                            } catch {
                                print(error)
                            }
                        } else { // toggle the alert window
                            self.errorShowing = true
                            self.errorTitle = "Invalid Name"
                            self.errorMessage = "Make sure to enter a name"
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss() // closeing the AddTodoView after saving
                    }) {
                        Text("Save")
                            .font(.system(size: 24,weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity) // Stretches button over all of screen
                            .background(self.name != "" ? Color.blue : Color.gray)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)

                    }//:Save button
                }//: Vstack
                .padding(.horizontal)
                .padding(.vertical, 30)
            } //: Scroll View
            }//: Vastack
            .navigationTitle("Create new Protocol")
            .font(.title2)
            .navigationBarTitleDisplayMode(.large)
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

struct AddProtocolView_Previews: PreviewProvider {
    static var previews: some View {
        AddProtocolView()
    }
}
