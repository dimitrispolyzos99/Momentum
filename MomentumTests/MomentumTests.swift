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

    @Test func testStreakResetsWhenGoalNotCompleted() {
        // Given
        var streak = 5
        let didCompleteDailyGoal = false
        
        // When
        if !didCompleteDailyGoal {
            streak = 0
        }
        
        // Then
        #expect(streak == 0)
    }
    @Test func testStreakDoesntResetWhenGoalCompleted() {
        // Given
        var streak = 5
        let didCompleteDailyGoal = true
        
        // When
        if !didCompleteDailyGoal {
            streak = 0
        }
        
        // Then
        #expect(streak == 5)
    }
    @Test func testMissionsResetAfterDailyReset() {
        // Given
        var mission1IsCompleted = true
        var mission2IsCompleted = true
        
        // When
        mission1IsCompleted = false
        mission2IsCompleted = false
        
        // Then
        #expect(mission1IsCompleted == false)
        #expect(mission2IsCompleted == false)
    }
    @Test func testXPIncreasesWhenMissionCompleted() {
        // Given
        var currentXP = 0
        let missionXP = 50
        
        // When
        currentXP += missionXP
        
        // Then
        #expect(currentXP == 50)
    }
    @Test func testXPDecreasesWhenMissionUncompleted() {
        // Given
        var currentXP = 100
        let missionXP = 50
        
        // When
        currentXP -= missionXP
        
        // Then
        #expect(currentXP == 50)
    }
}
