//
//  ToDoUsingCoreDataDemoApp.swift
//  ToDoUsingCoreDataDemo
//
//  Created by Shafiq  Ullah on 11/6/24.
//

import SwiftUI

@main
struct ToDoUsingCoreDataDemoApp: App {
    
    let provider = CoreDataProvider()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
                    .environment(\.managedObjectContext, provider.viewContext )
            }
                
        }
    }
}
