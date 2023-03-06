//
//  ContentView.swift
//  Taskmaster
//
//  Created by Amish Tufail on 05/03/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var task: String = ""
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(spacing: 16.0) {
                        TextField("New Task", text: $task)
                            .padding()
                            .background(
                                Color(UIColor.systemGray6)
                            )
                            .cornerRadius(16.0)
                        Button {
                            addItem()
                        } label: {
                            Spacer()
                            Text("SAVE")
                                .bold()
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? .gray : .pink)
                        .cornerRadius(10.0)
                        .disabled(isButtonDisabled)
                    }
                    .padding()
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .bold()
                                    Text(item.timestamp!, formatter: itemFormatter)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .scrollContentBackground(.hidden)
                    .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.3), radius: 12.0)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640.0)
                }
                .navigationTitle("Daily Tasks")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .background(
                Image("rocket")
                    .antialiased(true)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
            )
            .background(
                backgroundGradient.ignoresSafeArea()
            )
        }
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
