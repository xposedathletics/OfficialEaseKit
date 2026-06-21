import Foundation
 
public struct OEGame: Codable, Identifiable, Equatable, Sendable {
   public let id: String
   public var title: String
   public var sport: String
   public var date: String
   public var time: String
   public var home_team: String
   public var away_team: String
   public var venue_name: String
   public var venue_city: String
   public var venue_state: String
   public var officials_needed: Int
   public var pay_rate: Double
   public var status: String
   public var level: String?
   public var notes: String?
   public var created_date: String?
 
   public init(
       id: String = UUID().uuidString,
       title: String = "",
       sport: String = "Basketball",
       date: String = "",
       time: String = "",
       home_team: String = "",
       away_team: String = "",
       venue_name: String = "",
       venue_city: String = "",
       venue_state: String = "FL",
       officials_needed: Int = 2,
       pay_rate: Double = 0,
       status: String = "Scheduled",
       level: String? = nil,
       notes: String? = nil,
       created_date: String? = nil
   ) {
       self.id = id
       self.title = title
       self.sport = sport
       self.date = date
       self.time = time
       self.home_team = home_team
       self.away_team = away_team
       self.venue_name = venue_name
       self.venue_city = venue_city
       self.venue_state = venue_state
       self.officials_needed = officials_needed
       self.pay_rate = pay_rate
       self.status = status
       self.level = level
       self.notes = notes
       self.created_date = created_date
   }
 
   // MARK: - Computed
   public var formattedDate: String {
       let df = DateFormatter()
       df.dateFormat = "yyyy-MM-dd"
       guard let d = df.date(from: date) else { return date }
       df.dateStyle = .medium
       return df.string(from: d)
   }
 
   public var statusColor: String {
       switch status {
       case "In Progress": return "1a7a3a"
       case "Completed":   return "555555"
       case "Cancelled":   return "8B1A1A"
       default:            return "C9A84C"
       }
   }
 
   public var isUpcoming: Bool { status == "Scheduled" }
   public var isLive: Bool     { status == "In Progress" }
 
   public static var empty: OEGame { OEGame() }
}
