//
//  Documentation.swift
//  PookPool
//
//  Created by Assa Bentzur on 22/06/2022.
//

import Foundation
import CoreData
import Combine

extension SavedRuns {
    // connecting the relationaship to userstepcomments:
    var userRunComments: Set<UserRunningStepComment> {
        get { (userRunComments_ as? Set<UserRunningStepComment>) ?? [] }
        set { userRunComments_ = newValue as NSSet }
    }
    
    static func saveRun(_ protName: String, ID: UUID, comments: String, context: NSManagedObjectContext) {
        // get documentation for the current run (most recent):
        let request = NSFetchRequest<SavedRuns>(entityName: "SavedRuns")
        request.predicate = NSPredicate(format: "id = %@", ID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "startdate", ascending: true)]
        let runs = (try? context.fetch(request)) ?? []
        let run = runs.first
        
        let endDate = Date()
        // insert end date and final user comments:
        run?.enddate = endDate
        run?.usercomment = comments
        // save
        try? context.save()
        run!.objectWillChange.send()
    }
    
    static func startRun(protocolName: String, ID: UUID, project: String, context: NSManagedObjectContext) {
         let startDate: Date = Date()
         let newRun = SavedRuns(context: context)
         newRun.protName = protocolName
         newRun.startdate = startDate
         newRun.userRunComments = []
         newRun.id = ID
         newRun.project = project
         
         try? context.save()
         newRun.objectWillChange.send()
     }
    
    
    static func addStepComment(protocolID: UUID, protocolName: String, stepComment: String, stepNumber: Int, context: NSManagedObjectContext) {
         
         // create new comment and add step number:
         let newStepComment = UserRunningStepComment(context: context)
         newStepComment.stepruncomment = stepComment
         newStepComment.protocolid = protocolID
    
            try? context.save()
            context.refreshAllObjects()
        
         // TODO: Add step number to each comment
         
//         get documentation for the current run (most recent)
//         let request = NSFetchRequest<SavedRuns>(entityName: "SavedRuns")
//         request.predicate = NSPredicate(format: "id = %@", protocolID as CVarArg)
//         request.sortDescriptors = [NSSortDescriptor(key: "startdate", ascending: true)]
//         let runs = (try? context.fetch(request)) ?? []
//         let run = runs.first
//         insert comment of current step:
//
//         run!.userRunComments.insert(newStepComment)
         
         
     }
    
    static func addProjectName(protocolID: String, projectName: String, context: NSManagedObjectContext) -> String {
        // get documentation for the current run (most recent):
        let request = NSFetchRequest<SavedRuns>(entityName: "SavedRuns")
        request.predicate = NSPredicate(format: "id = %@", protocolID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "startdate", ascending: true)]
        let runs = (try? context.fetch(request)) ?? []
        let run = runs.first
        
        if (run?.project == "") || (run?.project == nil) {
            run?.project = projectName
            
            try? context.save()
            run!.objectWillChange.send()
            
            return "Success - Saved to Projects"
        } else {
            return "Fail - Project Already Exist"
        }
    }

    
    
    
    //static func getRuns(_ )
}
