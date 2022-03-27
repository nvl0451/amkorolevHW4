//
//  Note+CoreDataProperties.swift
//  amkorolevHW4
//
//  Created by Андрей Королев on 27.03.2022.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var title: String?
    @NSManaged public var creationData: Date

}

extension Note : Identifiable {

}
