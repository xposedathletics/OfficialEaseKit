import SwiftUI
 
public struct GameRow: View {
    public let game: OEGame
    public let assignCount: Int
 
    public init(game: OEGame, assignCount: Int) {
        self.game = game
        self.assignCount = assignCount
    }
 
    public var body: some View {
        HStack(spacing: 12) {
            VStack {
                Text(sportEmoji(game.sport)).font(.title2)
                Text(game.sport.prefix(3).uppercased())
                    .font(.system(size: 9, weight: .black)).foregroundColor(.gray)
            }.frame(width: 44)
 
            VStack(alignment: .leading, spacing: 3) {
                Text(game.title)
                    .font(.system(size: 13, weight: .bold)).foregroundColor(.white).lineLimit(1)
                Text("📅 \(game.formattedDate)  📍 \(game.venue_city)")
                    .font(.caption).foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(game.status)
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(Color(hex: game.statusColor))
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color(hex: game.statusColor).opacity(0.15))
                    .cornerRadius(6)
                Text("\(assignCount)/\(game.officials_needed)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(assignCount >= game.officials_needed ?
                                     Color(hex: "1a7a3a") : Color(hex: "C9A84C"))
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.04))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.07), lineWidth: 1))
    }
 
    private func sportEmoji(_ sport: String) -> String {
        switch sport {
        case "Basketball": return "🏀"
        case "Football":   return "🏈"
        case "Soccer":     return "⚽"
        case "Baseball":   return "⚾"
        case "Volleyball": return "🏐"
        case "Lacrosse":   return "🥍"
        case "Hockey":     return "🏒"
        default:           return "🏅"
        }
    }
}
