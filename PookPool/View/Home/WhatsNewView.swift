//
//  WhatsNewView.swift
//  ProtoFi
//
//  Created by Assa Bentzur on 23/08/2022.
//

import SwiftUI

struct WhatsNewView: View {
    var body: some View {
        VStack {
            Text("What's New:")
                .font(.largeTitle)
                .padding()
            Form {
                HStack {
                    Text("Calculator")
                    Spacer()
                    Image(systemName: "function")
                        .resizable()
                        .frame(width: 45, height: 30, alignment: .center)
                        .foregroundColor(.gray)
                }
            HStack {
                Text("Image to Steps")
                Spacer()
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 40, height: 30, alignment: .center)
                    .foregroundColor(.gray)
            }
            } //: Form
            HStack {
                Image(systemName: "hare.fill")
                Spacer()
                Image(systemName: "tortoise.fill")
            } //: HStack
        } //: VStack
        .background(.quaternary)
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView()
    }
}
