import UIKit

enum ImageLoaderError: Error {
    case couldNotCreateImageFromData
}

struct LocalImageCache {
    
    private static func urlInCachesDirectory(for imageURL: URL) -> URL {
        let imageName = imageURL.path.replacingOccurrences(of: "/", with: "-")
        guard let cacheDirectory = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first else { fatalError("==== Could not access caches directory") }
        
        return cacheDirectory.appendingPathComponent(imageName)
    }
    
    static func image(for url: URL) -> UIImage? {
        let storeUrl = urlInCachesDirectory(for: url)
        guard let imageData = try? Data(contentsOf: storeUrl) else { return nil }
        return UIImage(data: imageData)
    }
    
    static func write(_ image: UIImage, for url: URL) {
        let storeUrl = urlInCachesDirectory(for: url)
        
        guard let imageData = UIImagePNGRepresentation(image) else {
            assertionFailure("==== Could not get Data for image!")
            return
        }
        
        do {
            try imageData.write(to: storeUrl)
        } catch {
            print("==== Could not write data for \(url) to \(storeUrl): \(error)")
        }
    }
}
