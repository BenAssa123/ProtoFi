//
//  HomeView.swift
//  PookPool
//
//  Created by Assa Bentzur on 29/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var changeUserShowing: Bool = false
    
    let label: String = "Pook"
    
    @State var isLoggedIn: Bool = false
    @State var whatsNew:Bool = false
    
    var body: some View {
            NavigationView {
            VStack {
                Spacer(minLength: 50)
                    VStack {
                        HStack {
                            Text("ProtoFi")
                                .bold()
                                .font(.largeTitle)
                                //.padding(.horizontal)
                                .padding()
                                .cornerRadius(8)
                            
//                            Image("pngegg-7")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 60, height: 60, alignment: .center)
                        }
                        Text("Advancing Science One Step at a Time")
                            .bold()
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .background(.orange.opacity(0.2))
                    //.cornerRadius(8)

                Spacer(minLength: 30)
                
                ScrollView {
                    Spacer()
                    VStack {
                        
                Spacer(minLength: 200)
                        
                        if isLoggedIn == true {
                        } //: if
                        else {
                            //Button(action: {
                                //isLoggedIn.toggle()
                            ZStack {
                                Image("pngegg-2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 300)
                                    .opacity(0.3)
                                VStack {
                                    NavigationLink("Log In", destination: ProtocolListView())
                                    .navigationBarHidden(true)
                                    .font(.largeTitle)
                                    .padding()
                                    .padding(.horizontal)
                                    //.padding(.vertical)
                                    .padding(.horizontal)
                                    //.buttonStyle(.borderedProminent)
                                    .background(.blue.opacity(0.9))
                                    .cornerRadius(12)
                                    .foregroundColor(.black)
                                    
                                    Button(action: {
                                        changeUserShowing.toggle()
                                    }) {
                                        Text("Switch User")
                                            .foregroundColor(.blue)
                                    }
                                    .buttonStyle(.bordered)
                                    .padding(.top)
                                }
                                
                            }
                            Spacer(minLength: 60)
                            
                            Text("Whats new?")
                                .padding()
                                .cornerRadius(8)
                                .foregroundColor(.mint)
                                .onTapGesture {
                                    whatsNew.toggle()
                                }
                            
                            Spacer()
                        } //: else
                        } //:Vstack
                .frame(height: 200, alignment: .center)
                .padding(.vertical)
                .padding(.top)
                .opacity(0.9)
                } //: Scroll View
                .sheet(isPresented: $whatsNew, content: {
                    WhatsNewView()
                })
                .sheet(isPresented: $changeUserShowing, content: {
                    ChangeUserView()
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
