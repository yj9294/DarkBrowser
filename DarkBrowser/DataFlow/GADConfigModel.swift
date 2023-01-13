//
//  GADConfigModel.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/23.
//

import Foundation

struct GADConfigModel: Codable {
    var showTimes: Int?
    var clickTimes: Int?
    var ads: [GADModels?]?
    
    func arrayWith(_ postion: GADPosition) -> [GADModels.GADModel] {
        guard let ads = ads else {
            return []
        }
        
        guard let models = ads.filter({$0?.key == postion.rawValue}).first as? GADModels, let array = models.value   else {
            return []
        }
        
        return array.sorted(by: {$0.theAdPriority > $1.theAdPriority})
    }
    
    struct GADModels: Codable {
        
        var key: String
        var value: [GADModel]?
        
        struct GADModel: Codable {
            var theAdPriority: Int
            var theAdID: String
        }
    }
}

enum GADPosition: String, CaseIterable {
    case all, native, interstitial
    
    enum Position {
        case home, tab
    }

    var isNativeAD: Bool {
        switch self {
        case .native:
            return true
        default:
            return false
        }
    }
    
    var isInterstitialAd: Bool {
        if self == .all {
            return false
        }
        return !self.isNativeAD
    }
}

struct GADLimitModel: Codable {
    var showTimes: Int
    var clickTimes: Int
    var date: Date
    
    enum Status {
        case show, click
    }
}
