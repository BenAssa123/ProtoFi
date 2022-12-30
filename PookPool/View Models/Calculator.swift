//
//  Calculator.swift
//  PookPool
//
//  Created by Assa Bentzur on 19/08/2022.
//

import Foundation

class Calculator: ObservableObject, Identifiable {
    
    @Published var names: [String] = []
    @Published var startConcentrations: [Double] = []
    @Published var finalConcentrations: [Double] = []
    @Published var finalVolume: Double = 0
    
    @Published var results: [Double] = []
    @Published var solventVolume: Double = 0
    
    // TODO: perform units check to get the proper number
    
    func standardizeUnits(quantity: Double, units: String) -> Double {
        var newQuantity: Double = 0
        if units == "uM" || units == "ul" {
            newQuantity = quantity/1000
            newQuantity = newQuantity/1000
        } else if units == "mM" || units == "ml" {
            newQuantity = quantity/1000
        } else {
            newQuantity = quantity
        }
        print(newQuantity)
        return newQuantity
    }
    
    // this function is called when add reagent button is pressed in calculator
     func addReagent(name: String, startConc: Double, finalConc: Double) {
        names.append(name)
        startConcentrations.append(startConc)
        finalConcentrations.append(finalConc)
    }

    func calculate(finalVol: Double) {
        finalVolume = finalVol
         var totalResultVolume: Double = 0
         for (reagent) in 0...(names.count-1) {
             let result = (finalConcentrations[reagent] * finalVolume)/(startConcentrations[reagent])
             results.append(result)
             totalResultVolume = totalResultVolume + result
         }
         solventVolume = finalVolume - totalResultVolume
    }
    
    func resetAll() {
        names.removeAll()
        startConcentrations.removeAll()
        finalConcentrations.removeAll()
        finalVolume = 0
        results.removeAll()
        solventVolume = 0
    }
}
// TODO: create delete and edit functions
// TODO: export function for saving result as PDF
