import Foundation

struct SuperheroDTO: Decodable {
    let id: Int
    let name: String
    let slug: String
    let powerstats: PowerstatsDTO
    let appearance: AppearanceDTO
    let biography: BiographyDTO
    let work: WorkDTO
    let connections: ConnectionsDTO
    let images: ImagesDTO
}

struct PowerstatsDTO: Decodable {
    let intelligence: Int
    let strength: Int
    let speed: Int
    let durability: Int
    let power: Int
    let combat: Int
}

struct AppearanceDTO: Decodable {
    let gender: String
    let race: String?
    let height: [String]
    let weight: [String]
    let eyeColor: String
    let hairColor: String
}

struct BiographyDTO: Decodable {
    let fullName: String
    let alterEgos: String
    let aliases: [String]
    let placeOfBirth: String
    let firstAppearance: String
    let publisher: String?
    let alignment: String
}

struct WorkDTO: Decodable {
    let occupation: String
    let base: String
}

struct ConnectionsDTO: Decodable {
    let groupAffiliation: String
    let relatives: String
}

struct ImagesDTO: Decodable {
    let xs: String
    let sm: String
    let md: String
    let lg: String
}
