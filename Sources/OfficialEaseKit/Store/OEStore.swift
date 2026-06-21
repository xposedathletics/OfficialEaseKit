import SwiftUI
 
@MainActor
public final class OEStore: ObservableObject {
 
   @Published public var officials:   [Official]     = []
   @Published public var games:       [OEGame]       = []
   @Published public var assignments: [OEAssignment] = []
   @Published public var isLoading:   Bool           = false
   @Published public var errorMsg:    String?
 
   public let api: Base44Client
 
   public init(client: Base44Client = .shared) {
       self.api = client
   }
 
   public func loadAll() async {
       isLoading = true
       officials   = await safeList(entity: "RefUser")
       games       = await safeList(entity: "OEGame")
       assignments = await safeList(entity: "OEAssignment")
       isLoading   = false
   }
 
   private func safeList<T: Decodable>(entity: String) async -> [T] {
       let result: [T]? = try? await api.list(entity: entity)
       return result ?? []
   }
 
   public func addOfficial(_ o: Official) async {
       guard !o.full_name.isEmpty else { return }
       let created: Official? = try? await api.create(entity: "RefUser", body: o)
       if let created = created { officials.append(created) }
   }
 
   public func updateOfficialStatus(id: String, status: String) async {
       struct Patch: Codable { let status: String }
       let patch = Patch(status: status)
       let updated: Official? = try? await api.update(entity: "RefUser", id: id, body: patch)
       if let updated = updated {
           if let idx = officials.firstIndex(where: { $0.id == id }) {
               officials[idx] = updated
           }
       }
   }
 
   public func deleteOfficial(id: String) async {
       try? await api.delete(entity: "RefUser", id: id)
       officials.removeAll { $0.id == id }
   }
 
   public func addGame(_ g: OEGame) async {
       guard !g.home_team.isEmpty else { return }
       let created: OEGame? = try? await api.create(entity: "OEGame", body: g)
       if let created = created { games.append(created) }
   }
 
   public func updateGameStatus(id: String, status: String) async {
       struct Patch: Codable { let status: String }
       let patch = Patch(status: status)
       let updated: OEGame? = try? await api.update(entity: "OEGame", id: id, body: patch)
       if let updated = updated {
           if let idx = games.firstIndex(where: { $0.id == id }) {
               games[idx] = updated
           }
       }
   }
 
   public func deleteGame(id: String) async {
       try? await api.delete(entity: "OEGame", id: id)
       games.removeAll { $0.id == id }
   }
 
   public func assign(game: OEGame, official: Official) async {
       let a = OEAssignment(
           game_id: game.id,
           game_title: game.title,
           game_date: game.date,
           official_id: official.id,
           official_name: official.full_name,
           role: "Referee",
           status: "Assigned",
           pay_amount: game.pay_rate
       )
       let created: OEAssignment? = try? await api.create(entity: "OEAssignment", body: a)
       if let created = created { assignments.append(created) }
   }
 
   public func updateAssignmentStatus(id: String, status: String) async {
       struct Patch: Codable { let status: String }
       let patch = Patch(status: status)
       let updated: OEAssignment? = try? await api.update(entity: "OEAssignment", id: id, body: patch)
       if let updated = updated {
           if let idx = assignments.firstIndex(where: { $0.id == id }) {
               assignments[idx] = updated
           }
       }
   }
 
   public func deleteAssignment(id: String) async {
       try? await api.delete(entity: "OEAssignment", id: id)
       assignments.removeAll { $0.id == id }
   }
 
   public var activeOfficials: [Official] {
       officials.filter { $0.isActive }
   }
 
   public var scheduledGames: [OEGame] {
       games.filter { $0.isUpcoming }
   }
 
   public var liveGames: [OEGame] {
       games.filter { $0.isLive }
   }
 
   public var totalPaid: Double {
       assignments.filter { $0.isPaid }.reduce(0) { $0 + $1.pay_amount }
   }
 
   public var pendingPay: Double {
       assignments.filter { !$0.isPaid }.reduce(0) { $0 + $1.pay_amount }
   }
 
   public func assignmentCount(for gameId: String) -> Int {
       assignments.filter { $0.game_id == gameId }.count
   }
 
   public func isFullyStaffed(_ game: OEGame) -> Bool {
       assignmentCount(for: game.id) >= game.officials_needed
   }
 
   public func assignedOfficials(for gameId: String) -> [OEAssignment] {
       assignments.filter { $0.game_id == gameId }
   }
 
   public func availableOfficials(for game: OEGame) -> [Official] {
       let assigned = Set(assignedOfficials(for: game.id).map { $0.official_id })
       return activeOfficials.filter {
           !assigned.contains($0.id) &&
           ($0.sports.contains(game.sport) || $0.sports.isEmpty)
       }
   }
}