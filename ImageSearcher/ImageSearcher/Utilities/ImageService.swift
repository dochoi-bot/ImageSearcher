//
//  ImageService.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/12.
//

import UIKit

struct ImageService {
   
    private let memoryCache = NSCache<NSString, UIImage>()

    func loadImage(by urlString: String) -> UIImage? {
        if let cachedImage = memoryCache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return nil }
        
        memoryCache.setObject(image, forKey: urlString as NSString)
        
        return image
    }
    
    
}
