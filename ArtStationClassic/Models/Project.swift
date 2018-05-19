import Foundation

struct Project : Codable {
	let id: Int?
	let title: String?
	let coverAssetID: Int?
	let permalink: String?
	let cover: Cover?
    let icons: Icons?

	enum CodingKeys: String, CodingKey {
		case id
		case title
		case coverAssetID = "cover_asset_id"
		case permalink = "permalink"
		case cover
        case icons
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		coverAssetID = try values.decodeIfPresent(Int.self, forKey: .coverAssetID)
		permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
		cover = try values.decodeIfPresent(Cover.self, forKey: .cover)
        icons = try values.decodeIfPresent(Icons.self, forKey: .icons)
	}

}
