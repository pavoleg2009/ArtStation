import Foundation

struct User : Codable {
	let id : Int?
	let username : String?
	let firstName : String?
	let lastName : String?
	let avatarFileName : String?
	let country : String?
	let city : String?
	let subdomain : String?
	let headline : String?
	let proMember : Bool?
	let isStaff : Bool?
	let mediumAvatarURL : String?
	let largeAvatarURL : String?
	let fullName : String?
	let permalink : String?
	let artstationProfileURL : String?
	let location : String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case username = "username"
		case firstName = "first_name"
		case lastName = "last_name"
		case avatarFileName = "avatar_file_name"
		case country = "country"
		case city = "city"
		case subdomain = "subdomain"
		case headline = "headline"
		case proMember = "pro_member"
		case isStaff = "is_staff"
		case mediumAvatarURL = "medium_avatar_url"
		case largeAvatarURL = "large_avatar_url"
		case fullName = "full_name"
		case permalink = "permalink"
		case artstationProfileURL = "artstation_profile_url"
		case location = "location"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		avatarFileName = try values.decodeIfPresent(String.self, forKey: .avatarFileName)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		subdomain = try values.decodeIfPresent(String.self, forKey: .subdomain)
		headline = try values.decodeIfPresent(String.self, forKey: .headline)
		proMember = try values.decodeIfPresent(Bool.self, forKey: .proMember)
		isStaff = try values.decodeIfPresent(Bool.self, forKey: .isStaff)
		mediumAvatarURL = try values.decodeIfPresent(String.self, forKey: .mediumAvatarURL)
		largeAvatarURL = try values.decodeIfPresent(String.self, forKey: .largeAvatarURL)
		fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
		permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
		artstationProfileURL = try values.decodeIfPresent(String.self, forKey: .artstationProfileURL)
		location = try values.decodeIfPresent(String.self, forKey: .location)
	}

}
