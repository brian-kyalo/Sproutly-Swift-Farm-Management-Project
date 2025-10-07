// Features/Home/Presentation/Views/AddIncomeView.swift
import SwiftUI

struct AddIncomeView: View {
    let onSave: (Income) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var quantityDescription = ""
    @State private var amountString = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Quantity Description (e.g., 10 kg bags of maize)", text: $quantityDescription)
                TextField("Amount", text: $amountString)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("Add Income")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        save()
                    }
                    .disabled(quantityDescription.isEmpty || amountString.isEmpty)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func save() {
        if let amount = Double(amountString) {
            let income = Income(id: "", amount: amount, quantityDescription: quantityDescription, date: date)
            onSave(income)
            dismiss()
        }
    }
}
