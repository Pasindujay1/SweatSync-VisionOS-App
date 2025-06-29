//
//  AppModel.swift
//  SweatSyncV2Vision
//
//  Created by Pasindu Jayasinghe on 6/25/25.
//
import SwiftUI

struct Exercise: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let sets: Int
    var completed: Bool = false
}

struct Workout: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var exercises: [Exercise]
}

@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveView"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed

    
    var workouts: [Workout] = [
        Workout(name: "Push Day", exercises: [
            Exercise(name: "Bench Press", sets: 4),
            Exercise(name: "Shoulder Press", sets: 3),
            Exercise(name: "Triceps Extension", sets: 3)
        ]),
        Workout(name: "Pull Day", exercises: [
            Exercise(name: "Pull Ups", sets: 4),
            Exercise(name: "Barbell Row", sets: 3),
            Exercise(name: "Biceps Curl", sets: 3)
        ]),
        Workout(name: "Leg Day", exercises: [
            Exercise(name: "Squats", sets: 4),
            Exercise(name: "Lunges", sets: 3),
            Exercise(name: "Calf Raise", sets: 3)
        ])
    ]

    
    var selectedWorkout: Workout? = nil
}
