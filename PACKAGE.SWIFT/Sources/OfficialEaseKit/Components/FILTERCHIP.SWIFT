import SwiftUI
 
public struct FilterChip: View {
    public let label: String
    public let selected: Bool
    public var onTap: () -> Void
 
    public init(label: String, selected: Bool, onTap: @escaping () -> Void) {
        self.label = label; self.selected = selected; self.onTap = onTap
    }
 
    public var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(selected ? Color(hex: "0f1e3d") : .gray)
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(
                    selected ?
                    LinearGradient(
                        colors: [Color(hex: "C9A84C"), Color(hex: "F0C040")],
                        startPoint: .leading, endPoint: .trailing
                    ) :
                    LinearGradient(
                        colors: [Color.white.opacity(0.07), Color.white.opacity(0.07)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .cornerRadius(20)
        }
    }
}
