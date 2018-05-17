import Foundation

struct Project : Codable {
	let id: Int?
	let userID: Int?
	let title: String?
	let description: String?
	let createdAt: String?
	let updatedAt: String?
	let likesCount: Int?
	let slug: String?
	let publishedAt: String?
	let adultContent: Bool?
	let coverAssetID: Int?
	let adminAdultContent: Bool?
	let viewsCount: Int?
	let hashID: String?
	let permalink: String?
	let hideAsAdult: Bool?
	let user: User?
	let cover: Cover?
	let icons: Icons?
	let assetsCount: Int?

	enum CodingKeys: String, CodingKey {
		case id
		case userID = "user_id"
		case title
		case description = "description"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case likesCount = "likes_count"
		case slug
		case publishedAt = "published_at"
		case adultContent = "adult_content"
		case coverAssetID = "cover_asset_id"
		case adminAdultContent = "admin_adult_content"
		case viewsCount = "views_count"
		case hashID = "hash_id"
		case permalink = "permalink"
		case hideAsAdult = "hide_as_adult"
		case user
		case cover
		case icons
		case assetsCount = "assets_count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		userID = try values.decodeIfPresent(Int.self, forKey: .userID)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount)
		slug = try values.decodeIfPresent(String.self, forKey: .slug)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
		adultContent = try values.decodeIfPresent(Bool.self, forKey: .adultContent)
		coverAssetID = try values.decodeIfPresent(Int.self, forKey: .coverAssetID)
		adminAdultContent = try values.decodeIfPresent(Bool.self, forKey: .adminAdultContent)
		viewsCount = try values.decodeIfPresent(Int.self, forKey: .viewsCount)
		hashID = try values.decodeIfPresent(String.self, forKey: .hashID)
		permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
		hideAsAdult = try values.decodeIfPresent(Bool.self, forKey: .hideAsAdult)
		user = try User(from: decoder)
		cover = try Cover(from: decoder)
		icons = try Icons(from: decoder)
		assetsCount = try values.decodeIfPresent(Int.self, forKey: .assetsCount)
	}

}
