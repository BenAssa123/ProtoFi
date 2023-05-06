//
//  MainView.swift
//  PookPool
//
//  Created by Assa Bentzur on 08/06/2022.
//

import SwiftUI
import CoreData

struct ProtocolListView: View {
    //MARK: Properties
    //@Environment(\.editMode) private var editMode
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var protoFi: ProtoFi

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProtocolPook.name, ascending: true)],
        animation: .default) // getting all protocols arranged by name from core data
    
    private var protocols: FetchedResults<ProtocolPook>  // saving fetched protocols in var
    
    @State private var isPresented: Bool = false  // for sheet
    @State private var isEditing: Bool = false  // for deleting protocols
    
    // MARK: Body
    var body: some View {
            TabView {
            NavigationView {
                VStack(spacing: 35) {
                    Text("My Protocols")
                        .font(.title)
                        .underline()
                    // MARK: Protocol List
                    List {
                        ForEach(protocols) { protopook in
                            NavigationLink {
                                // go to protocol view:
                                ProtocolView(isDone: Array(repeating: Bool.init(), count: 1000 + Item.getSteps(protopook.name!, context: viewContext).count), protocolStarted: ((protoFi.protocolName.value(forKey: "\(protopook.name!)") != nil) ? true : false), isProtocolRunning: (protoFi.protocolName.value(forKey: "\(protopook.name!)") != nil ? true : false), protocolName: protopook.name!, proto: protopook)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                HStack {
                                    Text("\(protopook.name ?? "Unknown")")
                                    Spacer()
                                    Text("\(String(Item.getSteps(protopook.name!, context: viewContext).count)) Steps")
                                        .foregroundColor(.gray)
                                }//: Hstack
                            }
                        } //: Foreach
                        .onDelete(perform: deleteItems)
                        .deleteDisabled(!isEditing)
                } //: List
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    isEditing.toggle()
                                }) {
                                    Label("Edit", systemImage: "trash.fill")
                                        .foregroundColor(isEditing ? .red : .accentColor)
                                }
                                .buttonStyle(.bordered)
                        }
                        ToolbarItem {
                            Button(action: {
                                isPresented.toggle()
                            }) {
                                Label("Add Item", systemImage: "plus")
                            }
                            .buttonStyle(.bordered)
                        }
                    } //: Toolbar
                    .listStyle(.sidebar)
                } //: Vstack
        } //: Navigation
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarTitle("ProtoFi")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isPresented, content: {
                AddProtocolView()
        })
            .tabItem {
                Label("Protocols", systemImage: "tortoise")
            }
                MyHomeView()
            .tabItem {
                        Label("Home", systemImage: "house")
                    }
                SavedRunsView()
            .tabItem {
                        Label("History", systemImage: "doc.text.magnifyingglass")
                    }
                SettingsView()
            .tabItem {
                        Label("Settings", systemImage: "slider.horizontal.3")
                    }
     } //: TabView
            .accentColor(.accentColor)
            .task {
                try? await lnManager.requestAuthorization()
        } //: task that tries to enable notifications
}

private func deleteItems(offsets: IndexSet) {
    withAnimation {
        offsets.map { protocols[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
            viewContext.refreshAllObjects()
        } catch {
            print(error)
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
      }
  } //: func
}

// MARK: Preview
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    .environmentObject(LocalNotificationManager())
//    }
//}
