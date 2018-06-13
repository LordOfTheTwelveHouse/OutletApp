
//  Created by Akshay C Khanna on 29/05/2018.
//  Copyright © 2018 Akshay C Khanna. All rights reserved.
//

import UIKit
import Foundation

class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadProductImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadImage:UIImage?
            
            if let imageData = data {
                downloadImage = UIImage(data: imageData)
                let cgF = 300;
                downloadImage = helperResizeImage(image: downloadImage!, newWidth: CGFloat(cgF))
            }
            if downloadImage != nil {
                cache.setObject(downloadImage!, forKey: url.absoluteString as NSString)
            }
            //Async
            DispatchQueue.main.async {
                completion(downloadImage)
            }
        }
        dataTask.resume()
    }
    
static func helperResizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadProductImage(withURL: url, completion: completion)
        }
    }
}
