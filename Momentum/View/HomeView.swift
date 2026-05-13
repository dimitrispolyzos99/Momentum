//
//  HomeView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//

import SwiftUI
import SwiftData
import FirebaseAuth

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var showLevelUp = false
    @State private var showDailyGoal = false
    @Query private var habits: [Habit]
    @Query private var missions: [Mission]
    @Query private var progressList: [PlayerProgress]
    @Environment(\.modelContext) private var modelContext

    private var playerProgress: PlayerProgress? {
        progressList.first { $0.userId == currentUserId }
    }
    private var currentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    private var displayedMissions: [Mission] {
        let today = missions.filter {
            Calendar.current.isDateInToday($0.assignedDate) && $0.userId == currentUserId
        }
        let completed = today.filter { $0.isCompleted }
        let uncompleted = today.filter { !$0.isCompleted }
        return uncompleted + completed
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                RadialGradient(colors: [Color.purple.opacity(0.35), Color.clear], center: .top, startRadius: 0, endRadius: 300)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 18) {
                        if let progress = playerProgress {
                            LevelCardView(progress: progress)
                        }
                        HStack{
                            Button("Log out") {
                                try? Auth.auth().signOut()
                            }
                            NavigationLink ("Chat") {
                                MainMessagesView()
                            }
                            .padding()
                            .foregroundColor(.purple)
                        }
                        Text("Today's Missions")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.white)

                        ForEach(displayedMissions) { mission in
                            MissionCardView(
                                mission: mission,
                                onToggle: {
                                    if let progress = playerProgress {
                                        viewModel.completeMission(mission, progress: progress, missions: displayedMissions)
                                    }
                                }
                            )
                        }

                        HStack {
                            Text("Habits")
                                .font(.title2)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)

                            Spacer()

                            NavigationLink("View all") {
                                HabitsView()
                            }
                            .padding()
                            .foregroundColor(.purple)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(habits.filter({ $0.userId == currentUserId })) { habit in
                                    if habit.isSelected {
                                        HabitsCardView(
                                            habit: habit,
                                            onToggle: { habit.isSelected.toggle() }
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }

                // Overlays
                if showLevelUp, let progress = playerProgress {
                    LevelUpOverlayView(level: progress.level) {
                        showLevelUp = false
                    }
                }

                if showDailyGoal {
                    DailyGoalView {
                        showDailyGoal = false
                    }
                }
            }
        }
        .onAppear {
            Task {
                try? await Task.sleep(nanoseconds: 100_000_000)

                if playerProgress == nil {
                    let progress = PlayerProgress(
                        level: 1, currentXP: 0, xpForNextLevel: 100,
                        streak: 0, lastDailyReset: .distantPast,
                        didCompleteDailyGoal: false, userId: currentUserId
                    )
                    modelContext.insert(progress)
                }

                if habits.filter({ $0.userId == currentUserId }).isEmpty { seedHabits() }

                try? await Task.sleep(nanoseconds: 100_000_000)
                assignDailyMissions()

                if let progress = playerProgress {
                    viewModel.checkDailyReset(missions: missions, progress: progress)
                }
            }
        }
        .onChange(of: viewModel.didLevelUp) { _, newValue in
            if newValue {
                showLevelUp = true
                viewModel.didLevelUp = false
            }
        }
        .onChange(of: viewModel.dailyGoal) { _, newValue in
            if newValue {
                showDailyGoal = true
                viewModel.dailyGoal = false
            }
        }
    }

    private func seedHabits() {
        let defaults = [
            Habit(title: "Workout", isSelected: false, icon: "figure.strengthtraining.traditional", userId: currentUserId),
            Habit(title: "Read", isSelected: false, icon: "book", userId: currentUserId),
            Habit(title: "Drink Water", isSelected: false, icon: "drop", userId: currentUserId),
            Habit(title: "Walk", isSelected: false, icon: "figure.walk", userId: currentUserId),
            Habit(title: "Meditate", isSelected: false, icon: "brain", userId: currentUserId),
            Habit(title: "Journal", isSelected: false, icon: "square.and.pencil", userId: currentUserId),
            Habit(title: "Stretch", isSelected: false, icon: "figure.cooldown", userId: currentUserId),
            Habit(title: "Sleep Early", isSelected: false, icon: "bed.double", userId: currentUserId),
            Habit(title: "Study Swift", isSelected: true, icon: "laptopcomputer", userId: currentUserId),
            Habit(title: "No Sugar", isSelected: false, icon: "leaf", userId: currentUserId)
        ]
        for habit in defaults {
            modelContext.insert(habit)
        }
    }

    private func assignDailyMissions() {
        let today = missions.filter {
            Calendar.current.isDateInToday($0.assignedDate) && $0.userId == currentUserId
        }
        guard today.isEmpty else { return }
            
        let streak = playerProgress?.streak ?? 0
        let tier = min(streak / 3, 2)

        let selectedHabits = habits.filter { $0.isSelected }
        let selectedHabitTitles = selectedHabits.map { $0.title }

        let habitTemplates = MissionTemplate.all
            .filter { template in
                guard let habitTitle = template.habitTitle else { return false }
                return selectedHabitTitles.contains(habitTitle)
            }
            .shuffled()
            .prefix(5)

        var picked = Array(habitTemplates)

        if picked.count < 5 {
            let generalTemplates = MissionTemplate.all
                .filter { $0.habitTitle == nil }
                .shuffled()
                .prefix(5 - picked.count)
            picked += generalTemplates
        }

        for template in picked {
            let habit = selectedHabits.first { $0.title == template.habitTitle }
            let mission = Mission(
                title: template.title(for: tier),
                rewardXP: template.xp(for: tier),
                difficulty: tier + 1,
                isCompleted: false,
                relatedHabit: habit, userId: currentUserId
            )
            modelContext.insert(mission)
        }
    }
}

#Preview {
    HomeView()
}

