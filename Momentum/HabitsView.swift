//
//  HabitView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 6/4/26.
//

import SwiftUI
import SwiftData

struct HabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    @Query private var missions: [Mission]
    @State private var searchText = ""
    
    @State private var isShowingAddHabit = false
    
    private var filteredHabits: [Habit] {
        if searchText.isEmpty {
            return habits
        }
        return habits.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {

        ZStack {
            Color.black
                .ignoresSafeArea()
            RadialGradient(colors: [Color.purple.opacity(0.35), Color.clear], center: .top, startRadius: 0, endRadius: 300)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Add habits to your routine")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    ForEach(filteredHabits) { habit in
                        HabitsCardView(
                            habit: habit,
                            onToggle: {
                                habit.isSelected.toggle()
                            }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Habits")
        .toolbar {
            Button {
                isShowingAddHabit = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isShowingAddHabit) {
            AddHabitView { title in
                let newHabit = Habit(
                    title: title,
                    isSelected: true,
                    icon: "checkmark.circle"
                )
                modelContext.insert(newHabit)
            }
        }
        .searchable(text: $searchText, prompt: "Search habits")
    }
}

#Preview {
    NavigationStack {
        HabitsView()
    }
}
