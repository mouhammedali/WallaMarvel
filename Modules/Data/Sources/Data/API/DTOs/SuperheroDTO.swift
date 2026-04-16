import Foundation

public struct SuperheroDTO: Decodable {
    public let id: Int
    public let name: String
    public let slug: String
    public let powerstats: PowerstatsDTO
    public let appearance: AppearanceDTO
    public let biography: BiographyDTO
    public let work: WorkDTO
    public let connections: ConnectionsDTO
    public let images: ImagesDTO
}

public struct PowerstatsDTO: Decodable {
    public let intelligence: Int
    public let strength: Int
    public let speed: Int
    public let durability: Int
    public let power: Int
    public let combat: Int
}

public struct AppearanceDTO: Decodable {
    public let gender: String
    public let race: String?
    public let height: [String]
    public let weight: [String]
    public let eyeColor: String
    public let hairColor: String
}

public struct BiographyDTO: Decodable {
    public let fullName: String
    public let alterEgos: String
    public let aliases: [String]
    public let placeOfBirth: String
    public let firstAppearance: String
    public let publisher: String?
    public let alignment: String
}

public struct WorkDTO: Decodable {
    public let occupation: String
    public let base: String
}

public struct ConnectionsDTO: Decodable {
    public let groupAffiliation: String
    public let relatives: String
}

public struct ImagesDTO: Decodable {
    public let xs: String
    public let sm: String
    public let md: String
    public let lg: String
}
