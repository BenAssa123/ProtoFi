//
//  CalculatorView.swift
//  PookPool
//
//  Created by Assa Bentzur on 19/08/2022.
//

import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject var calculator: Calculator
    
    @State var finalVolume: String = ""
    
    @State var name: String = ""
    @State var startConc: String = ""
    @State var endConc: String = ""
    
    @State var statePicker: String = "Liquid"
    private var stateOfMatter: [String] = ["Liquid", "Solid"]
    
    @State var volumePicker: String = "ml"
    private var volumeUnits: [String] = ["ul", "ml", "Liter"]
    
    @State var startConcPicker: String = "mM"
    private var startConcUnits: [String] = ["uM", "mM", "Molar"]
    
    @State var finalConcPicker: String = "mM"
    private var finalConcUnits: [String] = ["uM", "mM", "Molar"]
    
    @State var resultsShowing: Bool = false
    
    var body: some View {
        VStack {
            Text("Solution Calculator")
                .font(.title)
                .bold()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .padding()
                //.background(.tertiary)
                .cornerRadius(8)
            Spacer()
            Form {
                Section(header: Text("Final Volume").bold().foregroundColor(.black).font(.body)) {
                    HStack {
                        TextField("Quantity", text: $finalVolume)
                            .keyboardType(.decimalPad)
                            .padding()
                            //.background(.tertiary)
                            .cornerRadius(4)
                            .multilineTextAlignment(.center)
                            .onSubmit({
                                if Double(finalVolume) == nil {
                                    // TODO: send a message to user and delete value?
                                    print("error")
                                }
                            })
                        Picker("Units", selection: $volumePicker) {
                            ForEach(volumeUnits, id: \.self) {
                                Text($0)
                            } //: Foreach
                        } //: Picker
                        .pickerStyle(.menu)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(.quaternary)
                        .cornerRadius(4)
                    }
                    .background(.tertiary)
                    .cornerRadius(4)
                } //: final volume
                Section(header: Text("Reagents").bold().foregroundColor(.black)) {
                    VStack {
                        if calculator.names.isEmpty != true {
                            List(0...(calculator.names.count-1), id: \.self) { index in
                            HStack {
                                Text("\(calculator.names[index])")
                                Text("\(calculator.startConcentrations[index]) -> ")
                                Text("\(calculator.finalConcentrations[index])")
                                Text("Molar")
                            }
                        }
                        .listRowSeparator(.visible)
                        .listStyle(.automatic)
                        .padding()
                        .background(.quaternary)
                        .cornerRadius(4)
                        } else {
                            Text("No reagents added")
                                .foregroundColor(.gray)
                        }
                    } //: VStack
                    } //: Reagents
                Section(header: Text("New Reagent").bold().foregroundColor(.black).font(.body)) {
                    VStack {
                        TextField("Name", text: $name)
                            .keyboardType(.default)
                            .padding()
                            .background(.tertiary)
                            .cornerRadius(4)
                            .multilineTextAlignment(.center)
                        
                        Picker("State of matter", selection: $statePicker) {
                            ForEach(stateOfMatter, id: \.self) {
                                Text($0)
                            } //: Foreach
                        } //: Picker
                        .pickerStyle(SegmentedPickerStyle())
                        .background(.quaternary)
                        .cornerRadius(4)
                        
                        HStack {
                        TextField("Starting Concentration", text: $startConc)
                            .keyboardType(.decimalPad)
                            .padding()
                            //.background(.tertiary)
                            .cornerRadius(4)
                            .multilineTextAlignment(.center)
                        
                            if statePicker != "Liquid" {
                                Text("gr/mol")
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 5)
                                    .background(.quaternary)
                                    .cornerRadius(4)
                            } else {
                                Picker("Units", selection: $startConcPicker) {
                                ForEach(startConcUnits, id: \.self) {
                                    Text($0)
                                } //: Foreach
                            } //: Picker
                            .pickerStyle(.menu)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(.quaternary)
                            .cornerRadius(4)
                            }
                    } //: HStack
                        .background(.quaternary)
                        .cornerRadius(4)
                        HStack {
                        TextField("Final Concentration", text: $endConc)
                            .keyboardType(.decimalPad)
                            .padding()
                            //.background(.tertiary)
                            .cornerRadius(4)
                            .multilineTextAlignment(.center)
                            Picker("Units", selection: $finalConcPicker) {
                                ForEach(finalConcUnits, id: \.self) {
                                    Text($0)
                                } //: Foreach
                            } //: Picker
                            .pickerStyle(.menu)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(.quaternary)
                            .cornerRadius(4)
                        } //: HStack
                        .background(.quaternary)
                        .cornerRadius(4)
                        Spacer(minLength: 20)
                        
                        Button(action: {
                            if (name.count > 0) && (Double(startConc) != nil) && (Double(endConc) != nil) && (Double(finalVolume) != nil) {
                                if (Double(startConc)! > 0) && (Double(endConc)! > 0) && (Double(finalVolume)! > 0) {
                                    
                                    startConc = String(calculator.standardizeUnits(quantity: Double(startConc)!, units: startConcPicker))
                                    endConc =  String(calculator.standardizeUnits(quantity: Double(endConc)!, units: finalConcPicker))
                                    
                                    calculator.addReagent(name: name, startConc: Double(startConc)!, finalConc: Double(endConc)!)
                                    
                                    name = ""
                                    startConc = ""
                                    endConc = ""
                                } else {
                                    print("some quantities are missing")
                                }
                            } else {
                                print("Some quantities are filled incorrectly")
                            }
                        }) {
                            Text("Add Reagent")
                        }
                        .buttonStyle(.borderedProminent)
                    } //: Vstack
                } //: New Reagent
            } //: Form
            .listStyle(.inset)
            
            HStack {
                Button(action: {
                    if (name.count > 0) && (Double(startConc) != nil) && (Double(endConc) != nil) && (Double(finalVolume) != nil) {
                        if (Double(startConc)! > 0) && (Double(endConc)! > 0) && (Double(finalVolume)! > 0) {
                            
                            finalVolume = String(calculator.standardizeUnits(quantity: Double(finalVolume)!, units: volumePicker))
                            startConc = String(calculator.standardizeUnits(quantity: Double(startConc)!, units: startConcPicker))
                            endConc =  String(calculator.standardizeUnits(quantity: Double(endConc)!, units: finalConcPicker))
                            
                            calculator.addReagent(name: name, startConc: Double(startConc)!, finalConc: Double(endConc)!)
                            
                            finalVolume = ""
                            name = ""
                            startConc = ""
                            endConc = ""
                            
                            calculator.calculate(finalVol: Double(finalVolume)!)
                            resultsShowing.toggle()
                        } else if (Double(startConc)! == 0) && (Double(endConc)! == 0) {
                            finalVolume = String(calculator.standardizeUnits(quantity: Double(finalVolume)!, units: volumePicker))
                            
                            calculator.calculate(finalVol: Double(finalVolume)!)
                            resultsShowing.toggle()
                        } else {
                            print("You must fill all required quantities")
                        }
                    } else if calculator.names.count > 0 {
                        finalVolume = String(calculator.standardizeUnits(quantity: Double(finalVolume)!, units: volumePicker))
                        
                        calculator.calculate(finalVol: Double(finalVolume)!)
                        resultsShowing.toggle()
                    } else {
                        print("Some quantities are not numbers")
                    }
                }) {
                    Text("Calculate")
                }
                .buttonStyle(.borderedProminent)
                .font(.title)
                .padding()
                //.background(.orange.opacity(0.1))
                .cornerRadius(8)
                
                Button(action: { // reset all values
                    calculator.resetAll()
                    
                    finalVolume = ""
                    name = ""
                    startConc = ""
                    endConc = ""
                }) {
                    Text("Reset")
                }
                .buttonStyle(.borderedProminent)
                .font(.title)
                .padding()
                //.background(.gray.opacity(0.2))
                .cornerRadius(8)
            } //: HStack
        } //: VStack
        .background(.orange.opacity(0.12))
        .sheet(isPresented: $resultsShowing, content: {
            VStack {
                Text("Results:")
                    .font(.largeTitle)
                    .padding()
                List {
                    ForEach (0...(calculator.names.count-1), id: \.self) { index in
                        HStack {
                            Text("\(calculator.names[index]):")
                            Text("\(calculator.results[index]) Liter")
                    } //: HStack
                    } //: ForEach
                    Text("Add \(calculator.solventVolume) Liter of Solvent")
                } //: List
                .listRowSeparator(.visible)
                .listStyle(.automatic)
                .padding()
                .background(.quaternary)
                .cornerRadius(4)
            }
        })
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .environmentObject(Calculator())
    }
}
