import Foundation

struct Icons : Codable {
	let image : Bool?
	let video : Bool?
	let model3d : Bool?
	let marmoset : Bool?
	let pano : Bool?

	enum CodingKeys: String, CodingKey {
		case image
		case video
		case model3d
		case marmoset
		case pano
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		image = try values.decodeIfPresent(Bool.self, forKey: .image)
		video = try values.decodeIfPresent(Bool.self, forKey: .video)
		model3d = try values.decodeIfPresent(Bool.self, forKey: .model3d)
		marmoset = try values.decodeIfPresent(Bool.self, forKey: .marmoset)
		pano = try values.decodeIfPresent(Bool.self, forKey: .pano)
	}

}
