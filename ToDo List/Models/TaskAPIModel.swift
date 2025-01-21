//
//  TaskAPIModel.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/20/25.
//

import Foundation

struct TaskAPIModel: Decodable {

    let todo: String
    let completed: Bool
}

struct TodosResponse: Decodable {
    let todos: [TaskAPIModel]
}
