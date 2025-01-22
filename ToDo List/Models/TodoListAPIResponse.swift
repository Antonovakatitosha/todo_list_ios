//
//  TodoListAPIResponse.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/22/25.
//

struct TodoListAPIResponse: Decodable {

    let todos: [TaskAPIModel]
}
