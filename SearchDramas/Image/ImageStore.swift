//
//  ImageStore.swift
//  SearchDramas
//
//  Created by Jemma on 2020/12/14.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit

enum ImageError: Error {
    case parseFailure
}

class ImageStore {
    static let shared = ImageStore()
    let cache: NSCache<NSString, UIImage>
    
    private init() {
        cache = NSCache()
        cache.countLimit = 500
    }
    
    func loadImage(urlString: String, completion:@escaping ((Result<UIImage,Error>) -> Void)) {
        if let image = cache.object(forKey: urlString as NSString) {
            completion(.success(image))
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ImageError.parseFailure))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(ImageError.parseFailure))
                return
            }
            
            self.cache.setObject(image, forKey: urlString as NSString)
            completion(.success(image))
            
        }.resume()

    }
}
