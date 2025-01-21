//
//  NamedDBEntity.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/20/25.
//

import CoreData

public protocol NamedDBEntity: NSManagedObject {
    static var _entityName: String { get }
}

