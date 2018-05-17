import Foundation

struct Cover : Codable {
	let id : Int?
	let smallImageURL : String?
	let mediumImageURL : String?
	let smallSquareURL : String?
	let thumbURL : String?
	let microSquareImageURL : String?
	let aspect : Double?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case smallImageURL = "small_image_url"
		case mediumImageURL = "medium_image_url"
		case smallSquareURL = "small_square_url"
		case thumbURL = "thumb_url"
		case microSquareImageURL = "micro_square_image_url"
		case aspect = "aspect"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		smallImageURL = try values.decodeIfPresent(String.self, forKey: .smallImageURL)
		mediumImageURL = try values.decodeIfPresent(String.self, forKey: .mediumImageURL)
		smallSquareURL = try values.decodeIfPresent(String.self, forKey: .smallSquareURL)
		thumbURL = try values.decodeIfPresent(String.self, forKey: .thumbURL)
		microSquareImageURL = try values.decodeIfPresent(String.self, forKey: .microSquareImageURL)
		aspect = try values.decodeIfPresent(Double.self, forKey: .aspect)
	}

}
