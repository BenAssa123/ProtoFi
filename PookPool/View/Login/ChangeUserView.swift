//
//  ChangeUserView.swift
//  ProtoFi
//
//  Created by Assa Bentzur on 27/08/2022.
//

import SwiftUI

struct ChangeUserView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var isLoggedIn: Bool // TODO: change to user defaults to save state
    
    @State var newUserName: String = ""
    @State var newUserPassword: String = ""
    
    var body: some View {
        VStack {
            Text("ProtoFi")
                .font(.largeTitle)
                .bold()
                .padding()
                    
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
            
            Spacer()
            
            Button(action: {
                isLoggedIn = true  // TODO: change the login state in user defaults
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
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Change User")
                    .padding()
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .background(.mint)
            }
            .cornerRadius(8)
            .padding(.horizontal)
            // TODO: Make Login Real
        } //: VStack
        
    }
}

struct ChangeUserView_Previews: PreviewProvider {
    @State var isLoggedIn: Bool = true
    static var previews: some View {
        ChangeUserView(isLoggedIn: false)
    }
}
