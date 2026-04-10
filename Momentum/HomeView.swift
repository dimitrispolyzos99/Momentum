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
                    
                    ForEach($viewModel.missions) { $mission in
                        MissionCardView(mission: mission, onToggle: { viewModel.completeMission(mission) })
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
                                    habit: habit, onToggle: {viewModel.toggleHabitdSelection(habit)})
                            }
                            }
                        }
                    }

                }
            .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}

