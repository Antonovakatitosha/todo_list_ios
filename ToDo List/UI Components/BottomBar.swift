//
//  BottomBar.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/16/25.
//

import SwiftUI

struct BottomBar: View {
    
    let taskCount: Int
    var onEdit: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("\(taskCount) Задач")
                    .font(.system(size: 11))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20.5)
            .padding(.bottom, 15)
            .background(Color("bottom-bar-color"))
            .overlay (
                NavigationLink(destination: TaskEditorPage(task: nil, onEdit: onEdit)) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22))
                        .foregroundStyle(.yellow)
                        .padding(.trailing, 15)
                },
                alignment: .trailing
            )
        }
    }
}

#Preview {
    BottomBar(taskCount: 7, onEdit: {})
}
