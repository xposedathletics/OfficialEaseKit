import SwiftUI
 
@MainActor
public final class OEStore: ObservableObject {
 
   @Published public var officials:   [Official]     = []
   @Published public var games:       [OEGame]       = []
   @Published public var assignments: [OEAssignment] = []
   @Published public var isLoading:   Bool = false
   @Published public var errorMsg:    String?
 
   public let api: Base44Client
 
   public init(client: Base44Client = .shared) {
       self.api = client
   }
 
   // MARK: - Load All
   public func loadAll() async {
    isLoading = true
    errorMsg  = nil
    let off:  [Official]     = (try? await api.list(entity: "RefUser"))      ?? []
    let gm:   [OEGame]       = (try? await api.list(entity: "OEGame"))       ?? []
    let asgn: [OEAssignment] = (try? await api.list(entity: "OEAssignment")) ?? []
    officials   = off
    games       = gm
    assignments = asgn
    isLoading   = false
   }
 
   // MARK: - Officials
   public func addOfficial(_ o: Official) async {
       guard !o.full_name.isEmpty, !o.email.isEmpty else { return }
       if let created: Official = try? await api.create(entity: "RefUser", body: o) {
           officials.append(created)
       }
   }
 
   public func updateOfficialStatus(id: String, status: String) async {
       struct Patch: Codable { let status: String }
       if let updated: Official = try? await api.update(
           entity: "RefUser", id: id, body: Patch(status: status)) {
           if let idx = officials.firstIndex(where: { $0.id == id }) {
               officials[idx] = updated
           }
       }
   }
 
   public func deleteOfficial(id: String) async {
       try? await api.delete(entity: "RefUser", id: id)
       officials.removeAll { $0.id == id }
   }
 
   // MARK: - Games
   public func addGame(_ g: OEGame) async {
       guard !g.home_team.isEmpty, !g.date.isEmpty else { return }
       if let created: OEGame = try? await api.create(entity: "OEGame", body: g) {
           games.append(created)
       }
   }
 
   public func updateGameStatus(id: String, status: String) async {
       struct Patch: Codable { let status: String }
       if let updated: OEGame = try? await api.update(
           entity: "OEGame", id: id, body: Patch(status: status)) {
           if let idx = games.firstIndex(where: { $0.id == id }) {
               games[idx] = updated
           }
       }
   }
 
   // MARK: - Assignments
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
       if let created: OEAssignment = try? await api.create(entity: "OEAssignment", body: a) {
           assignments.append(created)
       }
   }
 
   public func updateAssignmentStatus(id: String, status: String) async {
       struct Patch: Codable { let status: String }
       if let updated: OEAssignment = try? await api.update(
           entity: "OEAssignment", id: id, body: Patch(status: status)) {
           if let idx = assignments.firstIndex(where: { $0.id == id }) {
               assignments[idx] = updated
           }
       }
   }
 
   // MARK: - Computed Helpers
   public var activeOfficials: [Official]  { officials.filter(\.isActive) }
   public var scheduledGames:  [OEGame]    { games.filter(\.isUpcoming) }
   public var liveGames:       [OEGame]    { games.filter(\.isLive) }
   public var totalPaid:       Double      { assignments.filter(\.isPaid).reduce(0) { $0 + $1.pay_amount } }
   public var pendingPay:      Double      { assignments.filter { !$0.isPaid }.reduce(0) { $0 + $1.pay_amount } }
 
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

