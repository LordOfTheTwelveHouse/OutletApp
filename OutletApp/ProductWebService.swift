
//  Created by Akshay C Khanna on 28/05/2018.
//  Copyright © 2018 Akshay C Khanna. All rights reserved.
//

import Foundation


extension Notification.Name {
    static let productWebService = Notification.Name("productWebService")
}

struct PriceDetails:Codable{
    let currency: String
    let divisor: Int
    let amount: Int
}

struct ImageDetails:Codable{
    let mediaType: String
    let urlTemplate: String
}


struct ProductDetails: Codable{
    let id: Int
    let name:String
    let price: PriceDetails
    let images : ImageDetails
    
}

class ProductWebService{
    public static func getProductJSON(completion: @escaping (_ array:Array<Any>?)->(Int?)){
        let productGroup = DispatchGroup()
        let urlString = "https://api.net-a-porter.com/NAP/GB/en/60/0/summaries?categoryIds=2"
        let url = URL(string: urlString)

        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                productGroup.enter()
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let summaries = json!["summaries"] as? [[String: Any]]
                let jsonData = try! JSONSerialization.data(withJSONObject: summaries!)
                let decodedData = try JSONDecoder().decode([ProductDetails].self, from: jsonData )
                completion(decodedData)
                
                NotificationCenter.default.post(name: .productWebService, object: nil)
                productGroup.leave()
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
        
        productGroup.notify(queue: DispatchQueue.main, execute: {
            print("Completed Net-A-Porter web requests.")
        })
    }
    
}

