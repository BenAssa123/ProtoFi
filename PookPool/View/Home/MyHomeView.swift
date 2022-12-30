//
//  MyHomeView.swift
//  PookPool
//
//  Created by Assa Bentzur on 20/08/2022.
//

import SwiftUI

struct MyHomeView: View {
    
    @State var calcuatorIsShowing: Bool = false
    @State var profileIsShowing: Bool = false
    @State var historyIsShowing: Bool = false
    @State var protocolsIsShowing: Bool = false
    @State var settingsIsShowing: Bool = false
    @State var whatsNewIsShowing: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Home")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Spacer()
            
            LazyVStack {
            LazyHStack {
                Button(action: {
                    calcuatorIsShowing.toggle()
                }) {
                    VStack {
                        Image("Calculator_512")
                            .resizable()
                            .frame(width: 60, height: 60, alignment: .center)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .opacity(0.6)
                            
                        Text("Calculator")
                            .foregroundColor(.black)
                            .shadow(color: .white, radius: 0.5, x: 0.1, y: 0.1)
                    }
                }
                .padding()
                
                Button(action: {
                    profileIsShowing.toggle()
                }) {
                    VStack {
                        Image(systemName: "person.crop.square")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            
                        Text("Profile")
                            .foregroundColor(.black)
                            .shadow(color: .white, radius: 0.5, x: 0.1, y: 0.1)
                    }
                }
                .padding()
                
                Button(action: {
                    historyIsShowing.toggle()
                }) {
                    VStack {
                        Image(systemName: "doc.text")
                            .resizable()
                            .frame(width: 40, height: 50, alignment: .center)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            
                        Text("History")
                            .foregroundColor(.black)
                            .shadow(color: .white, radius: 0.5, x: 0.1, y: 0.1)
                    }
                }
                .padding()
             } //: LazyHStack
                LazyHStack {
                    Button(action: {
                        settingsIsShowing.toggle()
                    }) {
                        VStack {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                
                            Text("Settings")
                                .foregroundColor(.black)
                                .shadow(color: .white, radius: 0.5, x: 0.1, y: 0.1)
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        whatsNewIsShowing.toggle()
                    }) {
                        VStack {
                            Image(systemName: "wand.and.stars.inverse")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                
                            Text("Whats New")
                                .foregroundColor(.black)
                                .shadow(color: .white, radius: 0.5, x: 0.1, y: 0.1)
                        }
                    }
                    .padding()
                } //: LazyHStack
                Spacer(minLength: 20)
            } //: LazyVStack
            Spacer()
        } //: VStack
        .background(Image("homebackground1")
            .resizable()
            .scaledToFill()
            .opacity(0.5))
        .ignoresSafeArea()
        .sheet(isPresented: $calcuatorIsShowing, content: {
            CalculatorView()
        })
        .sheet(isPresented: $profileIsShowing, content: {
            ProfileView()
        })
        .sheet(isPresented: $historyIsShowing, content: {
            SavedRunsView()
        })
//        .sheet(isPresented: $protocolsIsShowing, content: {
//            //ProtocolListView()
//        })
        .sheet(isPresented: $settingsIsShowing, content: {
            //SettingsView()
        })
        .sheet(isPresented: $whatsNewIsShowing, content: {
            WhatsNewView()
        })
    }
}

struct MyHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MyHomeView()
    }
}
