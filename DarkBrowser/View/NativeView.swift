//
//  NativeView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/23.
//

import Foundation
import SwiftUI
import GoogleMobileAds

class NativeViewModel: NSObject {
    let ad: GADNativeModel?
    let view: UINativeAdView
    init(ad: GADNativeModel? = nil, view: UINativeAdView) {
        self.ad = ad
        self.view = view
        self.view.refreshUI(ad: ad?.nativeAd)
    }
    
    static var None:NativeViewModel {
        NativeViewModel(view: UINativeAdView())
    }
}


struct NativeView: UIViewRepresentable {
    let model: NativeViewModel
    func makeUIView(context: UIViewRepresentableContext<NativeView>) -> UIView {
        return model.view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<NativeView>) {
        if let uiView = uiView as? UINativeAdView {
            uiView.refreshUI(ad: model.ad?.nativeAd)
        }
    }
}

class UINativeAdView: GADNativeAdView {

    init(){
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        refreshUI(ad: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 暫未圖
    lazy var placeholderView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var adView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "ad_tag"))
        return image
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var installLabel: UIButton = {
        let label = UIButton()
        label.backgroundColor = UIColor(red: 62 / 255.0, green: 215 / 255.0, blue: 38 / 255.0, alpha: 1.0)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.setTitleColor(UIColor.white, for: .normal)
        label.layer.cornerRadius = 18
        label.layer.masksToBounds = true
//        label.setBackgroundImage(UIImage(named: "ad_button"), for: .normal)x
        return label
    }()
}

extension UINativeAdView {
    func setupUI() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        addSubview(placeholderView)
        placeholderView.frame = self.bounds
        
        
        addSubview(iconImageView)
        iconImageView.frame = CGRectMake(15, 15, 48, 48)
        
        
        addSubview(titleLabel)
        let width = self.bounds.size.width - iconImageView.frame.maxX - 8 - 150
        titleLabel.frame = CGRectMake(iconImageView.frame.maxX + 8, 21, width, 15)

        
        addSubview(adView)
        adView.frame = CGRectMake(titleLabel.frame.maxX + 5, 21, 25, 14)
        
        addSubview(subTitleLabel)
        let w = self.bounds.size.width - iconImageView.frame.maxX - 8 - 130
        subTitleLabel.frame = CGRectMake(titleLabel.frame.minX, titleLabel.frame.maxY + 10, w, 12)

        
        addSubview(installLabel)
        let x = self.bounds.width - 15 - 87
        installLabel.frame = CGRectMake(x, 21, 87, 36)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    func refreshUI(ad: GADNativeAd? = nil) {
        self.nativeAd = ad
        placeholderView.image = UIImage(named: "ad_placeholder")
        let bgColor = UIColor.white
        let subTitleColor = UIColor(red: 115 / 255.0, green: 115 / 255.0, blue: 115 / 255.0, alpha: 1.0)
        let titleColor = UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0)
//        let installColor = UIColor(red: 247 / 255.0, green: 183 / 255.0, blue: 42 / 255.0, alpha: 1.0)
        let installTitleColor = UIColor.white
        self.backgroundColor = ad == nil ? .clear : bgColor
        self.adView.image = UIImage(named: "ad_tag")
//        self.installLabel.backgroundColor = installColor
        self.installLabel.setTitleColor(installTitleColor, for: .normal)
        self.subTitleLabel.textColor = subTitleColor
        self.titleLabel.textColor = titleColor
        
        self.iconView = self.iconImageView
        self.headlineView = self.titleLabel
        self.bodyView = self.subTitleLabel
        self.callToActionView = self.installLabel
        self.installLabel.setTitle(ad?.callToAction, for: .normal)
        self.iconImageView.image = ad?.icon?.image
        self.titleLabel.text = ad?.headline
        self.subTitleLabel.text = ad?.body
        
        self.hiddenSubviews(hidden: self.nativeAd == nil)
        
        if ad == nil {
            self.placeholderView.isHidden = false
        } else {
            self.placeholderView.isHidden = true
        }
    }
    
    func hiddenSubviews(hidden: Bool) {
        self.iconImageView.isHidden = hidden
        self.titleLabel.isHidden = hidden
        self.subTitleLabel.isHidden = hidden
        self.installLabel.isHidden = hidden
        self.adView.isHidden = hidden
    }
}
