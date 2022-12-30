//
//  ChangeUserView.swift
//  ProtoFi
//
//  Created by Assa Bentzur on 27/08/2022.
//

import SwiftUI

struct ChangeUserView: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    @State var newUserName: String = ""
    @State var newUserPassword: String = ""
    
    var body: some View {
        VStack {
            Text("ProtoFi")
                .font(.title)
                .padding()
            //Spacer()
            TextField("User Name", text: $newUserName)
                .font(.title3)
                .padding(.horizontal)
                .padding()
                .background(.quaternary)
                .cornerRadius(8)
                .padding(.top)
            TextField("Password", text: $newUserPassword)
                .font(.title3)
                .padding(.horizontal)
                .padding()
                .background(.quaternary)
                .cornerRadius(8)
                .padding(.bottom)
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Log In")
                    .padding()
                    .font(.title)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            
            Spacer()
            
            Text("Change User")
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .background(.mint)
                .font(.title.bold())
                .cornerRadius(8)
                .padding()
            //Spacer()
            // TODO: Make Login Real
        } //: VStack
        
    }
}

struct ChangeUserView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeUserView()
    }
}
