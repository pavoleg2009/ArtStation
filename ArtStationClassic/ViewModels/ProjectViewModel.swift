import UIKit

struct IconsOptions: OptionSet {
    let rawValue: Int

    static let image    = IconsOptions(rawValue: 1 << 0)
    static let video    = IconsOptions(rawValue: 1 << 1)
    static let model3d  = IconsOptions(rawValue: 1 << 2)
    static let marmoset = IconsOptions(rawValue: 1 << 3)
    static let pano     = IconsOptions(rawValue: 1 << 4)
}

struct ProjectViewModel {
    let id: Int
    let title: String
    let imageLink: URL
    let detailLink: URL
    let iconOptions: IconsOptions
}
