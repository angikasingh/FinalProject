//
//  Utils.swift
//  TiktokTracker
//
//  Created by Angika Singh on 4/27/21.
//

import Foundation

func getSearchUrl(_ userId: String) -> String {
    var url = searchUrl
    url.append(userId)
    return url
}

func getDetailsUrl(_ userId: String) -> String {
    var url = detailsUrl
    url.append(userId)
    return url
}
