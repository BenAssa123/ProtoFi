//
//  ProfileView.swift
//  ProtoFi
//
//  Created by Assa Bentzur on 23/08/2022.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .padding()
                .font(.title)
            
            Form {
                HStack {
                    Text("User Name:")
                    Spacer()
                    Text("Assa Bentzur")
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("Profile Details")
                    Spacer()
                    Image(systemName: "person.fill.questionmark")
                        .resizable()
                        .frame(width: 35, height: 30, alignment: .center)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("Projects")
                    Spacer()
                    Image(systemName: "camera.filters")
                        .resizable()
                        .frame(width: 35, height: 35, alignment:      .center)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("Reset Password")
                    Spacer()
                    Image(systemName: "person.badge.key.fill")
                        .resizable()
                        .frame(width: 35, height: 30, alignment: .center)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("Log Out")
                    Spacer()
                    Image(systemName: "person.fill.badge.minus")
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .center)
                        .foregroundColor(.gray)
                }
            } //: Form
            HStack {
                Image(systemName: "ladybug.fill").rotationEffect(.degrees(90))
                Spacer()
                Image(systemName: "leaf").rotationEffect(.degrees(-90))
            } //: HStack
        } //: Vstack
        .background(.quaternary)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
