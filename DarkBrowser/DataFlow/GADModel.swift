//
//  GADModel.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/23.
//

import Foundation
import GoogleMobileAds

var AppEnterbackground = false

class GADModel: NSObject, Identifiable {
    let id = UUID().uuidString
    /// 廣告加載完成時間
    var loadedDate: Date?
    
    /// 點擊回調
    var clickHandler: (() -> Void)?
    var clickTwiceHandle: (()->Void)?
    /// 展示回調
    var impressionHandler: (() -> Void)?
    /// 加載完成回調
    var loadedHandler: ((_ result: Bool, _ error: String) -> Void)?
    
    /// 當前廣告model
    var model: GADConfigModel.GADModels.GADModel?
    /// 廣告位置
    var position: GADPosition = .all
    
    init(model: GADConfigModel.GADModels.GADModel?) {
        super.init()
        self.model = model
    }
}

extension GADModel {
    @objc public func loadAd( completion: @escaping ((_ result: Bool, _ error: String) -> Void)) {
        
    }
    
    @objc public func present() {
        
    }
}


class GADInterstitialModel: GADModel {
    /// 關閉回調
    var closeHandler: (() -> Void)?
    var autoCloseHandler: (()->Void)?
    /// 是否點擊過，用於拉黑用戶
    var isClicked: Bool = false
    
    /// 插屏廣告
    var interstitialAd: GADInterstitialAd?
    
    deinit {
        debugPrint("[Memory] (\(position.rawValue)) \(self) 💧💧💧.")
    }
}

extension GADInterstitialModel {
    public override func loadAd(completion: ((_ result: Bool, _ error: String) -> Void)?) {
        loadedHandler = completion
        loadedDate = nil
        GADInterstitialAd.load(withAdUnitID: model?.theAdID ?? "", request: GADRequest()) { [weak self] ad, error in
            guard let self = self else { return }
            if let error = error {
                NSLog("[AD] (\(self.position.rawValue)) load ad FAILED for id \(self.model?.theAdID ?? "invalid id")")
                self.loadedHandler?(false, error.localizedDescription)
                return
            }
            NSLog("[AD] (\(self.position.rawValue)) load ad SUCCESSFUL for id \(self.model?.theAdID ?? "invalid id")")
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
            self.loadedDate = Date()
            self.loadedHandler?(true, "")
        }
    }
    
    override func present() {
        if let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootVC = keyWindow.rootViewController {
            interstitialAd?.present(fromRootViewController: rootVC)
        }
    }
    
    func dismiss() {
        if let topController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController, let presented = topController.presentedViewController {
            presented.dismiss(animated: true) {
                topController.dismiss(animated: true)
            }
//            closeHandler?()
        }
    }
}

extension GADInterstitialModel : GADFullScreenContentDelegate {
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        loadedDate = Date()
        impressionHandler?()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        NSLog("[AD] (\(self.position.rawValue)) didFailToPresentFullScreenContentWithError ad FAILED for id \(self.model?.theAdID ?? "invalid id")")
        closeHandler?()
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if !AppEnterbackground {
            closeHandler?()
        }
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        clickHandler?()
    }
}

class GADNativeModel: GADModel {
    /// 廣告加載器
    var loader: GADAdLoader?
    /// 原生廣告
    var nativeAd: GADNativeAd?
    
    deinit {
        debugPrint("[Memory] (\(position.rawValue)) \(self) 💧💧💧.")
    }
}

extension GADNativeModel {
    public override func loadAd(completion: ((_ result: Bool, _ error: String) -> Void)?) {
        loadedDate = nil
        loadedHandler = completion
        loader = GADAdLoader(adUnitID: model?.theAdID ?? "", rootViewController: nil, adTypes: [.native], options: nil)
        loader?.delegate = self
        loader?.load(GADRequest())
    }
    
    public func unregisterAdView() {
        nativeAd?.unregisterAdView()
    }
}

extension GADNativeModel: GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        NSLog("[AD] (\(position.rawValue)) load ad FAILED for id \(model?.theAdID ?? "invalid id")")
        loadedHandler?(false, error.localizedDescription)
    }
}

extension GADNativeModel: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        NSLog("[AD] (\(position.rawValue)) load ad SUCCESSFUL for id \(model?.theAdID ?? "invalid id")")
        self.nativeAd = nativeAd
        loadedDate = Date()
        loadedHandler?(true, "")
    }
}

extension GADNativeModel: GADNativeAdDelegate {
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        clickHandler?()
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        impressionHandler?()
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
    }
}
