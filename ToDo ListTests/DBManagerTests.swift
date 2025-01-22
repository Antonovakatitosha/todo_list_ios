//
//  DBManagerTests.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/22/25.
//

import XCTest
import CoreData
@testable import ToDo_List

extension DBManager {

    static func createInMemoryContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "ToDo")
        let description = container.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load a stores: \(error.localizedDescription)")
            }
        }
        return container
    }

}

final class DBManagerTests: XCTestCase {
    var dbManager: DBManager!
    var testContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()

        testContainer = DBManager.createInMemoryContainer()
        dbManager = DBManager.shared

        dbManager.container = testContainer
    }

    override func tearDown() {
        testContainer = nil
        dbManager = nil

        super.tearDown()
    }

    func testAddAndFetchTask() throws {
        let context = testContainer.viewContext

        _ = TaskDBModel(title: "Test Task", note: "This is a test note", context: context)
        try context.save()

        let tasks = try dbManager.list(entity: TaskDBModel.self, context: context)
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.title, "Test Task")
    }

    func testUpdateTask() throws {
        let context = testContainer.viewContext
        let task = TaskDBModel(title: "Test Task", note: "This is a test note", context: context)
        try context.save()

        task.title = "Updated Title"
        try context.save()

        let fetchedTask = try dbManager.first(entity: TaskDBModel.self, byID: task.id!, context: context)
        XCTAssertEqual(fetchedTask?.title, "Updated Title")
    }

    func testDeleteTask() throws {
        let context = testContainer.viewContext

        let task = TaskDBModel(title: "Test Task", note: "This is a test note", context: context)
        try context.save()

        let deleted = try dbManager.delete(entity: TaskDBModel.self, byID: task.id!, context: context)
        XCTAssertTrue(deleted)

        let tasks = try dbManager.list(entity: TaskDBModel.self, context: context)
        XCTAssertTrue(tasks.isEmpty)
    }

    func testFetchFirstTaskByID() throws {
        let context = testContainer.viewContext

        let task = TaskDBModel(title: "Fetch me", note: "This is a test note", context: context)
        try context.save()

        let fetchedTask = try dbManager.first(entity: TaskDBModel.self, byID: task.id!, context: context)
        XCTAssertNotNil(fetchedTask)
        XCTAssertEqual(fetchedTask?.title, "Fetch me")
    }

    func testListWithPredicate() throws {
        let context = testContainer.viewContext

        _ = TaskDBModel(title: "Task 1", note: "This is a test note", context: context)
        _ = TaskDBModel(title: "Special Task", note: "This is a test note", context: context)

        try context.save()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", "Special")
        let filteredTasks = try dbManager.list(entity: TaskDBModel.self, predicate: predicate, context: context)

        XCTAssertEqual(filteredTasks.count, 1)
        XCTAssertEqual(filteredTasks.first?.title, "Special Task")
    }

    func testListWithSorting() throws {
        let context = testContainer.viewContext

        let task1 = TaskDBModel(title: "Task 1", note: "This is a test note", context: context)
        let task2 = TaskDBModel(title: "Task 2", note: "This is a test note", context: context)

        task1.createdAt = Date().addingTimeInterval(-1000)
        task2.createdAt = Date()

        try context.save()

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TaskDBModel._entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

        let sortedTasks = try context.fetch(fetchRequest) as? [TaskDBModel]

        XCTAssertEqual(sortedTasks?.count, 2)
        XCTAssertEqual(sortedTasks?.first?.title, "Task 1")
    }
}
