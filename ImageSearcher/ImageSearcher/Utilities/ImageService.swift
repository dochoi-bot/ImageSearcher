//
//  ImageService.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/12.
//

import UIKit

enum ImageError: Error {
    case invalidImage
}

struct ImageService {
   
    private let memoryCache = NSCache<NSString, UIImage>()

    func loadImage(by urlString: String, completionHandler: @escaping (Result<UIImage, ImageError>) -> Void) {
        if let cachedImage = memoryCache.object(forKey: urlString as NSString) {
            completionHandler(.success(cachedImage))
            return
        }
        
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url, options: .uncached),
              let image = UIImage(data: data) else {
            completionHandler(.failure(.invalidImage))
            return }
        
        memoryCache.setObject(image, forKey: urlString as NSString)
        completionHandler(.success(image))
    }
}
