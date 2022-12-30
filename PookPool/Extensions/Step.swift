//
//  Step.swift
//  PookPool
//
//  Created by Assa Bentzur on 13/06/2022.
//

import Foundation
import Combine
import CoreData
import SwiftUI

extension Item {
    static func getSteps(_ protName: String, context: NSManagedObjectContext) -> [Item] {
        // look for protocol name in databse
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = NSPredicate(format: "parent = %@", protName)
        request.sortDescriptors = [NSSortDescriptor(key: "stepnumber", ascending: true)]

        let steps = (try? context.fetch(request)) ?? []
        steps.forEach { $0.objectWillChange.send() }
            return steps
    }
    
    var parentProtocol: ProtocolPook {
        get { (parentProtocol_ ?? ProtocolPook()) }
        set { parentProtocol_ = newValue as ProtocolPook }
    }
    
    
    static func deleteStep(_ protName: String, stepNumber: IndexSet, context: NSManagedObjectContext) {
        // 1. get all of the steps of the specific protocol:
        var steps = getSteps(protName, context: context)
        // 2. remove the specific step (offset)
        steps.remove(atOffsets: stepNumber)
        // 3. Give new step numbers for the remaining steps
        steps.forEach {
            let index = $0.index(ofAccessibilityElement: steps)
            $0.stepnumber = Int64(index)
        }
        try? context.save()
        steps.forEach { $0.objectWillChange.send() }
    }
    

    static func doneStepToggle(_ protName: String, step: Int64, context: NSManagedObjectContext) {
        // look for protocol name in databse
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = NSPredicate(format: "parent = %@", protName)
        request.sortDescriptors = [NSSortDescriptor(key: "stepnumber", ascending: true)]

        let steps = (try? context.fetch(request)) ?? []
        if(steps.isEmpty != true) {
            steps[Int(step) - 1].isdone.toggle()
        }
        try? context.save()
        steps.forEach { $0.objectWillChange.send() }
        context.refreshAllObjects()
       
    }
    
    static func getTimers(_ steps: [Item] ) -> [Double] {
        var timers: [Double] = Array(repeating: Double(), count: steps.count) 
        var index: Int = 0
        timers.forEach{_ in 
            timers[index] = steps[index].timer
            index = index + 1
        }
        return timers
    }
    
    static func editStep(_ parentName: String, stepnumber: Int64, newTimer: Double, newComment: String, newDescription: String, context: NSManagedObjectContext) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = NSPredicate(format: "parent = %@", parentName)
        request.sortDescriptors = [NSSortDescriptor(key: "stepnumber", ascending: true)]
        let Steps = (try? context.fetch(request)) ?? []
        let Step = Steps[Int(stepnumber) - 1]
        Step.stepnumber = stepnumber
        Step.timer = newTimer
        Step.stepcomment = newComment
        Step.stepdescription = newDescription
        Step.timestamp = Date()
        
        try? context.save()
        
        Step.objectWillChange.send()
    }
    
    static func addStep(protName: String, step: Item, context: NSManagedObjectContext) {
        // TODO: save the loaded step with the correct parent protocol name at the correct place in the steps array

        let newStep = Item(context: context)
        newStep.parent = protName
        newStep.stepdescription = step.stepdescription
        newStep.timer = 0
        newStep.stepnumber = Int64(Item.getSteps(protName, context: context).count)
        do {
            try context.save()
            newStep.objectWillChange.send()
            context.refreshAllObjects()
        } catch {
            print(error)
        }
    }

}

//private func deleteItems(offsets: IndexSet) {
//        offsets.map { items[$0] }.forEach(viewContext.delete)
//        do {
//            try viewContext.save()
//        } catch {
//            print(error)
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//}
