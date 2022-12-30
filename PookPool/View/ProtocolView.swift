//
//  ContentView.swift
//  ProtoFi
//
//  Created by Assa Bentzur on 22/05/2022.
//

import SwiftUI
import CoreData

struct ProtocolView: View {
    //MARK: Properties
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var stopWatch: StopWatchManager
    @EnvironmentObject var protoFi: ProtoFi
    
    
    @State private var isPresented:Bool = false
    @State var protocolCompleted: Bool = false
    @State var protocolCompletedYes: Bool = false
    @State var isNavigating: Bool = false
    
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    @State var isDone: [Bool]
    @State var protocolStarted: Bool //= false
    @State var stepComments: [String] = []
    
    @State var isProtocolRunning: Bool //= false
    
    @State private var isEditing: Bool = false
    
    @State private var editingAlertIsShowing: Bool = false
    
    let protocolName: String
    let proto: ProtocolPook
    let ID = UUID()
    
    @State var projectName: String = ""
    @State var addProject: Bool = false
    @State var addProjectNameSheet: Bool = false
    
    @State var photoPickerShowing: Bool = false
    
//MARK: Body
    var body: some View {
        VStack {
            Text(protocolName)
                .font(.title2)
                //.padding()
            
            Spacer(minLength: 10)

            HStack {
                Text(proto.generalDescription ?? "")
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    //.padding()
            
            if proto.generalDescription!.count > 65 {
                NavigationLink(destination: {
                    VStack {
                        Text("Protocol Description")
                            .padding()
                            .font(.title)
                        Spacer()
                        Text(proto.generalDescription ?? "Protocol Description")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(.gray.opacity(0.2))
                        Spacer()
                    }
                
                }, label: {
                    Text("Full Description")
            })
            } //: if
            }
                
            if stopWatch.isRunning {
                IsTimerRunningView()
            }
                List {
                    ForEach(Item.getSteps(protocolName, context: viewContext)) { item in
                        NavigationLink { // go to correct step view by running or not:
                            if !protocolStarted {
                                StepTabView(items: Item.getSteps(protocolName, context: viewContext), firstStep: Int(item.stepnumber), timerTime: Item.getTimers(Item.getSteps(protocolName, context: viewContext)))
                            } else {
                                RunningStepTabView(items: Item.getSteps(protocolName, context: viewContext), isDone: $isDone, firstStep: Int(item.stepnumber), timerTime: Item.getTimers(Item.getSteps(protocolName, context: viewContext)))
                            }
                        } label: {
                            HStack {
                                Text("\(item.stepnumber) ")
                                    .font(.title3)
                                    .bold()
                                Text((item.stepdescription!.count < 30) ? item.stepdescription! : "\(ProtoFi.shortStepDescription(description: item.stepdescription!))...")
                                    .lineLimit(1)
                                Spacer()
                                Text((isDone[Int(item.stepnumber) - 1]) ? "Done" : "")
                                    .foregroundColor(.gray)
                                if isEditing {
                                    Label("Swipe to Delete", systemImage: "arrow.left.to.line")
                                }
                            } //: Hstack
                        }
                    } //: foreach
                    .onDelete(perform: deleteItems)
                    .deleteDisabled(!isEditing)
                    .padding(.vertical, 3)
                    .foregroundColor(isEditing ? .red : .primary)
                    .ignoresSafeArea()
                    .cornerRadius(5)
                } //: List
                .listStyle(.sidebar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // MARK: Delete Step
                        Button(action: {
                            if !((protoFi.protocolRunning.value(forKey: "isPookRunning") != nil) && (protoFi.protocolRunning.value(forKey: "PookID") != nil)) {
                                isEditing.toggle()
                            } else {
                                editingAlertIsShowing = true
                            }
                        }) {
                            Label("Delete", systemImage: "trash.fill")
                                .foregroundColor(isEditing ? .red : .black)
                        }
                        .buttonStyle(.borderedProminent)
                        .alert(isPresented: $editingAlertIsShowing) {
                            Alert(
                                title: Text("Editing Disabled"),
                                message: Text("Finish Protocol to enable editing"),
                                dismissButton: .default(Text("OK"))
                            )}
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // MARK: Add Step
                        Button(action: {
                            if !((protoFi.protocolRunning.value(forKey: "isPookRunning") != nil) && (protoFi.protocolRunning.value(forKey: "PookID") != nil)) {
                                isPresented.toggle()
                            } else {
                                editingAlertIsShowing = true
                            }
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } //: Toolbar
                .accentColor(((protoFi.protocolRunning.value(forKey: "isPookRunning") != nil) && (protoFi.protocolRunning.value(forKey: "PookID") != nil)) ? .gray : .accentColor)
            .sheet(isPresented: $isPresented, content: {
                AddTodoView(timer: 0.0, parent: protocolName)
        })
            if (protoFi.protocolRunning.value(forKey: "isPookRunning") != nil) && (protoFi.protocolName.value(forKey: "\(protocolName)") != nil) { // if protocol is running:
                VStack {
                    Text("\(ProtoFi.precentDone(stepsNumber: Item.getSteps(protocolName, context: viewContext).count, stepsDone: isDone))% Done")
                        .font(.body)
                        .padding() // TODO: When 100% ask if protocol is completed and if yes change protocolCompleted to True
                    
                    // MARK: Finish run
                    Text(protocolCompleted ? "Done!" : "Finish (Double-tap)")
                        .font(.title3)
                        .fontWeight(protocolCompleted ? .bold : .light)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(protocolCompleted ? .blue : .gray)
                        .multilineTextAlignment(.center)
                        .cornerRadius(8)
                        .onTapGesture(count: 2) {
                            protocolCompleted = true
                            self.hapticImpact.impactOccurred()
                            // TODO: add check all steps completed or warn that not all are completed?
                            // TODO: make sure whether protocol id is required
                        }
                        .animation(Animation.default, value: protocolCompleted)
                        .alert(isPresented: $protocolCompleted) {
                            Alert(
                                title: Text("Protocol completed"),
                            message: Text("This run will be saved to your previous runs list. Do you want to add comments to this run?"),
                                primaryButton: .default(Text("Just save"), action: {
                                    SavedRuns.saveRun(protocolName, ID: UUID(uuidString: protoFi.protocolID.value(forKey: "PookID") as! String)!, comments: "", context: viewContext)
                                    
                                    isProtocolRunning = false
                                    protoFi.stopProtocol(name: protocolName)
                                    protocolStarted = false
                                    
                                    isDone.removeFirst(Item.getSteps(protocolName, context: viewContext).count) // resets done steps
                                }),
                                secondaryButton: .default(Text("Add Comments"), action: {
                                    protocolCompletedYes.toggle()
                                })
                        )} //: Alert
                        .sheet(isPresented: $protocolCompletedYes, content: {
                            ProtocolCompletedView(name: protocolName, projectName: projectName, isDone: $isDone, isProtocolRunning: $isProtocolRunning,  protocolStarted: $protocolStarted)
                    })
                } //: VStack
                .ignoresSafeArea()
                
            } else if (protoFi.protocolRunning.value(forKey: "isPookRunning") == nil) && (protoFi.protocolName.value(forKey: "\(protocolName)") == nil) {
                
                // MARK: Steps from Photo
                Button(action: {
                    photoPickerShowing.toggle()
                }) {
                    HStack {
                        Text("Add Steps from Picture")
                            .padding(.leading)
                        Image("ocr1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45, alignment: .center)
                            
                    }
                    .foregroundColor(.black)
                }
                .background(.cyan)
                .cornerRadius(8)
                .buttonStyle(.borderless)
                
                // MARK: Start Run
                if Item.getSteps(protocolName, context: viewContext).count > 0 {
                    Button(action: {   // Start documentation and set an id for the saved run:
                        addProject.toggle()
                        
                        protocolStarted = true
    //                    SavedRuns.startRun(protocolName: protocolName, ID: ID, project: projectName, context: viewContext)
    //                    protoFi.startProtocol(Id: ID, name: protocolName)
                        }, label: {
                                Text("Start Protocol")
                                        .bold()
                                        .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            })
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(minHeight: 40, idealHeight: 40, maxHeight: 60, alignment: .center)
                    .padding(.horizontal)
                    .background(.blue)
                    .cornerRadius(8)
                    .buttonBorderShape(.automatic)
                    .padding(.horizontal)
                    .alert(isPresented: $addProject) { // MARK: Connect to project
                        Alert(
                            title: Text("Add to Project"),
                        message: Text("Do you want to add a Project Name to this run?"),
                            primaryButton: .default(Text("Add Project Name"), action: {
                                
                                addProjectNameSheet.toggle()
                            }),
                            secondaryButton: .default(Text("Nope"), action: { // just save run without project name
                                SavedRuns.startRun(protocolName: protocolName, ID: ID, project: projectName, context: viewContext)
                                protoFi.startProtocol(Id: ID, name: protocolName)
                            })
                    )} //: Alert
                    .sheet(isPresented: $addProjectNameSheet, content: {
                        AddProjectNameView(projectName: $projectName, protocolName: protocolName, ID: ID)
                    })
                } //: if
            } //: else
        } //: Vstack
        .sheet(isPresented: $photoPickerShowing, content: { RecognizeTextView(parentProtocol: proto) })
    } //: Body

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { Item.getSteps(protocolName, context: viewContext)[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
                viewContext.refreshAllObjects()
            } catch {
                print(error)
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            var counter = 1
        Item.getSteps(protocolName, context: viewContext).forEach {
            if ($0.stepnumber != counter) {
                $0.stepnumber = Int64(counter)
            }
            counter = counter + 1
        }
            do {
                try viewContext.save()
                viewContext.refreshAllObjects()
            } catch {
                print(error)
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
          }
    }//: func
}

//MARK: Preview
//struct ProtocolView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProtocolView( protocolName: "Pook").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
