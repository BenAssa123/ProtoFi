//
//  ProtocolExtension.swift
//  PookPool
//
//  Created by Assa Bentzur on 06/06/2022.
//

import Combine
import CoreData

extension ProtocolPook {
    static func findProtocol(_ name: String, context: NSManagedObjectContext) -> ProtocolPook {
        
        // look for protocol name in databse
        let request = NSFetchRequest<ProtocolPook>(entityName: "ProtocolPook")
        request.predicate = NSPredicate(format: "name = %@", name)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        
        let protocolPooks = (try? context.fetch(request)) ?? []
        let protocolPook = protocolPooks.first // TODO: MAybe return all protocol with that name?
            // if found, return it
            return protocolPook ?? ProtocolPook()
            // else {
//            // if not found, create new protocol with new name and look for it online
//            let protocolPook = ProtocolPook(context: context)
//            protocolPook.name = name
    }
    
    // add func to add steps to existing protocol:
    static func addProtocol(_ protocolName: String, Description: String, Proto: ProtocolPook, context: NSManagedObjectContext) {
        // save the loaded protocol with all properties and update
        let newProtocol = ProtocolPook()
        newProtocol.name = protocolName
        newProtocol.steps = []
        newProtocol.generalDescription = Description
        newProtocol.timeStamp = Date()
        newProtocol.id = UUID()
        
        try? context.save()
    }
    static func resetisDone(isDone: [Bool]) -> [Bool] {
        var isDone = isDone
        for i in 0...isDone.count {
            isDone[i] = false
        }
        return isDone
    }
    
    var steps: Set<Item> {
        get { (steps_ as? Set<Item>) ?? [] }
        set { steps_ = newValue as NSSet }
    }
}
