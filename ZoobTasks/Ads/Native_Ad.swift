//
//  AdManager.swift
//  boomrang
//
//  Created by Mir Karam on 6/4/20.
//  Copyright © 2020 Mir Karam. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

protocol NativeAdLoadDelegate {
    func adLoaded()
}

struct NativeAdView:UIViewRepresentable {
    @Binding var adLoaded:Bool
    func makeUIView(context: Context) -> UIView {
        context.coordinator.nativeAdView
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    final class Coordinator:NSObject, GADAdLoaderDelegate,GADNativeAdLoaderDelegate, GADNativeAdDelegate, GADVideoControllerDelegate{
        var delegate:NativeAdLoadDelegate?
        var nativeAdView : GADNativeAdView = GADNativeAdView()
        var adLoader: GADAdLoader!
        var heightConstraint: NSLayoutConstraint?
        let parent:NativeAdView
        init(_ p:NativeAdView) {
            self.parent = p
            super.init()
            let nibObjects = Bundle.main.loadNibNamed("NativeAdViewSmall"  , owner: nil, options: nil)
            if let adView = (nibObjects?.first as? GADNativeAdView){
                adView.backgroundColor = .black
                self.nativeAdView = adView
                refreshAd()
            }
        }
        
        func refreshAd() {
            //refreshAdButton.isEnabled = false
            //videoStatusLabel.text = ""
            adLoader = GADAdLoader(adUnitID: Constants.nativeAdId, rootViewController: UIApplication.shared.windows.first?.rootViewController,
                                   adTypes: [ .native ], options: [])
            adLoader.delegate = self
            let r = GADRequest()
            r.scene = UIApplication.shared.windows.first?.windowScene
            adLoader.load(r)
        }
        
        func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
            guard let rating = starRating?.doubleValue else {
                return nil
            }
            if rating >= 5 {
                return UIImage(named: "stars_5")
            } else if rating >= 4.5 {
                return UIImage(named: "stars_4_5")
            } else if rating >= 4 {
                return UIImage(named: "stars_4")
            } else if rating >= 3.5 {
                return UIImage(named: "stars_3_5")
            } else {
                return nil
            }
        }
        func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
            nativeAd.delegate = self
            heightConstraint?.isActive = false
            // Deactivate the height constraint that was set when the previous video ad loaded.
            // Populate the native ad view with the native ad assets.
            // The headline and mediaContent are guaranteed to be present in every native ad.
            (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
            nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

            // Some native ads will include a video asset, while others do not. Apps can use the
            // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
            // UI accordingly.
            let mediaContent = nativeAd.mediaContent
            if mediaContent.hasVideoContent {
                print("hasVideoContent ad...........")
              // By acting as the delegate to the GADVideoController, this ViewController receives messages
              // about events in the video lifecycle.
              mediaContent.videoController.delegate = self
            }

            // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
            // ratio of the media it displays.
            if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
                
              heightConstraint = NSLayoutConstraint(
                item: mediaView,
                attribute: .height,
                relatedBy: .equal,
                toItem: mediaView,
                attribute: .width,
                multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                constant: 0)
              heightConstraint?.isActive = true
            }

            // These assets are not guaranteed to be present. Check that they are before
            // showing or hiding them.
            (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
            nativeAdView.bodyView?.isHidden = nativeAd.body == nil

            (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
            nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

            (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
            nativeAdView.iconView?.isHidden = nativeAd.icon == nil

            (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
            nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

            if let t = nativeAd.store{
                (nativeAdView.storeView as? UILabel)?.text = t
            }else{
                nativeAdView.storeView?.isHidden = false
            }

            (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
            nativeAdView.priceView?.isHidden = nativeAd.price == nil

            (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
            nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

            // In order for the SDK to process touch events properly, user interaction should be disabled.
            nativeAdView.callToActionView?.isUserInteractionEnabled = false

            // Associate the native ad view with the native ad object. This is
            // required to make the ad clickable.
            // Note: this should always be done after populating the ad views.
            nativeAdView.nativeAd = nativeAd
            withAnimation{
                self.parent.adLoaded = true
            }
        }
        
        func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
            
        }
       
    }
    
}

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UIImageView {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
