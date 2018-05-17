import Foundation
struct Project : Codable {
	let id : Int?
	let user_id : Int?
	let title : String?
	let description : String?
	let created_at : String?
	let updated_at : String?
	let likes_count : Int?
	let slug : String?
	let published_at : String?
	let adult_content : Bool?
	let cover_asset_id : Int?
	let admin_adult_content : Bool?
	let views_count : Int?
	let hash_id : String?
	let permalink : String?
	let hide_as_adult : Bool?
	let user : User?
	let cover : Cover?
	let icons : Icons?
	let assets_count : Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case user_id = "user_id"
		case title = "title"
		case description = "description"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case likes_count = "likes_count"
		case slug = "slug"
		case published_at = "published_at"
		case adult_content = "adult_content"
		case cover_asset_id = "cover_asset_id"
		case admin_adult_content = "admin_adult_content"
		case views_count = "views_count"
		case hash_id = "hash_id"
		case permalink = "permalink"
		case hide_as_adult = "hide_as_adult"
		case user
		case cover
		case icons
		case assets_count = "assets_count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		likes_count = try values.decodeIfPresent(Int.self, forKey: .likes_count)
		slug = try values.decodeIfPresent(String.self, forKey: .slug)
		published_at = try values.decodeIfPresent(String.self, forKey: .published_at)
		adult_content = try values.decodeIfPresent(Bool.self, forKey: .adult_content)
		cover_asset_id = try values.decodeIfPresent(Int.self, forKey: .cover_asset_id)
		admin_adult_content = try values.decodeIfPresent(Bool.self, forKey: .admin_adult_content)
		views_count = try values.decodeIfPresent(Int.self, forKey: .views_count)
		hash_id = try values.decodeIfPresent(String.self, forKey: .hash_id)
		permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
		hide_as_adult = try values.decodeIfPresent(Bool.self, forKey: .hide_as_adult)
		user = try User(from: decoder)
		cover = try Cover(from: decoder)
		icons = try Icons(from: decoder)
		assets_count = try values.decodeIfPresent(Int.self, forKey: .assets_count)
	}

}
