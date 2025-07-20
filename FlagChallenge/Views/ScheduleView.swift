//
//  ScheduleView.swift
//  FlagChallenge
//
//  Created by Farhan Ettappurath Sulaiman on 19/07/25.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: QuizViewModel
    @State private var scheduledTime = Date()
    @State private var isSaving = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // header
                VStack(spacing: 20) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryOrange, Color(hex: "#E64A19")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "flag.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                        )
                        .shadow(color: Color.primaryOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    VStack(spacing: 6) {
                        Text("Schedule Challenge")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Set your preferred time")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.top, 30)
                
                VStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("START TIME")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(0.5)
                        
                        Text(scheduledTime, style: .time)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    DatePicker(
                        "",
                        selection: $scheduledTime,
                        in: Date()...,
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .scaleEffect(1.1)
                    .frame(height: 40)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
                
                VStack(spacing: 12) {
                    Text("Quick Select")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 12) {
                        quickTimeButton(minutes: 1, label: "1 min")
                        quickTimeButton(minutes: 5, label: "5 min")
                        quickTimeButton(minutes: 15, label: "15 min")
                        quickTimeButton(minutes: 30, label: "30 min")
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer(minLength: 20)
                
                VStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            isSaving = true
                        }
                        
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        let calendar = Calendar.current
                        let timeComponents = calendar.dateComponents([.hour, .minute], from: scheduledTime)
                        let scheduledDateTime = calendar.date(
                            bySettingHour: timeComponents.hour ?? 0,
                            minute: timeComponents.minute ?? 0,
                            second: 0,
                            of: Date()
                        ) ?? scheduledTime
                        
                        viewModel.scheduleGame(startTime: scheduledDateTime)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                isSaving = false
                            }
                        }
                    }) {
                        HStack(spacing: 12) {
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(0.9)
                            } else {
                                Image(systemName: "clock.badge.checkmark")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                            
                            Text(isSaving ? "Saving..." : "Save")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Group {
                                if isSaving {
                                    Color.primaryOrange.opacity(0.8)
                                } else {
                                    LinearGradient(
                                        colors: [Color.primaryOrange, Color(hex: "#E64A19")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            }
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .scaleEffect(isSaving ? 0.98 : 1.0)
                        .shadow(color: Color.primaryOrange.opacity(0.3), radius: 12, x: 0, y: 6)
                    }
                    .disabled(isSaving)
                    .padding(.horizontal, 20)
                    
                    Text("Auto starts 20 seconds early")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(.bottom, 30)
        }
//        .background(
//            LinearGradient(
//                colors: [
//                    Color(hex: "#1A1A2E"),
//                    Color(hex: "#16213E"),
//                    Color(hex: "#0F3460")
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea(.all)
//        )
        .onAppear {
            scheduledTime = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
        }
    }
    
    //MARK: Helper 
    private func quickTimeButton(minutes: Int, label: String) -> some View {
        Button(action: {
            scheduledTime = Calendar.current.date(byAdding: .minute, value: minutes, to: Date()) ?? Date()
            
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ScheduleView(viewModel: QuizViewModel())
}
