//
//  UserRunningStepComment.swift
//  PookPool
//
//  Created by Assa Bentzur on 25/07/2022.
//

import Foundation
import CoreData

extension UserRunningStepComment {
    
    var savedRun: SavedRuns {
        get { (savedRun_ ?? SavedRuns()) }
        set { savedRun_ = newValue as SavedRuns }
    }
    
    static func getComments(_ savedRun: SavedRuns, context: NSManagedObjectContext) -> [UserRunningStepComment] {
        let protocolId = savedRun.id
        if protocolId == nil {
            return []
        }
        // look for protocol id in databse
        let request = NSFetchRequest<UserRunningStepComment>(entityName: "UserRunningStepComment")
        request.predicate = NSPredicate(format: "protocolid = %@", protocolId! as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "stepruncomment", ascending: true)]

        let comments = (try? context.fetch(request)) ?? []
        comments.forEach { $0.objectWillChange.send() }
            return comments
    }
    
}
