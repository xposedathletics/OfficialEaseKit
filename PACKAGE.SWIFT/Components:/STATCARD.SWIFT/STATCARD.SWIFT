import SwiftUI
 
public struct StatCard: View {
    public let icon: String
    public let label: String
    public let value: String
    public let color: Color
 
    public init(icon: String, label: String, value: String, color: Color) {
        self.icon = icon; self.label = label
        self.value = value; self.color = color
    }
 
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon).foregroundColor(color).font(.title3)
                Spacer()
            }
            Text(value).font(.system(size: 28, weight: .black)).foregroundColor(.white)
            Text(label).font(.caption).foregroundColor(.gray)
        }
        .padding(14)
        .background(color.opacity(0.08))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.2), lineWidth: 1))
    }
}
