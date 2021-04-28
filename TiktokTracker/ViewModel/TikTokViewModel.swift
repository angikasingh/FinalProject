//
//  TikTokViewModel.swift
//  TiktokTracker
//
//  Created by Angika Singh on 4/27/21.
//

import Foundation
import PromiseKit
import Firebase

class TikTokViewModel{
    let db = Firestore.firestore()
    
    func getSearchResults(_ url : String) -> Promise<[TikTokUserModel]> {
        return Promise<[TikTokUserModel]>{ seal ->Void in
            
            getAFResponseJSONArray(url).done { response in
                
                var users:[TikTokUserModel]  = [TikTokUserModel]()
                
                for result in response {
                    let id = result["user"]["username"].stringValue
                    let name = result["user"]["full_name"].stringValue
                    let thumnail = result["user"]["profile_pic_url"].stringValue
                    let followerCount = "0"
                    let followingCount = "0"
                    let mediaCount = "0"

                    let user = TikTokUserModel(id, name,thumnail, followerCount, followingCount, mediaCount)
                    users.append(user)
                }
                
                seal.fulfill(users)
            
            }
            .catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getUserDetils(_ url : String) -> Promise<TikTokUserModel>{
        return Promise<TikTokUserModel> { seal ->Void in
            
            getAFResponseJSON(url).done { response in
                let id = response["username"].stringValue
                let name = response["full_name"].stringValue
                let thumnail = response["profile_pic_url"].stringValue
                let followerCount = response["edge_followed_by"]["count"].stringValue
                let followingCount = response["edge_follow"]["count"].stringValue
                let mediaCount = response["edge_owner_to_timeline_media"]["count"].stringValue

                let user = TikTokUserModel(id, name,thumnail, followerCount, followingCount, mediaCount)
                
                seal.fulfill(user)
            
            }
            .catch { error in
                seal.reject(error)
            }
            
        }
    }
    
    func getPinnedUsers() -> Promise<[String]>{
        return Promise<[String]> { seal ->Void in
            
            db.collection("pinnedUsers").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    seal.reject(err)
                } else {
                    var pinnedUsers: [String] = []
                    for document in querySnapshot!.documents {
                        pinnedUsers.append(document.documentID)
                    }
                    seal.fulfill(pinnedUsers)
                }
            }
            
        }
    }
    
    func isUserPinned(_ userId: String) -> Promise<Bool>{
        return Promise<Bool> { seal ->Void in
            let docRef = db.collection("pinnedUsers").document(userId)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    seal.fulfill(true)
                } else {
                    seal.fulfill(false)
                }
            }
        }
    }
    
    func pinUser(_ userId: String) {
        db.collection("pinnedUsers").document(userId).setData(["pinned": true])
    }
    
    func unpinUser(_ userId: String) {
        db.collection("pinnedUsers").document(userId).delete()
    }
}
