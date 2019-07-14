//
//  ImageExtension.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-28.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        
        if let cachedimage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedimage
            return
        }
        
        
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
 
            }
            
            }.resume()
    }
}



