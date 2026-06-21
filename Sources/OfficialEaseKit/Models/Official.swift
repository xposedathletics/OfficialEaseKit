import Foundation
 
public struct Official: Codable, Identifiable, Equatable, Sendable {
   public let id: String
   public var full_name: String
   public var email: String
   public var phone: String?
   public var role: String
   public var sports: [String]
   public var certification_level: String
   public var wearable_device: String?
   public var wearable_connected: Bool?
   public var push_notifications_enabled: Bool?
   public var notification_token: String?
   public var avatar_url: String?
   public var status: String
   public var linked_game_ids: [String]?
   public var created_date: String?
 
   public init(
       id: String = UUID().uuidString,
       full_name: String,
       email: String,
       phone: String? = nil,
       role: String = "referee",
       sports: [String] = [],
       certification_level: String = "Certified",
       wearable_device: String? = nil,
       wearable_connected: Bool? = false,
       push_notifications_enabled: Bool? = true,
       notification_token: String? = nil,
       avatar_url: String? = nil,
       status: String = "active",
       linked_game_ids: [String]? = [],
       created_date: String? = nil
   ) {
       self.id = id
       self.full_name = full_name
       self.email = email
       self.phone = phone
       self.role = role
       self.sports = sports
       self.certification_level = certification_level
       self.wearable_device = wearable_device
       self.wearable_connected = wearable_connected
       self.push_notifications_enabled = push_notifications_enabled
       self.notification_token = notification_token
       self.avatar_url = avatar_url
       self.status = status
       self.linked_game_ids = linked_game_ids
       self.created_date = created_date
   }
 
   // MARK: - Computed
   public var isActive: Bool { status == "active" }
 
   public var initials: String {
       let parts = full_name.split(separator: " ")
       let first = parts.first.map { String($0.prefix(1)) } ?? ""
       let last  = parts.last.map  { String($0.prefix(1)) } ?? ""
       return (first + last).uppercased()
   }
 
   public var certColor: String {
       switch certification_level {
       case "Elite":    return "F0C040"
       case "Master":   return "a78bfa"
       case "Advanced": return "60a5fa"
       default:         return "1a7a3a"
       }
   }
 
   public var sportsList: String {
       sports.isEmpty ? "No sports listed" : sports.joined(separator: ", ")
   }
 
   public static var empty: Official {
       Official(full_name: "", email: "")
   }
}
