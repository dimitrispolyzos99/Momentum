//
//  MomentumTests.swift
//  MomentumTests
//
//  Created by Dimitris Poluzos on 5/5/26.
//

import Testing
@testable import Momentum
import Foundation


struct MomentumTests {

    // MARK: - completeMission XP Tests

    @Test func testXPIncreasesWhenMissionCompleted() {
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 0, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission = Mission(
            title: "Test", rewardXP: 50,
            difficulty: 1, isCompleted: false,
            relatedHabit: nil, userId: "test"
        )

        viewModel.completeMission(mission, progress: progress, missions: [mission])

        #expect(progress.currentXP == 50)
    }

    @Test func testXPDecreasesWhenMissionUncompleted() {
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 50, xpForNextLevel: 100,
            streak: 0, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission = Mission(
            title: "Test", rewardXP: 50,
            difficulty: 1, isCompleted: true,
            relatedHabit: nil, userId: "test"
        )

        viewModel.completeMission(mission, progress: progress, missions: [mission])

        #expect(progress.currentXP == 0)
    }

    @Test func testXPDoesNotGoBelowZeroAtLevelOne() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 0, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission = Mission(
            title: "Test", rewardXP: 50,
            difficulty: 1, isCompleted: true, // uncomplete — θα αφαιρέσει XP
            relatedHabit: nil, userId: "test"
        )

        // When
        viewModel.completeMission(mission, progress: progress, missions: [mission])

        // Then
        #expect(progress.currentXP == 0)
    }

    @Test func testXPCorrectAfterMultipleMissions() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 0, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission1 = Mission(title: "M1", rewardXP: 30, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
        let mission2 = Mission(title: "M2", rewardXP: 20, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")

        // When
        viewModel.completeMission(mission1, progress: progress, missions: [mission1, mission2])
        viewModel.completeMission(mission2, progress: progress, missions: [mission1, mission2])

        // Then
        #expect(progress.currentXP == 50)
    }

    // MARK: - Level Up Tests

    @Test func testLevelUpWhenXPReachesThreshold() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 80, xpForNextLevel: 100,
            streak: 0, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission = Mission(title: "Test", rewardXP: 50, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")

        // When
        viewModel.completeMission(mission, progress: progress, missions: [mission])

        // Then
        #expect(progress.level == 2)
    }

    @Test func testXPCarriesOverAfterLevelUp() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 80, xpForNextLevel: 100,
            streak: 0, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission = Mission(title: "Test", rewardXP: 50, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")

        // When
        viewModel.completeMission(mission, progress: progress, missions: [mission])

        // Then — 80+50=130, level up, 130-100=30 carry over
        #expect(progress.currentXP == 30)
    }

    @Test func testLevelDoesNotDecreaseAtLevelOne() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 0, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission = Mission(title: "Test", rewardXP: 50, difficulty: 1, isCompleted: true, relatedHabit: nil, userId: "test")

        // When
        viewModel.completeMission(mission, progress: progress, missions: [mission])

        // Then
        #expect(progress.level == 1)
    }

    // MARK: - Daily Goal Tests

    // TODO: Daily goal bonus test requires refactor of completeMission
    // to not depend on external missions array for completed count
//    @Test func testDailyGoalBonusXPAfterThreeMissions() {
//        // Given
//        let viewModel = HomeViewModel()
//        let progress = PlayerProgress(
//            level: 1, currentXP: 0, xpForNextLevel: 100,
//            streak: 0, lastDailyReset: .distantPast,
//            didCompleteDailyGoal: false, userId: "test"
//        )
//        let m1 = Mission(title: "M1", rewardXP: 10, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
//        let m2 = Mission(title: "M2", rewardXP: 10, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
//        let m3 = Mission(title: "M3", rewardXP: 10, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
//        let missions = [m1, m2, m3]
//
//        // When — complete 3 missions
//        viewModel.completeMission(m1, progress: progress, missions: missions)
//        viewModel.completeMission(m2, progress: progress, missions: missions)
//        viewModel.completeMission(m3, progress: progress, missions: missions)
//
//        // Then — 10+10+10+150 bonus = 170
//        #expect(progress.currentXP == 170)
//    }

    @Test func testStreakIncreasesAfterDailyGoal() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 3, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let m1 = Mission(title: "M1", rewardXP: 10, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
        let m2 = Mission(title: "M2", rewardXP: 10, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
        let m3 = Mission(title: "M3", rewardXP: 10, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
        let missions = [m1, m2, m3]

        // When
        viewModel.completeMission(m1, progress: progress, missions: missions)
        viewModel.completeMission(m2, progress: progress, missions: missions)
        viewModel.completeMission(m3, progress: progress, missions: missions)

        // Then
        #expect(progress.streak == 4)
    }

    @Test func testDailyGoalBonusNotGivenTwice() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 0, lastDailyReset: .distantPast,
            didCompleteDailyGoal: true, // ήδη έγινε goal
            userId: "test"
        )
        let m1 = Mission(title: "M1", rewardXP: 10, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
        let m2 = Mission(title: "M2", rewardXP: 10, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
        let m3 = Mission(title: "M3", rewardXP: 10, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")
        let missions = [m1, m2, m3]

        // When
        viewModel.completeMission(m1, progress: progress, missions: missions)
        viewModel.completeMission(m2, progress: progress, missions: missions)
        viewModel.completeMission(m3, progress: progress, missions: missions)

        // Then — μόνο 30 XP, χωρίς bonus
        #expect(progress.currentXP == 30)
    }

    // MARK: - checkDailyReset Tests

    @Test func testStreakResetsWhenGoalNotCompleted() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 5, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission = Mission(title: "Test", rewardXP: 50, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")

        // When
        viewModel.checkDailyReset(missions: [mission], progress: progress)

        // Then
        #expect(progress.streak == 0)
    }

    @Test func testStreakDoesNotResetWhenGoalCompleted() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 5, lastDailyReset: .distantPast,
            didCompleteDailyGoal: true, userId: "test"
        )
        let mission = Mission(title: "Test", rewardXP: 50, difficulty: 1, isCompleted: false, relatedHabit: nil, userId: "test")

        // When
        viewModel.checkDailyReset(missions: [mission], progress: progress)

        // Then
        #expect(progress.streak == 5)
    }

    @Test func testMissionsResetAfterDailyReset() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 0, lastDailyReset: .distantPast,
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission = Mission(title: "Test", rewardXP: 50, difficulty: 1, isCompleted: true, relatedHabit: nil, userId: "test")

        // When
        viewModel.checkDailyReset(missions: [mission], progress: progress)

        // Then
        #expect(mission.isCompleted == false)
    }

    @Test func testDailyResetDoesNotRunSameDay() {
        // Given
        let viewModel = HomeViewModel()
        let progress = PlayerProgress(
            level: 1, currentXP: 0, xpForNextLevel: 100,
            streak: 5, lastDailyReset: Date(), // σήμερα
            didCompleteDailyGoal: false, userId: "test"
        )
        let mission = Mission(title: "Test", rewardXP: 50, difficulty: 1, isCompleted: true, relatedHabit: nil, userId: "test")

        // When
        viewModel.checkDailyReset(missions: [mission], progress: progress)

        // Then — τίποτα δεν αλλάζει γιατί είναι ίδια μέρα
        #expect(progress.streak == 5)
        #expect(mission.isCompleted == true)
    }

    // MARK: - LoginViewModel Validation Tests

    @Test func testValidEmailPassesValidation() {
        // Given
        let viewModel = LoginViewModel()

        // When
        viewModel.email = "dimitris@gmail.com"

        // Then
        #expect(viewModel.isEmailValid == true)
    }

    @Test func testInvalidEmailFailsValidation() {
        // Given
        let viewModel = LoginViewModel()

        // When
        viewModel.email = "not-an-email"

        // Then
        #expect(viewModel.isEmailValid == false)
    }

    @Test func testEmailWithoutDomainFailsValidation() {
        let viewModel = LoginViewModel()
        viewModel.email = "dimitris@"
        #expect(viewModel.isEmailValid == false)
    }

    @Test func testCanSubmitFalseWhenPasswordEmpty() {
        // Given
        let viewModel = LoginViewModel()

        // When
        viewModel.email = "dimitris@gmail.com"
        viewModel.password = ""

        // Then
        #expect(viewModel.canSubmit == false)
    }

    @Test func testCanSubmitFalseWhenEmailEmpty() {
        // Given
        let viewModel = LoginViewModel()

        // When
        viewModel.email = ""
        viewModel.password = "123456"

        // Then
        #expect(viewModel.canSubmit == false)
    }

    @Test func testCanSubmitTrueWhenBothValid() {
        // Given
        let viewModel = LoginViewModel()

        // When
        viewModel.email = "dimitris@gmail.com"
        viewModel.password = "123456"

        // Then
        #expect(viewModel.canSubmit == true)
    }
}
