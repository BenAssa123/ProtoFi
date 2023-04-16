//
//  HomeView.swift
//  PookPool
//
//  Created by Assa Bentzur on 29/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var userManager = UserManager()
    
    @State var changeUserShowing: Bool = false
    
    let loginLabel: String = "Login"
    let enterLabel: String = "Enter"
    
    @State var isLoggedIn: Bool = false  // TODO: connect to login state
    @State var showWhatsNew: Bool = false
    
    var body: some View {
            NavigationView {
            VStack {
                Spacer(minLength: 50)
                    VStack {
                        HStack {
                            Text("ProtoFi")
                                .bold()
                                .font(.largeTitle)
                                .padding()
                                .cornerRadius(8)
                        }
                        Text("Advancing Science One Step at a Time")
                            .bold()
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .background(.green.opacity(0.125))

                Spacer(minLength: 30)
                
                ScrollView {
                    Spacer()
                    VStack {
                        
                Spacer(minLength: 200)
                            ZStack {
                                Image("pngegg-2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 300)
                                    .opacity(0.3)
                                VStack {
                                     // TODO: check user login status with function in user manager
                                    if userManager.userID.value(forKey: "UserName") != nil { //  if yes then show change user button:
                                        
                                        Text(userManager.userName)
                                        
                                        NavigationLink(enterLabel, destination: ProtocolListView())  // TODO: only navigate to protocol list view if logged in (check user defaults)
                                        .navigationBarHidden(true)
                                        .font(.largeTitle)
                                        .padding()
                                        .padding(.horizontal)
                                        .padding(.horizontal)
                                        .background(.blue.opacity(0.975))
                                        .cornerRadius(10)
                                        .foregroundColor(.black)
                                        
                                        Button(action: {
                                            isLoggedIn = true
                                            changeUserShowing.toggle()
                                        }) {
                                            Text("Switch User")
                                                .foregroundColor(.black)
                                        }
                                        .buttonStyle(.bordered)
                                        .padding(.top)
                                    } else { // if no one is logged show only login button and navigate to ChangeUserView for log in
                                        NavigationLink(loginLabel, destination: ChangeUserView(isLoggedIn: userManager.isLoggedIn).environmentObject(userManager))
                                        .navigationBarHidden(true)
                                        .font(.largeTitle)
                                        .padding()
                                        .padding(.horizontal)
                                        .padding(.horizontal)
                                        .background(.blue.opacity(0.975))
                                        .cornerRadius(10)
                                        .foregroundColor(.black)
                                    }
                                } //: VSTACK
                            }//: ZSTACK
                            Spacer(minLength: 60)
                            
                            Text("Whats New")
                                .padding()
                                .cornerRadius(8)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    showWhatsNew = true
                                }
                            
                            Spacer()
                            
                        } //:Vstack
                .frame(height: 200, alignment: .center)
                .padding(.vertical)
                .padding(.top)
                .opacity(0.9)
                } //: Scroll View
                .sheet(isPresented: $showWhatsNew, content: {
                    WhatsNewView()
                })
                .sheet(isPresented: $changeUserShowing, content: {
                    ChangeUserView(isLoggedIn: userManager.isLoggedIn).environmentObject(userManager)
                })
            } //: Vstack
            .background()
            .edgesIgnoringSafeArea(.all)
            } //: Navigation view
     }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
