//
//  ProtoFi.swift
//  PookPool
//
//  Created by Assa Bentzur on 26/06/2022.
//

import Foundation
import SwiftUI


class ProtoFi: ObservableObject {
    
    @Published var protocolRunning: UserDefaults = UserDefaults.init()
    @Published var protocolID: UserDefaults = UserDefaults.init()
    @Published var protocolName: UserDefaults = UserDefaults.init()
    
    func startProtocol(Id: UUID, name: String) {
        protocolRunning.set(true, forKey: "isPookRunning") // TODO: add protocol name to forKey so that many protocol can be used in parallel
        let ID = Id.uuidString
        let Name = String(name)
        protocolID.setValue(ID, forKey: "PookID")
        protocolName.setValue(Name, forKey: "\(name)")
    }
    func stopProtocol(name: String) {
        protocolRunning.removeObject(forKey: "isPookRunning")
        protocolID.removeObject(forKey: "PookID")
        protocolName.removeObject(forKey: "\(name)")
    }
    
    static func precentDone(stepsNumber: Int, stepsDone: [Bool]) -> Int {
        var total: Int = 0
        for i in 0..<stepsNumber {
            if stepsDone[i] == true {
                total += 1
            }
        }
        if stepsNumber > 0 {
            return lround(Double((total*100)/stepsNumber))
        }
        else {
            return 0
        }
    }
    static func shortStepDescription(description: String) -> String {
        if description.count > 30 {
            //let end: String.Index = description.endIndex
            var shortDescription = description
            while shortDescription.count > 30 {
                shortDescription.removeLast()
            }
            return shortDescription
        } else {
            return description
        }
    }
}
