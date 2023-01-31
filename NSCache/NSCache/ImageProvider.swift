//
//  ImageProvider.swift
//  NSCache
//
//  Created by Minh on 31/01/2023.
//

import Foundation
import UIKit

final class ImageProvider{
    static let shared = ImageProvider()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init (){}
    
    public func fetchImage(completion:@escaping (UIImage?) -> Void ){
        
        if let image = cache.object(forKey: "image"){
            print("Using cache")
            completion(image)
            return
        }
        
        guard let url = URL(string: "https://source.unsplash.com/random/500x500") else {
            completion(nil)
            return
        }
        print("Fetching image")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else{
                    completion(nil)
                    return
                }
                
                self.cache.setObject(image, forKey: "image")
                completion(image)
            }
            
        }
        task.resume()
        
        
    }
    
}
