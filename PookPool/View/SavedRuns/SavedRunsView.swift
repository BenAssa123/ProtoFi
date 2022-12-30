//
//  SavedRunsView.swift
//  PookPool
//
//  Created by Assa Bentzur on 22/06/2022.
//

import SwiftUI

struct SavedRunsView: View {
    // MARK: Properties
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavedRuns.enddate, ascending: true)],
        animation: .default)
    
    private var runs: FetchedResults<SavedRuns>
    
    // TODO: add option to filter runs based on name of protocol or date or Project?
    @State var profileIsShowing: Bool = false
    @State var exportState: Bool = false
    @State var filterIsShowing: Bool = false
    
    // MARK: Body
    var body: some View {
        NavigationView {
            VStack {
                Text("History:")
                    .font(.title)
                    .underline()
                List {
                    ForEach(runs) { run in
                        NavigationLink {
                            // go to protocol view:
                            RunView(run: run, name: run.protName ?? "Error", project: run.project ?? "Unknown", comment: run.usercomment ?? "No Comment", date: run.enddate ?? Date(), totalRunTime: Int(Double(((run.enddate?.timeIntervalSince(run.startdate ?? Date())) ?? 0)).rounded()))
                        } label: {
                            HStack {
                                Text("\(run.protName ?? "Unknown")\nProject: \(run.project ?? "Unknown")")
                                Spacer()
                                if (run.enddate != nil) {
                                    Text("\(run.enddate!.formatted())")
                                } //: if
                            } //: Hstack
                        } //: label
                    } //: Foreach
            } //: List
                .listStyle(.automatic)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                // TODO: Filter by project name, by date
                                filterIsShowing.toggle()
                            }) {
                                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                            }
                            .buttonStyle(.bordered)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                profileIsShowing.toggle()
                            }) {
                                Label("Profile", systemImage: "person.crop.circle")
                            }
                            .buttonStyle(.bordered)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                exportState.toggle()
                                // TODO: when export state then user can select runs like pictures
                            }) {
                                HStack {
                                    //Text("Export")
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                            .buttonStyle(.bordered)
                    }
                } //: Toolbar
            } //: Vstack
    } //: Navigation
        .sheet(isPresented: $profileIsShowing, content: {
            ProfileView()
        }) //: Sheet
        .sheet(isPresented: $exportState, content: {
            VStack(spacing: 20) {
                Text("Export Previous Runs")
                    .font(.title2)
                //HStack {
                    Button(action: {
                        
                    }) {
                        Text("To File")
                            .font(.title3)
                    }
                    .buttonStyle(.borderedProminent)
                    Button(action: {
                        
                    }) {
                        Text("To App")
                            .font(.title3)
                    }
                    .buttonStyle(.borderedProminent)
                //} //: HStack
            } //: VStack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(.quaternary)
            .cornerRadius(8)
        })
        .sheet(isPresented: $filterIsShowing, content: {
            VStack(spacing: 20) {
                Text("Filter Previous Runs")
                    .font(.title2)
                //HStack {
                    Button(action: {
                        
                    }) {
                        Text("By Date")
                            .font(.title3)
                    }
                    .buttonStyle(.borderedProminent)
                    //Spacer()
                    Button(action: {
                        
                    }) {
                        Text("By Project Name")
                            .font(.title3)
                    }
                    .buttonStyle(.borderedProminent)
                //} //: HStack
            } //: VStack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(.quaternary)
            .cornerRadius(8)
        })
  }
}

// MARK: Preview
struct SavedRunsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedRunsView()
    }
}
