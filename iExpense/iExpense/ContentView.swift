//
//  ContentView.swift
//  iExpense
//
//  Created by Mac on 13/07/2024.
//

import SwiftUI
import SwiftData

@Model
class ExpenseItem {
    var id: UUID
    var name: String
    var type: String
    var amount: Double
    
    init(name: String, type: String, amount: Double) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.amount = amount
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    
    @State private var showingAddView = false
    @State private var sortOrder = [SortDescriptor(\ExpenseItem.name)]
    @State private var filterType = "All"
    
    let filterTypes = ["All", "Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredExpenses) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                    .accessibilityElement()
                    .accessibilityLabel("\(item.name), \(item.amount, format: .currency(code: "USD"))")
                    .accessibilityHint(item.type)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add expense", systemImage: "plus") {
                        showingAddView = true
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([SortDescriptor(\ExpenseItem.name)])
                            Text("Sort by amount")
                                .tag([SortDescriptor(\ExpenseItem.amount, order: .reverse)])
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Filter", selection: $filterType) {
                            ForEach(filterTypes, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                NavigationStack {
                    AddView()
                }
            }
        }
    }
    
    var filteredExpenses: [ExpenseItem] {
        let filteredList = filterType == "All" ? expenses : expenses.filter { $0.type == filterType }
        return filteredList.sorted(using: sortOrder)
    }
    
    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
}

#Preview {
    ContentView()
}
