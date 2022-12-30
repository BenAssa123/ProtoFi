//
//  RunView.swift
//  PookPool
//
//  Created by Assa Bentzur on 22/06/2022.
//

import SwiftUI
import CoreData

struct RunView: View {
    @Environment(\.managedObjectContext) private var viewContext
    // MARK: Properties
    let run: SavedRuns
    let name: String
    let project: String
    let comment: String
    let date: Date
    let totalRunTime: Int
    
    @State var exportState: Bool = false
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 5) {
            Form {
                HStack {
                Text("Protocol Name:")
                    Spacer()
                    Text("\(name)")
            }
                HStack {
                    Text("Project Name:")
                    Spacer()
                    Text("\(project)")
                }
                HStack {
                    Text("Completed on:")
                    Spacer()
                    Text("\(date)")
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Total run time:")
                    Spacer()
                    Text("\(totalRunTime) seconds")
                }
                // MARK: General Comments
                if comment.count > 0 {
                    Text("Comments:")
                    ScrollView {
                        Text("\(comment)")
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                                .multilineTextAlignment(.leading)
                                .cornerRadius(8)
                        }
                } //: if
                // MARK: step comments in list:
                    if UserRunningStepComment.getComments(run, context: viewContext).count > 0 {
                            Text("Step Comments:")
                    } //: if
                            ForEach(UserRunningStepComment.getComments(run, context: viewContext)) { comment in
                                NavigationLink {
                                    VStack {
                                        Text("Step Comment")
                                            .font(.title3)
                                            .padding()
                                        
                                        Text(comment.stepruncomment ?? "Empty")
                                            .padding()
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                            .background(.quaternary)
                                            .cornerRadius(8)
                                    }
                                } label: {
                                    Text((comment.stepruncomment!.count > 30) ? "Comment" : "\(comment.stepruncomment!)")
                                }
                            } //: Foreach
                            .padding()
                            .background(.quaternary)
                .listStyle(.sidebar)
            } //: Form
            .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { // MARK: Export
                    // TODO: Export to PDF and to email?
                    exportState.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
              }
            } //: Toolbar
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        .sheet(isPresented: $exportState, content: {
            VStack(spacing: 20) {
                Text("Export Run")
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
    }
}
// MARK: Preview
//struct RunView_Previews: PreviewProvider {
//    static var previews: some View {
//        RunView(run: SavedRuns(), name: "Protocol", comment: "Comments", date: Date(), totalRunTime: 10.0)
//    }
//}
