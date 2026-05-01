import SwiftUI

struct ParallelSelfCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ParallelSelfCreatorViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0F0F14")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Step 1: Universe Name
                        stepSection(title: "1. Name Your Universe", icon: "globe") {
                            TextField("e.g., Universe A, Career Path", text: $viewModel.universeName)
                                .textFieldStyle(ParallelUTextFieldStyle())
                        }
                        
                        // Step 2: Life Paths
                        stepSection(title: "2. Choose Life Paths", icon: "map.fill") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(LifePath.allCases) { path in
                                    LifePathCard(
                                        path: path,
                                        isSelected: viewModel.selectedLifePaths.contains(path)
                                    ) {
                                        viewModel.toggleLifePath(path)
                                    }
                                }
                            }
                        }
                        
                        // Step 3: Universe Theme
                        stepSection(title: "3. Pick Universe Theme", icon: "sparkles") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(UniverseTheme.allThemes) { theme in
                                        UniverseThemeCard(
                                            theme: theme,
                                            isSelected: viewModel.selectedTheme.id == theme.id
                                        ) {
                                            viewModel.selectedTheme = theme
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Step 4: Power Words
                        stepSection(title: "4. Your Power Words", icon: "bolt.fill") {
                            TextField("3 words that define this universe", text: $viewModel.powerWordsText)
                                .textFieldStyle(ParallelUTextFieldStyle())
                                .onChange(of: viewModel.powerWordsText) { _, newValue in
                                    viewModel.updatePowerWords(from: newValue)
                                }
                            
                            if !viewModel.powerWords.isEmpty {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.powerWords, id: \.self) { word in
                                        Text(word)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color(hex: "9B8FE8"))
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        
                        // Step 5: Alternate History
                        stepSection(title: "5. What Changed?", icon: "clock.arrow.circlepath") {
                            TextEditor(text: $viewModel.alternateHistory)
                                .frame(minHeight: 100)
                                .padding(12)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        // Create Button
                        Button(action: {
                            viewModel.createParallelSelf()
                            dismiss()
                        }) {
                            Text("Create Parallel Self")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "9B8FE8"), Color(hex: "6EE7B7")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                        }
                        .disabled(!viewModel.canCreate)
                        .opacity(viewModel.canCreate ? 1 : 0.5)
                        .padding(.top, 16)
                    }
                    .padding()
                }
            }
            .navigationTitle("Create Parallel Self")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(hex: "0F0F14"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "9B8FE8"))
                }
            }
        }
    }
    
    @ViewBuilder
    private func stepSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(Color(hex: "9B8FE8"))
            
            content()
        }
    }
}

// MARK: - Life Path Card

struct LifePathCard: View {
    let path: LifePath
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: path.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : Color(hex: path.color))
                
                Text(path.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                isSelected
                    ? Color(hex: path.color)
                    : Color.white.opacity(0.05)
            )
            .cornerRadius(12)
        }
    }
}

// MARK: - Universe Theme Card

struct UniverseThemeCard: View {
    let theme: UniverseTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: theme.gradientColors.map { Color(hex: $0) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: theme.icon)
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                Text(theme.name)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
            )
        }
    }
}

// MARK: - Text Field Style

struct ParallelUTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            .foregroundColor(.white)
    }
}

// MARK: - ViewModel

@MainActor
final class ParallelSelfCreatorViewModel: ObservableObject {
    @Published var universeName: String = ""
    @Published var selectedLifePaths: Set<LifePath> = []
    @Published var selectedTheme: UniverseTheme = UniverseTheme.allThemes[0]
    @Published var powerWordsText: String = ""
    @Published var powerWords: [String] = []
    @Published var alternateHistory: String = ""
    
    var canCreate: Bool {
        !universeName.isEmpty && !selectedLifePaths.isEmpty
    }
    
    func toggleLifePath(_ path: LifePath) {
        if selectedLifePaths.contains(path) {
            selectedLifePaths.remove(path)
        } else {
            selectedLifePaths.insert(path)
        }
    }
    
    func updatePowerWords(from text: String) {
        let words = text.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        powerWords = Array(words.prefix(3))
    }
    
    func createParallelSelf() {
        let newSelf = ParallelSelf(
            name: "Parallel Self",
            universeName: universeName,
            lifePaths: Array(selectedLifePaths),
            personalityTraits: Array(PersonalityTrait.allTraits.shuffled().prefix(3)),
            talents: [],
            powerWords: powerWords,
            alternateHistory: alternateHistory,
            universeTheme: selectedTheme
        )
        DataManager.shared.addParallelSelf(newSelf)
    }
}

#Preview {
    ParallelSelfCreatorView()
}