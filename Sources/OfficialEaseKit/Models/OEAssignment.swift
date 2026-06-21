import Foundation
 
public struct OEAssignment: Codable, Identifiable, Equatable, Sendable {
   public let id: String
   public var game_id: String
   public var game_title: String
   public var game_date: String
   public var official_id: String
   public var official_name: String
   public var role: String
   public var status: String
   public var pay_amount: Double
   public var notes: String?
   public var created_date: String?
 
   public init(
       id: String = UUID().uuidString,
       game_id: String = "",
       game_title: String = "",
       game_date: String = "",
       official_id: String = "",
       official_name: String = "",
       role: String = "Referee",
       status: String = "Assigned",
       pay_amount: Double = 0,
       notes: String? = nil,
       created_date: String? = nil
   ) {
       self.id = id
       self.game_id = game_id
       self.game_title = game_title
       self.game_date = game_date
       self.official_id = official_id
       self.official_name = official_name
       self.role = role
       self.status = status
       self.pay_amount = pay_amount
       self.notes = notes
       self.created_date = created_date
   }
 
   public var statusColor: String {
       switch status {
       case "Accepted": return "1a7a3a"
       case "Declined": return "8B1A1A"
       case "Paid":     return "C9A84C"
       default:         return "2E6DA4"
       }
   }
 
   public var isPaid: Bool     { status == "Paid" }
   public var isAccepted: Bool { status == "Accepted" }
 
   public static var empty: OEAssignment { OEAssignment() }
}
