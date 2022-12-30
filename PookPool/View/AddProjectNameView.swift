//
//  AddProjectNameView.swift
//  PookPool
//
//  Created by Assa Bentzur on 16/08/2022.
//

import SwiftUI

struct AddProjectNameView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var protoFi: ProtoFi
    
    @Binding var projectName: String
    
    let protocolName: String
    let ID: UUID
    
    var body: some View {
        VStack {
            Spacer()
            Text("Add Project name:")
                .font(.title2)
                .bold()
                .underline()
                .padding()
            
            Spacer()
            
            // TODO: selection list of all projects and ability to add new one
            
            TextField("Project Name", text: $projectName)
                .font(.body)
                .padding()
                .border(.gray, width: 2)
                .padding()
            
            Spacer()
            
            Button(action: {
                SavedRuns.startRun(protocolName: protocolName, ID: ID, project: projectName, context: viewContext)
                protoFi.startProtocol(Id: ID, name: protocolName)
                
                self.presentationMode.wrappedValue.dismiss()
                protoFi.objectWillChange.send() // to update the previous view
            }) {
                Text("Save")
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            Spacer()
        } //: VStack
    }
}

//struct AddProjectNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddProjectNameView()
//    }
//}
