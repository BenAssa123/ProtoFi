//
//  RunManager.swift
//  PookPool
//
//  Created by Assa Bentzur on 27/07/2022.
//

import Foundation
import CoreData

class RunManager: ObservableObject {
    
    @Published var protocolStartDate: UserDefaults = UserDefaults.init()
    
     func getProtocolStartDate(protocolID: UUID, context: NSManagedObjectContext) {
        let request = NSFetchRequest<SavedRuns>(entityName: "SavedRuns")
        request.predicate = NSPredicate(format: "id = %@", protocolID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "startdate", ascending: false)]
        let runs = (try? context.fetch(request)) ?? []
        let run = runs.first
        
        let startDate = run?.startdate
        protocolStartDate.set(startDate, forKey: "ProtocolStartDate")
    }
    
    func removeProtocolStartDate() {
        protocolStartDate.removeObject(forKey: "ProtocolStartDate")
    }
}
