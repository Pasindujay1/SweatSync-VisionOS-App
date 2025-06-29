import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack {
            if let selected = appModel.selectedWorkout {
                Text(selected.name)
                    .font(.system(size: 48, weight: .bold))
                    .padding(.top, 24)
                ScrollView {
                    VStack(spacing: 32) {
                        ForEach(selected.exercises.indices, id: \.self) { idx in
                            ExerciseRow(
                                exercise: selected.exercises[idx],
                                onComplete: {
                                    appModel.selectedWorkout?.exercises[idx].completed.toggle()
                                    if let widx = appModel.workouts.firstIndex(where: { $0.id == selected.id }) {
                                        appModel.workouts[widx].exercises[idx].completed = appModel.selectedWorkout?.exercises[idx].completed ?? false
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 32)
                }
                Button("Back to Workouts") {
                    appModel.selectedWorkout = nil
                }
                .font(.system(size: 28, weight: .semibold))
                .padding(24)
            } else {
                // Show workout names
                Text("Select a Workout")
                    .font(.system(size: 48, weight: .bold))
                    .padding(.top, 24)
                VStack(spacing: 36) {
                    ForEach(appModel.workouts) { workout in
                        Button {
                            appModel.selectedWorkout = workout
                        } label: {
                            HStack {
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .font(.system(size: 36))
                                    .foregroundColor(.blue)
                                Text(workout.name)
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 28))
                                    .foregroundColor(.gray)
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue.opacity(0.12), Color.white]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .blue.opacity(0.08), radius: 8, x: 0, y: 4)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(24)
            }
        }
        .padding(24)
     
        
    }
}

struct ExerciseRow: View {
    var exercise: Exercise
    var onComplete: () -> Void

    @State private var completedSets: Int = 0

    var body: some View {
        HStack(alignment: .center, spacing: 32) {
            Image(systemName: completedSets == exercise.sets ? "checkmark.seal.fill" : "dumbbell.fill")
                .foregroundColor(completedSets == exercise.sets ? .green : .blue)
                .font(.system(size: 36))
                .padding(.leading, 8)

            VStack(alignment: .leading, spacing: 12) {
                Text(exercise.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                // set bat graph
                HStack(spacing: 12) {
                    ForEach(0..<exercise.sets, id: \.self) { i in
                        Capsule()
                            .fill(
                                i < completedSets
                                ? LinearGradient(colors: [Color.green, Color.green.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                                : LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(width: 36, height: 18)
                            .shadow(color: i < completedSets ? .green.opacity(0.3) : .clear, radius: 3, x: 0, y: 2)
                            .animation(.easeInOut(duration: 0.3), value: completedSets)
                    }
                }
            }
            Spacer()
            VStack(spacing: 12) {
                Button("Complete Set") {
                    if completedSets < exercise.sets {
                        completedSets += 1
                        if completedSets == exercise.sets {
                            onComplete()
                        }
                    }
                }
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(completedSets < exercise.sets ? Color.green.opacity(0.8) : Color.gray.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(completedSets >= exercise.sets)

                Button(action: onComplete) {
                    HStack {
                        Image(systemName: completedSets == exercise.sets ? "checkmark.circle.fill" : "circle")
                        Text(completedSets == exercise.sets ? "Done" : "Complete")
                    }
                }
                .font(.system(size: 22, weight: .semibold))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(completedSets == exercise.sets ? Color.green.opacity(0.8) : Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                .disabled(completedSets < exercise.sets)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.07)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .padding(.vertical, 10)
        .animation(.easeInOut, value: completedSets)
    }
}
