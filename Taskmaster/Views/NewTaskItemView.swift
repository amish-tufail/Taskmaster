//
//  NewTaskItemView.swift
//  Taskmaster
//
//  Created by Amish Tufail on 06/03/2023.
//

import SwiftUI

struct NewTaskItemView: View {
    @State var task: String = ""
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isShowing: Bool
    @AppStorage("darkMode") var isDarkMode: Bool = false
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16.0) {
                TextField("New Task", text: $task)
                    .font(.system(size: 24.0, weight: .bold, design: .rounded))
                    .padding()
                    .foregroundColor(.pink)
                    .background(
                        Color(isDarkMode ? UIColor.tertiarySystemBackground :  UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(16.0)
                Button {
                    addItem()
                    playSound(sound: "sound-ding", type: "mp3")
                    feedback.notificationOccurred(.success)
//                    isShowing = false
                } label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24.0, weight: .bold, design: .rounded))
                    Spacer()
                }
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? .blue : .pink)
                .cornerRadius(10.0)
                .disabled(isButtonDisabled)
                .onTapGesture {
                    if isButtonDisabled {
                        playSound(sound: "sound-tap", type: "mp3")
                        feedback.notificationOccurred(.error)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20.0)
            .background(isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white)
            .cornerRadius(16.0)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24.0)
            .frame(maxWidth: 640.0)
        }
        .padding()
    }
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hideKeyboard()
            isShowing = false
        }
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(false))
    }
}
