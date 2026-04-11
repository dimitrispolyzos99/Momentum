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
    @Query private var habits: [Habit]
    @Query private var missions: [Mission]
    
    private var displayedMissions: [Mission] {
        let selectedHabits = habits.filter { $0.isSelected }
        
        return missions.filter { missions in
            if let relatedHabit = missions.relatedHabit {
                return selectedHabits.contains(where : { $0.id == relatedHabit.id})
            } else {
                return true
            }
        }
        .prefix(5)
        .map { $0 }
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
                    LevelCardView(progress: viewModel.playerProgress)
                    
                    Text("Today's Missions")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    
                    ForEach(displayedMissions) { mission in
                        MissionCardView(
                            mission: mission,
                            onToggle: {
                                viewModel.completeMission(mission, missions: displayedMissions)
                            }
                        )
                    }
                    
                    HStack{
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
                }
                ScrollView(.horizontal, showsIndicators: false){
                        HStack (spacing: 12){
                        ForEach(habits) { habit in
                            if habit.isSelected {
                                HabitsCardView(
                                    habit: habit, onToggle: {habit.isSelected.toggle()})
                            }
                            }
                        }
                    }

                }
            .padding()
            }
        }
        .onAppear {
            viewModel.checkDailyReset(missions: missions)
        }

    }
}

#Preview {
    HomeView()
}

