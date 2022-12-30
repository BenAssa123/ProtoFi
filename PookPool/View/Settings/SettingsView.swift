//
//  SettingsView.swift
//  PookPool
//
//  Created by Assa Bentzur on 22/06/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    // TODO: choose accent color, present my information, whether done step goes automatically to next step or not
    @State private var enableNotifications: Bool = false
    
    @State private var isDark: Bool = false
    
    private var Theme: [String] = ["Normal", "Red", "Green", "Blue", "High Contrast"]
    
    @State  private var themePicker: Int = 0
    
    @State private var emailIsShowing: Bool = false
    
    @State private var autoMove: Bool = false
    
    @State var profileIsShowing: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
//            Text("ProtoFi")
//                .font(.system(.title2, design: .monospaced))
//                .bold()
//                .padding()
//                .shadow(color: .gray, radius: 8, x: 0, y: 4)
            ZStack {
        Form {
            Section(header: Text("Settings").font(.body).foregroundColor(.black)) {
                if lnManager.isGranted == false {
                Button("Tap to Enable Notifications") {
                     lnManager.openSettings()
                     enableNotifications.toggle()
                    }
                .font(.title2)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(8)
                }
            }
            Toggle(isOn: $isDark) {
                Text("Dark Mode")
            }
            Toggle(isOn: $autoMove) {
                Text("Auto-move to next step")
            }
            Picker(selection: $themePicker, label: Text("Theme")) {
                Text(Theme[0]).tag(Theme[0])
                Text(Theme[1]).tag(Theme[1])
                Text(Theme[2]).tag(Theme[2])
                Text(Theme[3]).tag(Theme[3])
                Text(Theme[4]).tag(Theme[4])
                } // TODO: Fix picker and connect to themeModel
            
            HStack {
                Text("Profile:").foregroundColor(.gray)
                Spacer()
                Image(uiImage: UIImage(systemName:"person.crop.circle")!)
            }
            .onTapGesture {
                profileIsShowing.toggle()
            }
            
            HStack {
                Text("Developer:").foregroundColor(.gray)
                Spacer()
                Text("ProtoFi©")
            }
            HStack {
                Text("Compatibility:").foregroundColor(.gray)
                Spacer()
                Text("iPhone & iPad")
            }
            HStack {
                Text("Customer support:").foregroundColor(.gray)
                Spacer()
                Image(uiImage: UIImage(systemName:"envelope")!)
                    .onTapGesture {
                        emailIsShowing.toggle()
                        
                    }
                    .alert(isPresented: $emailIsShowing) {
                        Alert(title: Text("Contact Information"), message: Text("abentzur@protofi.net"), dismissButton: .default(Text("OK")))
                    }
            }
            HStack {
                Text("Version:").foregroundColor(.gray)
                Spacer()
                Text("1.0.0")
            }
            if !enableNotifications { // Just something funny
                HStack {
                    Text("Pook!")
                    Image(uiImage: .init(systemName: "brain.head.profile")!)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 30, idealWidth: 80, maxWidth: 150, minHeight: 30, idealHeight: 80, maxHeight: 150, alignment: .center)
                    .rotationEffect(.degrees(50))
            } //: Hstack
            } //: if
        } //: Form
        .sheet(isPresented: $profileIsShowing, content: {
            VStack {
                Text("Profile Name")
                    .font(.largeTitle)
                    .padding()
                
                Text("Profile Details")
                    .font(.title2)
                    .padding()
                
                Text("Swich User")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding()
                
                Text("Log Out")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding()
            }
        }) //: Sheet
            } //: Zstack
        } //: Vstack
        .onChange(of: scenePhase) { newValue in // this refreshes view when settings changed
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                }
            }
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(enableNotifications: true)
//    }
//}
