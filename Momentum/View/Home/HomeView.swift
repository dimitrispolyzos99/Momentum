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

    private var userHabits: [Habit] {
        habits.filter { $0.userId == currentUserId && $0.isSelected }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.black.ignoresSafeArea()
                RadialGradient(
                    colors: [Color.purple.opacity(0.35), Color.clear],
                    center: .top, startRadius: 0, endRadius: 300
                ).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {

                        // Level Card
                        if let progress = playerProgress {
                            LevelCardView(progress: progress)
                        }

                        // Missions Section
                        VStack(spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Today's Missions")
                                        .font(.title2).bold()
                                        .foregroundColor(.white)
                                    Text("\(displayedMissions.filter { $0.isCompleted }.count)/\(displayedMissions.count) completed")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                            }
                            .padding(.horizontal)

                            ForEach(displayedMissions) { mission in
                                MissionCardView(
                                    mission: mission,
                                    onToggle: {
                                        if let progress = playerProgress {
                                            viewModel.completeMission(
                                                mission,
                                                progress: progress,
                                                missions: displayedMissions
                                            )
                                        }
                                    }
                                )
                            }
                        }

                        // Habits Section
                        VStack(spacing: 10) {
                            HStack {
                                Text("Habits")
                                    .font(.title2).bold()
                                    .foregroundColor(.white)
                                Spacer()
                                NavigationLink("View all") {
                                    HabitsView()
                                }
                                .font(.subheadline)
                                .foregroundColor(.purple)
                            }
                            .padding(.horizontal)

                            if userHabits.isEmpty {
                                Text("No habits selected. Tap 'View all' to add some!")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.4))
                                    .padding()
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(userHabits) { habit in
                                            HabitsCardView(
                                                habit: habit,
                                                onToggle: { habit.isSelected.toggle() }
                                            )
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }

                        Spacer().frame(height: 20)
                    }
                    .padding(.vertical)
                }

                // Overlays
                if showLevelUp, let progress = playerProgress {
                    LevelUpOverlayView(level: progress.level) {
                        showLevelUp = false
                    }
                }
                if showDailyGoal {
                    DailyGoalView { showDailyGoal = false }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        try? Auth.auth().signOut()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log out")
                                .font(.caption)
                        }
                        .foregroundColor(.white.opacity(0.6))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        MainMessagesView()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Chat")
                                .font(.caption)
                        }
                        .foregroundColor(.purple)
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

                if habits.filter({ $0.userId == currentUserId }).isEmpty {
                    viewModel.seedHabits(context: modelContext, userId: currentUserId)
                }

                try? await Task.sleep(nanoseconds: 100_000_000)
                
                viewModel.assignDailyMissions(
                    context: modelContext,
                    habits: habits,
                    missions: missions,
                    progress: playerProgress,
                    userId: currentUserId
                )

                if let progress = playerProgress {
                    viewModel.checkDailyReset(missions: missions, progress: progress)
                }
            }
        }
        .onChange(of: viewModel.didLevelUp) { _, newValue in
            if newValue { showLevelUp = true; viewModel.didLevelUp = false }
        }
        .onChange(of: viewModel.dailyGoal) { _, newValue in
            if newValue { showDailyGoal = true; viewModel.dailyGoal = false }
        }
    }
}

#Preview {
    HomeView()
}

