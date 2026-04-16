import SwiftUI

public enum DSColors {
    public enum Alignment {
        public static let good = Color.green
        public static let bad = Color.red
        public static let neutral = Color.orange
        public static let unknown = Color.gray
    }

    public enum Publisher {
        public static let badge = Color.blue
    }

    public enum Status {
        public static let warning = Color.orange
        public static let error = Color.red
        public static let success = Color.green
    }

    public enum Stats {
        public static let intelligence = Color.blue
        public static let strength = Color.red
        public static let speed = Color.green
        public static let durability = Color.orange
        public static let power = Color.purple
        public static let combat = Color.pink
    }

    public enum Background {
        #if canImport(UIKit)
        public static let primary = Color(.systemBackground)
        public static let secondary = Color(.secondarySystemBackground)
        public static let statBar = Color(.systemGray5)
        #else
        public static let primary = Color.white
        public static let secondary = Color.gray.opacity(0.1)
        public static let statBar = Color.gray.opacity(0.15)
        #endif
    }

    public enum Text {
        public static let primary = Color.primary
        public static let secondary = Color.secondary
    }

    /// Returns the semantic color for a hero alignment string.
    public static func alignment(_ alignment: String) -> Color {
        switch alignment.lowercased() {
        case "good": return Alignment.good
        case "bad": return Alignment.bad
        case "neutral": return Alignment.neutral
        default: return Alignment.unknown
        }
    }
}
