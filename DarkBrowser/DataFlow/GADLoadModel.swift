//
//  GADLoadModel.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/23.
//

import Foundation

class GADLoadModel: NSObject {
    /// 當前廣告位置類型
    var position: GADPosition = .all
    /// 當前正在加載第幾個 ADModel
    var preloadIndex: Int = 0
    /// 是否正在加載中
    var isPreloadingAd = false
    /// 正在加載術組
    var loadingArray: [GADModel] = []
    /// 加載完成
    var loadedArray: [GADModel] = []
    /// 展示
    var displayArray: [GADModel] = []
    
    var isLoaded: Bool = false
    
    var isDisplay: Bool {
        return displayArray.count > 0
    }
    
    /// 该广告位显示广告時間 每次显示更新时间
    var impressionDate = Date(timeIntervalSinceNow: -100)
        
    init(position: GADPosition) {
        super.init()
        self.position = position
    }
}

extension GADLoadModel {
    func beginAddWaterFall(callback: ((_ isSuccess: Bool) -> Void)? = nil, in store: Store) {
        isLoaded = false
        if isPreloadingAd == false, loadedArray.count == 0 {
            NSLog("[AD] (\(position.rawValue) start to prepareLoad.--------------------")
            if let array = store.state.ad.config?.arrayWith(position), array.count > 0 {
                preloadIndex = 0
                NSLog("[AD] (\(position.rawValue)) start to load array = \(array.count)")
                prepareLoadAd(array: array, callback: callback, in: store)
            } else {
              isPreloadingAd = false
                NSLog("[AD] (\(position.rawValue)) no configer.")
            }
        } else if loadedArray.count > 0 {
            NSLog("[AD] (\(position.rawValue)) loaded ad.")
            isLoaded = true
            callback?(true)
        } else if loadingArray.count > 0 {
            NSLog("[AD] (\(position.rawValue)) loading ad.")
        }
    }
    
    func prepareLoadAd(array: [GADConfigModel.GADModels.GADModel], callback: ((_ isSuccess: Bool) -> Void)? , in store: Store) {
        if array.count == 0 || preloadIndex >= array.count {
            NSLog("[AD] (\(position.rawValue)) prepare Load Ad Failed, no more avaliable config.")
            isPreloadingAd = false
            return
        }
        NSLog("[AD] (\(position)) prepareLoaded.")
        if store.state.ad.isLimited(in: store) {
            NSLog("[AD] (\(position.rawValue)) 用戶超限制。")
            callback?(false)
            return
        }
        if loadedArray.count > 0 {
            NSLog("[AD] (\(position.rawValue)) 已經加載完成。")
            callback?(false)
            return
        }
        if isPreloadingAd, preloadIndex == 0 {
            NSLog("[AD] (\(position.rawValue)) 正在加載中.")
            callback?(false)
            return
        }
        
//        if Date().timeIntervalSince1970 - loadDate.timeIntervalSince1970 < 11, position == .indexNative || position == .textTranslateNative || position == .backToIndexInter {
//            NSLog("[AD] (\(position.rawValue)) 10s 刷新間隔.")
//            callback?(false)
//            return
//        }
        
        isPreloadingAd = true
        var ad: GADModel? = nil
        if position.isNativeAD {
            ad = GADNativeModel(model: array[preloadIndex])
        } else if position.isInterstitialAd {
            ad = GADInterstitialModel(model: array[preloadIndex])
        }
        ad?.position = position
        ad?.loadAd { [weak ad] result, error in
            guard let ad = ad else { return }
            /// 刪除loading 中的ad
            self.loadingArray = self.loadingArray.filter({ loadingAd in
                return ad.id != loadingAd.id
            })
            
            /// 成功
            if result {
                self.isLoaded = true
                self.isPreloadingAd = false
                self.loadedArray.append(ad)
                callback?(true)
                return
            }
            
            if self.loadingArray.count == 0 {
                let next = self.preloadIndex + 1
                if next < array.count {
                    NSLog("[AD] (\(self.position.rawValue)) Load Ad Failed: try reload at index: \(next).")
                    self.preloadIndex = next
                    self.prepareLoadAd(array: array, callback: callback, in: store)
                } else {
                    NSLog("[AD] (\(self.position.rawValue)) prepare Load Ad Failed: no more avaliable config.")
                    self.isPreloadingAd = false
                    self.isLoaded = true
                    callback?(false)
                }
            }
            
        }
        if let ad = ad {
            loadingArray.append(ad)
        }
    }
    
    func display() {
        self.displayArray = self.loadedArray
        self.loadedArray = []
    }
    
    func closeDisplay() {
        self.displayArray = []
    }
    
    func clean() {
        self.displayArray = []
        self.loadedArray = []
        self.loadingArray = []
    }
}
