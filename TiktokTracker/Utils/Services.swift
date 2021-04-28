//
//  Services.swift
//  TiktokTracker
//
//  Created by Angika Singh on 4/27/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit


func getAFResponseJSONArray(_ url : String ) -> Promise<[JSON]>{
    
    return Promise< [JSON] > { seal -> Void in
        AF.request(url, headers: headers).responseJSON { response in
            
            // If there was an error we will reject the promise
            if response.error != nil {
                seal.reject(response.error!)
            }
            
            // get the JSON array and fulfill the promise
            let jsonArray: [JSON] = JSON(response.data).arrayValue
            seal.fulfill(jsonArray)
        }
        
    }
}

func getAFResponseJSON(_ url : String) -> Promise<JSON>{
    return Promise<JSON> { seal -> Void in
        AF.request(url, headers: headers).responseJSON { response in
            // If there was an error we will reject the promise
            if response.error != nil {
                seal.reject(response.error!)
            }
            
            // get the JSON array and fulfill the promise
            let json: JSON = JSON(response.data)
            seal.fulfill(json)
        }
    }
    
}
