import Foundation

struct ProjectsRequestResponse : Response {
	let projects : [Project]?
	let totalCount : Int?

	enum CodingKeys: String, CodingKey {
		case projects = "data"
		case totalCount = "total_count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		projects = try values.decodeIfPresent([Project].self, forKey: .projects)
		totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
	}

}
