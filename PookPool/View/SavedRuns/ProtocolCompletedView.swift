//
//  ProtocolCompletedView.swift
//  PookPool
//
//  Created by Assa Bentzur on 22/06/2022.
//

import SwiftUI

struct ProtocolCompletedView: View {
    // MARK: Properties
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var protoFi: ProtoFi
    
    let name: String
    let projectName: String
    @Binding var isDone: [Bool]
    @Binding var isProtocolRunning: Bool
    @Binding var protocolStarted: Bool
    
    @State private var comment: String = ""
    
    // MARK: Body
    var body: some View {
        VStack {
            Text("Protocol Name: \n\(name)")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            
            if projectName.count > 0 {
                Text("Project Name: \n\(projectName)")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
            }
            Text("Add Comments:")
                .font(.title3)
            
            TextEditor(text: $comment)
                .padding(12)
                .background(.quaternary)
                .cornerRadius(9)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .multilineTextAlignment(.leading)
                .frame(minHeight: 180, idealHeight: 200, maxHeight: 250, alignment: .center)
                .keyboardShortcut(.defaultAction)
            Spacer()
            // TODO: Add picture
            
            Button(action: {
                SavedRuns.saveRun(name, ID: UUID(uuidString: protoFi.protocolID.value(forKey: "PookID") as! String)!, comments: comment, context: viewContext)
                
                protoFi.stopProtocol(name: name)
                
                 isProtocolRunning = false
                 protocolStarted = false
                
                isDone.removeFirst(Item.getSteps(name, context: viewContext).count) // reset done step array
                
                self.presentationMode.wrappedValue.dismiss() // closeing the AddTodoView after saving
            }) {
                Text("Save")
                    .font(.system(size: 24,weight: .bold, design: .default))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Stretches button over all of screen
                    .background(Color.blue)
                    .cornerRadius(9)
                    .foregroundColor(Color.white)
                    .padding(10)
                    
            }
    } //: Vstack
}
}

// MARK: Preview
//struct ProtocolCompletedView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProtocolCompletedView(name: "Pook")
//    }
//}
