//
//  RunnerView.swift
//  PookPool
//
//  Created by Assa Bentzur on 10/07/2022.
//

import SwiftUI

struct RunnerView: View {
    
    var body: some View {
        VStack() {
            Spacer(minLength: 20)
            Text("Step Number")
            
            ScrollView {
                Text("Description")
                Spacer()
                Text("Comments")
            }
            .padding()

            Spacer(minLength: 20)
            
            TabView {
                    Text("Calculator")
            .tabItem {
                Label("Calculator", systemImage: "function")
            }
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .tabItem {
                Label("Links", systemImage: "link")
            }
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .tabItem {
                        Label("Media", systemImage: "tv.and.mediabox")
                    }
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .tabItem {
                        Label("Set Reminder", systemImage: "clock")
                    }
                Text("Add comments/media")
                    .tabItem {
                        Label("Add", systemImage: "plus.circle")
                    }
            } //: TabView
            .padding()
            .ignoresSafeArea()
            .border(.secondary, width: 8)
            .cornerRadius(8)
            //.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            HStack(spacing: 20) {
                Button(action: {
                    
                }, label: {
                    Text("Start Timer")
                })
                .padding(.horizontal)
                Divider()
                Button(action: {
                    
                }, label: {
                    Text("Steps Remaining")
                })
                Divider()
                Button(action: {
                    
                }, label: {
                    Text("Done!")
                })
                .padding(.horizontal)
                } //: Hstack
            .padding(.horizontal)
            .background(.mint)
            .border(.gray, width: 8)
            .cornerRadius(8)
            } //: Vstack
            //.padding()
            .multilineTextAlignment(.center)
        }
    }


struct RunnerView_Previews: PreviewProvider {
    static var previews: some View {
        RunnerView()
    }
}
