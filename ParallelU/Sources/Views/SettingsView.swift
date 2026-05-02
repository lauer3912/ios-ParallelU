import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            List {
                // Appearance
                Section {
                    Toggle(isOn: $appState.isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                            .foregroundColor(.white)
                    }
                    .tint(Color(hex: "00d4ff"))
                } header: {
                    Text("Appearance")
                        .foregroundColor(.gray)
                }
                .listRowBackground(Color(hex: "16213e"))
                
                // Notifications
                Section {
                    Toggle(isOn: $appState.notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                            .foregroundColor(.white)
                    }
                    .tint(Color(hex: "00d4ff"))
                } header: {
                    Text("Notifications")
                        .foregroundColor(.gray)
                }
                .listRowBackground(Color(hex: "16213e"))
                
                // Account
                Section {
                    NavigationLink {
                        Text("Apple Sign In")
                    } label: {
                        Label("Account Linking", systemImage: "apple.logo")
                            .foregroundColor(.white)
                    }
                    
                    NavigationLink {
                        Text("Export Data")
                    } label: {
                        Label("Data Export", systemImage: "square.and.arrow.up")
                            .foregroundColor(.white)
                    }
                } header: {
                    Text("Account")
                        .foregroundColor(.gray)
                }
                .listRowBackground(Color(hex: "16213e"))
                
                // Privacy
                Section {
                    NavigationLink {
                        Text("Privacy Settings")
                    } label: {
                        Label("Privacy Controls", systemImage: "hand.raised.fill")
                            .foregroundColor(.white)
                    }
                    
                    NavigationLink {
                        Text("Blocked Users")
                    } label: {
                        Label("Blocked Users", systemImage: "nosign")
                            .foregroundColor(.white)
                    }
                } header: {
                    Text("Privacy")
                        .foregroundColor(.gray)
                }
                .listRowBackground(Color(hex: "16213e"))
                
                // Theme
                Section {
                    themeSelector
                } header: {
                    Text("App Theme")
                        .foregroundColor(.gray)
                }
                .listRowBackground(Color(hex: "16213e"))
                
                // About
                Section {
                    HStack {
                        Text("Version")
                            .foregroundColor(.white)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    NavigationLink {
                        Text("Privacy Policy")
                    } label: {
                        Label("Privacy Policy", systemImage: "doc.text")
                            .foregroundColor(.white)
                    }
                    
                    NavigationLink {
                        Text("Terms of Service")
                    } label: {
                        Label("Terms of Service", systemImage: "doc.plaintext")
                            .foregroundColor(.white)
                    }
                } header: {
                    Text("About")
                        .foregroundColor(.gray)
                }
                .listRowBackground(Color(hex: "16213e"))
                
                // Delete Account
                Section {
                    Button {
                        // Delete account action
                    } label: {
                        Label("Delete Account", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
                .listRowBackground(Color(hex: "16213e"))
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(hex: "1a1a2e"))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var themeSelector: some View {
        HStack(spacing: 16) {
            ThemeButton(accentColor: "00d4ff", label: "Violet", isSelected: true)
            ThemeButton(accentColor: "00c853", label: "Cyan", isSelected: false)
            ThemeButton(accentColor: "ff006e", label: "Amber", isSelected: false)
        }
    }
}

struct ThemeButton: View {
    let accentColor: String
    let label: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color(hex: accentColor))
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                )
            
            Text(label)
                .font(.caption)
                .foregroundColor(isSelected ? .white : .gray)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}