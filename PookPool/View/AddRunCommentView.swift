//
//  AddRunCommentView.swift
//  PookPool
//
//  Created by Assa Bentzur on 25/07/2022.
//

import SwiftUI

struct AddRunCommentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var protoFi: ProtoFi
    
    let protocolName: String
    let stepNumber: Int
    
    @State var comment: String = ""
    
    var body: some View {
        VStack {
            Text("Add comment for this step (it will be saved in 'Saved Runs')")
            
            TextField("Step comment", text: $comment)
            
            Button(action: {
                SavedRuns.addStepComment(protocolID: UUID(uuidString: protoFi.protocolID.object(forKey: "PookID") as! String)!, protocolName: protocolName, stepComment: comment, stepNumber: stepNumber, context: viewContext)
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            }
        } //: Vstack
    } //: Body
}

struct AddRunCommentView_Previews: PreviewProvider {
    static var previews: some View {
        AddRunCommentView(protocolName: "Pook", stepNumber: 2)
    }
}
