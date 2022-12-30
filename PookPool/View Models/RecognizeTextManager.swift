//
//  RecognizeTextManager.swift
//  PookPool
//
//  Created by Assa Bentzur on 08/08/2022.
//

import Foundation
import SwiftUI
import Vision
import CoreData

class RecognizeTextManager: ObservableObject {
    
func recognizeText(image: UIImage?) -> String {
    var output: String = ""
    // make sure image is cgImage
    guard let cgImage = image?.cgImage else { return "Failed" }
    
    // Handler
    let handler = VNImageRequestHandler(cgImage: cgImage)
    
    // Request
    let request = VNRecognizeTextRequest {  request, error in
        
        guard let observations = request.results as? [VNRecognizedTextObservation],
              error == nil else {
            return
        }
        let text = observations.compactMap({
            $0.topCandidates(1).first?.string
        }).joined(separator: "<> ")
        
        output = text
    }
    // Process request
    do {
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        try handler.perform([request])
    }
    catch {
        print(error)
    }
    return output
}
    
    func divideIntoSteps(text: String, protocolName: String, context: NSManagedObjectContext) {
        // 1. split text into lines
        let textArray = text.components(separatedBy: "<>") // separate to array of lines
        
        let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        let stepSymbols = [".", ":", "-", " "]
        let timeSymbols = ["seconds", "sec ", "minutes", "min ", "hours", "hr "]
        //let unitSymbols = ["liter", "ltr ", "kilogram", "kg ", "gram", "gr ", "milligram", "mgr", "mg ",  "microgram", "ugr ", "ug ", "picogram", "pgr ", "C ", "K ", "Molar", "mM"]
        
        var firstStepFound = false
        var counter = 0 // to save step line index
        var stepFirstLine: Int = 0
        var firstWord = ""
        
        // 2. find line of first step (Int followed by "." or ":" or "-" AND NOT followed by "liter", "ml", "ul", "gram", "kg", "mgr", "ugr" or other units like "C" or "K")
        for line in textArray {
            counter = counter + 1
            let lineWords = line.components(separatedBy: " ") // separate each line to array of words
            if lineWords[0] == " " || lineWords[0] == "" { // get first word of each line
                 firstWord = lineWords[1]
            } else {
                 firstWord = lineWords[0]
            }
            var yesStep = false // for checking if there is a number in the first word of a line
            
            for number in 1...digits.count {
                if firstWord.contains(digits[number-1]) {
                    yesStep = true
                } //: if
            } //: for
                if yesStep {
                    if firstWord.contains(stepSymbols[0]) || firstWord.contains(stepSymbols[1]) || firstWord.contains(stepSymbols[2]) || firstWord.contains(stepSymbols[3]) || textArray[counter + 1].contains(stepSymbols[3]){ // checking there is stepSymbol in first word
                        // TODO: make sure the symbol is after the number AND there is no other number there
                        
                        if firstStepFound == false { // if this is the first step:
                            stepFirstLine = counter - 1 // save line index
                            firstStepFound = true
                        } else { // save previous step and save this line as first line of step description:
                            let stepDescription = textArray[(stepFirstLine + 1)...(counter - 2)]
                            // TODO: Maybe Check if there is an ascending order of numbers and if the next number is +1 then use it even if there is no symbol
                            // TODO: Maybe go over unit symbols?
                            
                            // check if there is timer time in step:
                            if stepDescription.contains(timeSymbols[0]) || stepDescription.contains(timeSymbols[1]) || stepDescription.contains(timeSymbols[2]) {
                                // TODO: check how many times in step this occurs:
                                // if only once then it is ok
                                // TODO: find the number and units of time and save to stepTime and timeUnit vars:
                                print("Found timer!")
                            } //: if
                            // save description and time to new step in this protocol:
                            let step = Item(context: context)
                            step.stepdescription = stepDescription.joined()
                            step.stepcomment = ""
                            step.timer = 0.0
                            Item.addStep(protName: protocolName, step: step, context: context)
                            stepFirstLine = counter - 1
                        } //: else
                    } //: if
                } //: if
        } //: for
        // create the last step from what is left from the last line index to the end:
        let stepDescription = textArray[(stepFirstLine + 1)...(counter - 1)]
        // TODO: go over unit symbols
        
        // check if there is timer time in step:
        if stepDescription.contains(timeSymbols[0]) || stepDescription.contains(timeSymbols[1]) || stepDescription.contains(timeSymbols[2]) {
            // TODO: later - check how many times in step this occurs:
            // TODO: find the number and units of time and save to stepTime var:
            print("Found timer!")
        } //: if
        // save description and time to new step in this protocol:
        //print(stepDescription)
        let step = Item(context: context)
        step.stepdescription = stepDescription.joined()
        step.stepcomment = ""
        step.timer = 0.0
        Item.addStep(protName: protocolName, step: step, context: context)
    }
}
