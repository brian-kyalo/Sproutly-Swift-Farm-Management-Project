// Features/Home/Presentation/Views/AddExpenseView.swift
import SwiftUI

struct AddExpenseView: View {
    let onSave: (Expense) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var amountString = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Amount", text: $amountString)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        save()
                    }
                    .disabled(title.isEmpty || amountString.isEmpty)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func save() {
        if let amount = Double(amountString) {
            let expense = Expense(id: "", title: title, amount: amount, date: date)
            onSave(expense)
            dismiss()
        }
    }
}
