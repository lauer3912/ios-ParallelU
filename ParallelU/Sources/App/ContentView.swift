import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(hex: "0F0F14")
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("ParallelU")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "9B8FE8"), Color(hex: "6EE7B7")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Your Parallel Universe Awaits")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "9B8FE8"), Color(hex: "6EE7B7"), Color(hex: "FCD34D")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(.bottom, 40)
            }
            .padding(.top, 60)
        }
    }
}

#Preview {
    ContentView()
}
