import Foundation
 
// MARK: — Response wrappers
public struct APIListResponse<T: Decodable>: Decodable {
    public let data: [T]?
}
 
public struct APIItemResponse<T: Decodable>: Decodable {
    public let data: T?
}
 
// MARK: — Base44 API Client
public final class Base44Client: Sendable {
 
    public static let shared = Base44Client()
 
    /// Override this if you deploy to a different Base44 app
    public var baseURL: String = "https://leroy-jones-app-bcffbf7f.base44.app/api"
 
    private let session = URLSession.shared
 
    public init() {}
 
    // ── LIST ────────────────────────────────────────────────────────
    public func list<T: Decodable>(
        entity: String,
        sort: String = "-created_date",
        query: [String: String] = [:]
    ) async throws -> [T] {
        var components = URLComponents(string: "\(baseURL)/entities/\(entity)")!
        var queryItems = [URLQueryItem(name: "sort", value: sort)]
        for (key, value) in query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        components.queryItems = queryItems
        guard let url = components.url else { throw URLError(.badURL) }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await session.data(for: req)
        let decoded = try JSONDecoder().decode(APIListResponse<T>.self, from: data)
        return decoded.data ?? []
    }
 
    // ── GET single ──────────────────────────────────────────────────
    public func get<T: Decodable>(entity: String, id: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)/entities/\(entity)/\(id)") else {
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await session.data(for: req)
        let decoded = try JSONDecoder().decode(APIItemResponse<T>.self, from: data)
        guard let item = decoded.data else { throw URLError(.cannotParseResponse) }
        return item
    }
 
    // ── CREATE ──────────────────────────────────────────────────────
    public func create<T: Codable>(entity: String, body: T) async throws -> T {
        guard let url = URL(string: "\(baseURL)/entities/\(entity)") else {
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)
        let (data, _) = try await session.data(for: req)
        let decoded = try JSONDecoder().decode(APIItemResponse<T>.self, from: data)
        guard let item = decoded.data else { throw URLError(.cannotParseResponse) }
        return item
    }
 
    // ── UPDATE ──────────────────────────────────────────────────────
    public func update<T: Codable>(entity: String, id: String, body: T) async throws -> T {
        guard let url = URL(string: "\(baseURL)/entities/\(entity)/\(id)") else {
            throw URLError(.badURL)
import Foundation
 
// MARK: — Response wrappers
public struct APIListResponse<T: Decodable>: Decodable {
    public let data: [T]?
}
 
public struct APIItemResponse<T: Decodable>: Decodable {
    public let data: T?
}
 
// MARK: — Base44 API Client
public final class Base44Client: Sendable {
 
    public static let shared = Base44Client()
 
    /// Override this if you deploy to a different Base44 app
    public var baseURL: String = "https://leroy-jones-app-bcffbf7f.base44.app/api"
 
    private let session = URLSession.shared
 
    public init() {}
 
    // ── LIST ────────────────────────────────────────────────────────
    public func list<T: Decodable>(
        entity: String,
        sort: String = "-created_date",
        query: [String: String] = [:]
    ) async throws -> [T] {
        var components = URLComponents(string: "\(baseURL)/entities/\(entity)")!
        var queryItems = [URLQueryItem(name: "sort", value: sort)]
        for (key, value) in query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        components.queryItems = queryItems
        guard let url = components.url else { throw URLError(.badURL) }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await session.data(for: req)
        let decoded = try JSONDecoder().decode(APIListResponse<T>.self, from: data)
        return decoded.data ?? []
    }
 
    // ── GET single ──────────────────────────────────────────────────
    public func get<T: Decodable>(entity: String, id: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)/entities/\(entity)/\(id)") else {
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await session.data(for: req)
        let decoded = try JSONDecoder().decode(APIItemResponse<T>.self, from: data)
        guard let item = decoded.data else { throw URLError(.cannotParseResponse) }
        return item
    }
 
    // ── CREATE ──────────────────────────────────────────────────────
    public func create<T: Codable>(entity: String, body: T) async throws -> T {
        guard let url = URL(string: "\(baseURL)/entities/\(entity)") else {
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)
        let (data, _) = try await session.data(for: req)
        let decoded = try JSONDecoder().decode(APIItemResponse<T>.self, from: data)
        guard let item = decoded.data else { throw URLError(.cannotParseResponse) }
        return item
    }
 
    // ── UPDATE ──────────────────────────────────────────────────────
    public func update<T: Codable>(entity: String, id: String, body: T) async throws -> T {
        guard let url = URL(string: "\(baseURL)/entities/\(entity)/\(id)") else {
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.httpMethod = "PATCH"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)
        let (data, _) = try await session.data(for: req)
        let decoded = try JSONDecoder().decode(APIItemResponse<T>.self, from: data)
        guard let item = decoded.data else { throw URLError(.cannotParseResponse) }
        return item
    }
 
    // ── DELETE ──────────────────────────────────────────────────────
    public func delete(entity: String, id: String) async throws {
        guard let url = URL(string: "\(baseURL)/entities/\(entity)/\(id)") else {
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"
        _ = try await session.data(for: req)
    }
}
