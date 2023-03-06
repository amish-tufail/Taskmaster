//
//  ContentView.swift
//  Taskmaster
//
//  Created by Amish Tufail on 05/03/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    @AppStorage("darkMode") var isDarkMode: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack(spacing: 10.0) {
                        Text("Task Master")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        Spacer()
                        EditButton() // Pre-Made
                            .font(.system(size: 16.0, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10.0)
                            .frame(minWidth: 70.0, minHeight: 24.0)
                            .background(
                                Capsule()
                                    .stroke(.white, lineWidth: 2.0)
                            )
                        Button {
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24.0, height: 24.0)
                                .font(.system(.title, design: .rounded))
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    Spacer(minLength: 80)
                    Button {
                        showNewTaskItem = true
                        playSound(sound: "sound-ding", type: "mp3")
                        feedback.notificationOccurred(.success)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30.0, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24.0, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20.0)
                    .padding(.vertical, 15.0)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8.0, x: 0.0, y: 4.0)
                    List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .scrollContentBackground(.hidden)
                    .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.3), radius: 12.0)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640.0)
                }
                .navigationBarBackButtonHidden()
                .blur(radius: showNewTaskItem ? 8.0 : 0.0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5), value: showNewTaskItem)
                if showNewTaskItem {
                    BlankView(backgroundColor: isDarkMode ? .black : .gray, backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
            }
            .background(
                Image("rocket")
                    .antialiased(true)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .blur(radius: showNewTaskItem ? 8.0 : 0.0, opaque: false)
            )
            .background(
                backgroundGradient.ignoresSafeArea()
            )
        }
    }
    

    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
