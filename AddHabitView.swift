//
//  AddHabitView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 7/4/26.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""

    let onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Habit title", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                Spacer()
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(title)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
#Preview {
    AddHabitView( onSave: {_ in })
}
