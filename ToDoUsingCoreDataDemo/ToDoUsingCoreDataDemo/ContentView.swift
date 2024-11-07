//
//  ContentView.swift
//  ToDoUsingCoreDataDemo
//
//  Created by Shafiq  Ullah on 11/6/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: []) private var todoItems : FetchedResults<ToDoItem>
    
    @State private var title : String = ""
    
    private var isFormValid: Bool{
        !title.isEmptyOrWhitespace
    }
    
    private func saveToDoItem(){
        let toDoItem = ToDoItem(context: context)
        toDoItem.title = title
        do{
            try context.save()
        }catch{
            print(error)
        }
        
    }
    
    private var pendingToDoItems : [ToDoItem]{
        todoItems.filter { !$0.isCompleted }
    }
    
    private var completedToDoItems : [ToDoItem]{
        todoItems.filter { $0.isCompleted }
    }
    
    
    private func updateToDoItem(_ todoItem: ToDoItem){
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func deleteToDoItem(_ todoItem: ToDoItem){
        context.delete(todoItem)
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    var body: some View {
        VStack{
            TextField("Title", text: $title)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    if isFormValid{
                        saveToDoItem()
                        title = ""
                    }
                }
            
            List{
                Section("Pending"){
                    if pendingToDoItems.isEmpty{
                        // make some UI that will show that No item available
                        // from iOS 17
                        //ContentUnavailableView("No Items Found.", systemIage: "doc")
                    }else{
                        ForEach(pendingToDoItems){ todoItem in
                            ToDoCellView(todoItem: todoItem, onChanged: updateToDoItem)
                        }.onDelete { indexSet in
                            indexSet.forEach { index in
                                let todoItem = pendingToDoItems[index]
                                deleteToDoItem(todoItem)
                            }
                        }
                    }
                    
                }
                
                Section("Completed"){
                    if completedToDoItems.isEmpty{
                        // make some UI that will show that No item available
                        // from iOS 17
                        //ContentUnavailableView("No Items Found.", systemIage: "doc")
                    }else{
                        ForEach(completedToDoItems){ todoItem in
                            ToDoCellView(todoItem: todoItem, onChanged: updateToDoItem)
                        }.onDelete { indexSet in
                            indexSet.forEach { index in
                                let todoItem = completedToDoItems [index]
                                deleteToDoItem(todoItem)
                            }
                        }
                    }
                    
                }
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Todo")
    }
}


struct ToDoCellView: View {
    
    let todoItem : ToDoItem
    let onChanged: (ToDoItem) -> Void
    
    var body: some View {
        HStack{
            Image(systemName: todoItem.isCompleted ? "checkmark.square": "square")
                .onTapGesture {
                    todoItem.isCompleted.toggle()
                    onChanged(todoItem)
                }
            if todoItem.isCompleted{
                Text(todoItem.title ?? "")
            }else{
                TextField("", text: Binding(get: {
                    todoItem.title ?? ""
                }, set: { newValue in
                    todoItem.title = newValue
                }))
                    .onSubmit {
                        onChanged(todoItem)
                    }
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
                .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
        }
       
    }
}
