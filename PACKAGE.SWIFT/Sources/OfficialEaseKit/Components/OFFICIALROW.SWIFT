import SwiftUI
 
public struct OfficialRow: View {
    public let official: Official
    public var onStatusChange: (String) -> Void
 
    public init(official: Official, onStatusChange: @escaping (String) -> Void) {
        self.official = official
        self.onStatusChange = onStatusChange
    }
 
    public var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: official.certColor).opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(official.initials)
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(Color(hex: official.certColor))
                )
 
            VStack(alignment: .leading, spacing: 3) {
                Text(official.full_name)
                    .font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                Text(official.email).font(.caption).foregroundColor(.gray).lineLimit(1)
                Text(official.sportsList).font(.caption).foregroundColor(.gray).lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(official.certification_level)
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(Color(hex: official.certColor))
                    .padding(.horizontal, 7).padding(.vertical, 2)
                    .background(Color(hex: official.certColor).opacity(0.15))
                    .cornerRadius(6)
                Button(action: { onStatusChange(official.isActive ? "inactive" : "active") }) {
                    Text(official.isActive ? "Active" : "Inactive")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(official.isActive ? Color(hex: "1a7a3a") : .gray)
                }
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.04))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.07), lineWidth: 1))
    }
}

