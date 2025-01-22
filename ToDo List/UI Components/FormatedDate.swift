//
//  FormatedDate.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/16/25.
//

import SwiftUI

struct FormatedDate: View {
    
    let date: Date
    
    var body: some View {
        Text(date.formatted(
            .dateTime
                .year()
                .month(.twoDigits)
                .day(.twoDigits)
        ))
        .font(.system(size: 12))
        .foregroundStyle(.gray)
    }
}

#Preview {
    FormatedDate(date: Date())
}
