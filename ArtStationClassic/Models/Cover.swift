/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Cover : Codable {
	let id : Int?
	let small_image_url : String?
	let medium_image_url : String?
	let small_square_url : String?
	let thumb_url : String?
	let micro_square_image_url : String?
	let aspect : Double?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case small_image_url = "small_image_url"
		case medium_image_url = "medium_image_url"
		case small_square_url = "small_square_url"
		case thumb_url = "thumb_url"
		case micro_square_image_url = "micro_square_image_url"
		case aspect = "aspect"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		small_image_url = try values.decodeIfPresent(String.self, forKey: .small_image_url)
		medium_image_url = try values.decodeIfPresent(String.self, forKey: .medium_image_url)
		small_square_url = try values.decodeIfPresent(String.self, forKey: .small_square_url)
		thumb_url = try values.decodeIfPresent(String.self, forKey: .thumb_url)
		micro_square_image_url = try values.decodeIfPresent(String.self, forKey: .micro_square_image_url)
		aspect = try values.decodeIfPresent(Double.self, forKey: .aspect)
	}

}