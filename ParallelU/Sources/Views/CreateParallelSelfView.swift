import SwiftUI

struct CreateParallelSelfView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedLifePath: LifePath = .career
    @State private var personality: String = ""
    @State private var background: String = "Cosmic Purple"
    @State private var powerWords: [String] = ["", "", ""]
    @State private var selectedEmotions: [Emotion] = []
    @State private var talents: [String] = ["", ""]
    @State private var universeName: String = ""
    @State private var currentStep: Int = 0
    
    let lifePaths = LifePath.allCases
    let backgrounds = ["Cosmic Purple", "Deep Blue", "Nebula Pink", "Galaxy Gold", "Stellar Green", "Aurora Cyan"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Progress indicator
                    progressIndicator
                    
                    // Step content
                    stepContent
                    
                    // Navigation buttons
                    navigationButtons
                }
                .padding()
            }
            .navigationTitle("Create Parallel Self")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(hex: "1a1a2e"))
        }
    }
    
    private var progressIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<5, id: \.self) { step in
                Rectangle()
                    .fill(step <= currentStep ? Color(hex: "00d4ff") : Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .cornerRadius(2)
            }
        }
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            lifePathSelection
        case 1:
            personalityStep
        case 2:
            appearanceStep
        case 3:
            powerWordsStep
        case 4:
            finalStep
        default:
            EmptyView()
        }
    }
    
    private var lifePathSelection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Life Path")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Select the dimension that defines this parallel self")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(lifePaths, id: \.self) { path in
                    LifePathCard(path: path, isSelected: selectedLifePath == path)
                        .onTapGesture {
                            withAnimation { selectedLifePath = path }
                        }
                }
            }
        }
    }
    
    private var personalityStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personality")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Describe this parallel self's personality")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("e.g., Ambitious, Creative, Calm", text: $personality)
                .textFieldStyle(.plain)
                .padding()
                .background(Color(hex: "16213e"))
                .cornerRadius(12)
                .foregroundColor(.white)
            
            Text("Select emotions")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(Emotion.allCases, id: \.self) { emotion in
                    EmotionChip(emotion: emotion, isSelected: selectedEmotions.contains(emotion))
                        .onTapGesture {
                            if selectedEmotions.contains(emotion) {
                                selectedEmotions.removeAll { $0 == emotion }
                            } else if selectedEmotions.count < 3 {
                                selectedEmotions.append(emotion)
                            }
                        }
                }
            }
        }
    }
    
    private var appearanceStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Universe Appearance")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Select cosmic background theme")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(backgrounds, id: \.self) { bg in
                        BackgroundCard(background: bg, isSelected: background == bg)
                            .onTapGesture {
                                withAnimation { background = bg }
                            }
                    }
                }
            }
        }
    }
    
    private var powerWordsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Power Words")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Choose 3 signature words for this parallel self")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ForEach(0..<3, id: \.self) { index in
                TextField("Power word \(index + 1)", text: $powerWords[index])
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color(hex: "16213e"))
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
            
            Text("Select talents")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)
            
            ForEach(0..<2, id: \.self) { index in
                TextField("Talent \(index + 1)", text: $talents[index])
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color(hex: "16213e"))
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var finalStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Name Your Universe")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            TextField("e.g., Universe-A", text: $universeName)
                .textFieldStyle(.plain)
                .padding()
                .background(Color(hex: "16213e"))
                .cornerRadius(12)
                .foregroundColor(.white)
            
            // Summary
            VStack(alignment: .leading, spacing: 8) {
                summaryRow("Life Path", selectedLifePath.rawValue)
                summaryRow("Personality", personality.isEmpty ? "Not set" : personality)
                summaryRow("Background", background)
                summaryRow("Power Words", powerWords.filter { !$0.isEmpty }.joined(separator: ", "))
                summaryRow("Talents", talents.filter { !$0.isEmpty }.joined(separator: ", "))
            }
            .padding()
            .background(Color(hex: "16213e"))
            .cornerRadius(12)
        }
    }
    
    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            if currentStep > 0 {
                Button("Back") {
                    withAnimation { currentStep -= 1 }
                }
                .foregroundColor(Color(hex: "00d4ff"))
            }
            
            Spacer()
            
            if currentStep < 4 {
                Button("Next") {
                    withAnimation { currentStep += 1 }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color(hex: "00d4ff"))
                .foregroundColor(.black)
                .cornerRadius(12)
            } else {
                Button("Create") {
                    createParallelSelf()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color(hex: "00d4ff"))
                .foregroundColor(.black)
                .cornerRadius(12)
            }
        }
        .padding(.top)
    }
    
    private func createParallelSelf() {
        appState.createParallelSelf(
            name: universeName.isEmpty ? "New Universe" : universeName,
            lifePath: selectedLifePath,
            personality: personality,
            background: background,
            powerWords: powerWords.filter { !$0.isEmpty },
            emotionPalette: selectedEmotions,
            talents: talents.filter { !$0.isEmpty }
        )
        currentStep = 0
        universeName = ""
        personality = ""
        selectedLifePath = .career
    }
}

struct LifePathCard: View {
    let path: LifePath
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: path.icon)
                .font(.title)
                .foregroundColor(isSelected ? path.color : .gray)
            
            Text(path.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? path.color.opacity(0.2) : Color(hex: "16213e"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? path.color : Color.clear, lineWidth: 2)
                )
        )
    }
}

struct EmotionChip: View {
    let emotion: Emotion
    let isSelected: Bool
    
    var body: some View {
        Text(emotion.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isSelected ? emotion.color.opacity(0.3) : Color(hex: "16213e"))
                    .overlay(
                        Capsule()
                            .stroke(isSelected ? emotion.color : Color.clear, lineWidth: 1)
                    )
            )
            .foregroundColor(isSelected ? emotion.color : .gray)
    }
}

struct BackgroundCard: View {
    let background: String
    let isSelected: Bool
    
    var backgroundColor: Color {
        switch background {
        case "Cosmic Purple": return Color(hex: "6b4c9a")
        case "Deep Blue": return Color(hex: "1e3a5f")
        case "Nebula Pink": return Color(hex: "e91e8c")
        case "Galaxy Gold": return Color(hex: "d4af37")
        case "Stellar Green": return Color(hex: "00c853")
        case "Aurora Cyan": return Color(hex: "00d4ff")
        default: return Color(hex: "6b4c9a")
        }
    }
    
    var body: some View {
        Text(background)
            .font(.caption)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(backgroundColor.opacity(isSelected ? 0.8 : 0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                    )
            )
            .foregroundColor(.white)
    }
}

#Preview {
    CreateParallelSelfView()
        .environmentObject(AppState())
}