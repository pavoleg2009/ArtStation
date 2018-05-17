/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct User : Codable {
	let id : Int?
	let username : String?
	let first_name : String?
	let last_name : String?
	let avatar_file_name : String?
	let country : String?
	let city : String?
	let subdomain : String?
	let headline : String?
	let pro_member : Bool?
	let is_staff : Bool?
	let medium_avatar_url : String?
	let large_avatar_url : String?
	let full_name : String?
	let permalink : String?
	let artstation_profile_url : String?
	let location : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case username = "username"
		case first_name = "first_name"
		case last_name = "last_name"
		case avatar_file_name = "avatar_file_name"
		case country = "country"
		case city = "city"
		case subdomain = "subdomain"
		case headline = "headline"
		case pro_member = "pro_member"
		case is_staff = "is_staff"
		case medium_avatar_url = "medium_avatar_url"
		case large_avatar_url = "large_avatar_url"
		case full_name = "full_name"
		case permalink = "permalink"
		case artstation_profile_url = "artstation_profile_url"
		case location = "location"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		avatar_file_name = try values.decodeIfPresent(String.self, forKey: .avatar_file_name)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		subdomain = try values.decodeIfPresent(String.self, forKey: .subdomain)
		headline = try values.decodeIfPresent(String.self, forKey: .headline)
		pro_member = try values.decodeIfPresent(Bool.self, forKey: .pro_member)
		is_staff = try values.decodeIfPresent(Bool.self, forKey: .is_staff)
		medium_avatar_url = try values.decodeIfPresent(String.self, forKey: .medium_avatar_url)
		large_avatar_url = try values.decodeIfPresent(String.self, forKey: .large_avatar_url)
		full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
		permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
		artstation_profile_url = try values.decodeIfPresent(String.self, forKey: .artstation_profile_url)
		location = try values.decodeIfPresent(String.self, forKey: .location)
	}

}