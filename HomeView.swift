//
//  HomeView.swift
//  Momentum
//
//  Created by Dimitris Poluzos on 31/3/26.
//


import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var showLevelUp = false
    @State private var showDailyGoal = false
    @Query private var habits: [Habit]
    @Query private var missions: [Mission]
    @Query private var progressList: [PlayerProgress]
    @Environment(\.modelContext) private var modelContext

    private var playerProgress: PlayerProgress? {
        progressList.first
    }

    private var displayedMissions: [Mission] {
        let today = missions.filter { Calendar.current.isDateInToday($0.assignedDate) }
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
                                ForEach(habits) { habit in
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

                if progressList.isEmpty {
                    let progress = PlayerProgress(
                        level: 1, currentXP: 0, xpForNextLevel: 100,
                        streak: 0, lastDailyReset: .distantPast,
                        didCompleteDailyGoal: false
                    )
                    modelContext.insert(progress)
                }

                if habits.isEmpty { seedHabits() }

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
            Habit(title: "Workout", isSelected: false, icon: "figure.strengthtraining.traditional"),
            Habit(title: "Read", isSelected: false, icon: "book"),
            Habit(title: "Drink Water", isSelected: true, icon: "drop"),
            Habit(title: "Walk", isSelected: false, icon: "figure.walk"),
            Habit(title: "Meditate", isSelected: false, icon: "brain"),
            Habit(title: "Journal", isSelected: false, icon: "square.and.pencil"),
            Habit(title: "Stretch", isSelected: false, icon: "figure.cooldown"),
            Habit(title: "Sleep Early", isSelected: false, icon: "bed.double"),
            Habit(title: "Study Swift", isSelected: true, icon: "laptopcomputer"),
            Habit(title: "No Sugar", isSelected: false, icon: "leaf")
        ]
        for habit in defaults {
            modelContext.insert(habit)
        }
    }

    private func assignDailyMissions() {
        let today = missions.filter { Calendar.current.isDateInToday($0.assignedDate) }
        guard today.isEmpty else { return }

        let selectedHabits = habits.filter { $0.isSelected }

        var pool: [(title: String, xp: Int, difficulty: Int, habit: Habit?)] = [
            ("Drink 3 bottles of water today", 120, 2, nil),
            ("Help a stranger", 100, 2, nil),
            ("Stay focused for 30 minutes", 70, 1, nil),
            ("Take a 10 minute walk", 60, 1, nil),
        ]

        for habit in selectedHabits {
            switch habit.title {
            case "Workout": pool.append(("Workout 20 minutes", 110, 2, habit))
            case "Read": pool.append(("Read 10 pages", 80, 1, habit))
            case "Drink Water": pool.append(("Drink 2 more glasses of water", 55, 1, habit))
            case "Walk": pool.append(("Walk 15 minutes", 70, 1, habit))
            case "Meditate": pool.append(("Meditate for 5 minutes", 75, 1, habit))
            case "Journal": pool.append(("Write 3 journal lines", 65, 1, habit))
            case "Stretch": pool.append(("Stretch for 5 minutes", 50, 1, habit))
            case "Sleep Early": pool.append(("Sleep before 11 PM", 90, 2, habit))
            case "Study Swift": pool.append(("Study Swift for 20 minutes", 120, 2, habit))
            case "No Sugar": pool.append(("Avoid sugar today", 100, 2, habit))
            default: break
            }
        }

        let picked = pool.shuffled().prefix(5)
        for m in picked {
            let mission = Mission(title: m.title, rewardXP: m.xp, difficulty: m.difficulty, isCompleted: false, relatedHabit: m.habit)
            modelContext.insert(mission)
        }
    }
}

#Preview {
    HomeView()
}
