
//  Created by Akshay C Khanna on 28/05/2018.
//  Copyright © 2018 Akshay C Khanna. All rights reserved.
//

import Foundation


extension Notification.Name {
    static let productWebService = Notification.Name("productWebService")
}

// Struct for Decoding Price Dictionary
struct PriceDetails:Codable{
    let currency: String
    let divisor: Int
    let amount: Int
}

// Struct for Image Dictionary
struct ImageDetails:Codable{
    let mediaType: String
    let urlTemplate: String
}

// Struct for Product Dictionary
struct ProductDetails: Codable{
    let id: Int
    let name:String
    let price: PriceDetails
    let images : ImageDetails
    
}


class ProductWebService{
    
    
    /// getProductJSON
    /// - Parses JSON from URL
    /// - Parameter completion: Closure used for population of an array returning an integer value for cell count in View
    public static func getProductJSON(completion: @escaping (_ array:Array<Any>?)->(Int?)){
        //Create Dispatch Group for Threading
        let productGroup = DispatchGroup()
        //Init URL string
        let urlString = "https://api.net-a-porter.com/NAP/GB/en/60/0/summaries?categoryIds=2"
        //Init URL
        let url = URL(string: urlString)
        //Init URL Session with data task
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            //Check for error
            if error != nil {
                //Print Error
                print(error!.localizedDescription)
            }//End of If loop
            //Check for data for safetly unwrapping data
            guard let data = data else { return }
            do {
                //Enter the Dispatch group
                productGroup.enter()
                //Init a JSON object from data
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                //Check for optional value for safe unwrapping
                if let json = json {
                //Create summaries dictionary for API as API holds multiple objects
                let summaries = json["summaries"] as? [[String: Any]]
                    //Check for optional value for safe unwrapping
                    if let summaries = summaries {
                        //Init JSON object with summaries for Decodable Protocol
                let jsonData = try JSONSerialization.data(withJSONObject: summaries)
                        //Init decodable object
                let decodedData = try JSONDecoder().decode([ProductDetails].self, from: jsonData )
                        //Init completion handler to use decoded object
                completion(decodedData)
                    }
                }
                //Post notification as asynchrous thread notifies objects waiting to act on object
                NotificationCenter.default.post(name: .productWebService, object: nil)
                //Exit Dispatch group
                productGroup.leave()
                //Check for Json Error
            } catch let jsonError {
                //Log Error
                print(jsonError)
            }
            //Perform data task
            }.resume()
        // Notifiy Queue on main thread as this is an important operation
        productGroup.notify(queue: DispatchQueue.main, execute: {
            print("Completed Net-A-Porter web requests.")
        })
    }
    
}

