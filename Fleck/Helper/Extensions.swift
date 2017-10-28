//
//  Extensions.swift
//  Fleck
//
//  Created by macuser1 on 28/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {

    func loadImageUsingCache(withURLString urlString: String) {
        let url = URL(string: urlString)
        
        //check the cache first
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
            }
            
            DispatchQueue.main.async {
                if let downloadedImage =  UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
                
            }
        }).resume()
    }
}
