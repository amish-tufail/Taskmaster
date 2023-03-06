//
//  ListRowItemView.swift
//  Taskmaster
//
//  Created by Amish Tufail on 06/03/2023.
//

import SwiftUI

struct ListRowItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Item // For Update operation
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? .pink : .primary)
                .padding(.vertical, 12.0)
                .animation(.default, value: item.completion)
        }
        .toggleStyle(CheckBoxStyle()) // Created a custom Toggle Style
        .onReceive(item.objectWillChange) { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        }
    }
}
