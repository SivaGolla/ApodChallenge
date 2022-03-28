//
//  MediaRenderingView.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 25/03/22.
//

import UIKit
import WebKit
import YouTubeiOSPlayerHelper
import AVKit

/// View to render image / video from Apod Service
class MediaRenderingView: UIView {

    enum MediaRenderType {
        case image
        case youtube
        case web
        case native
    }
    
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var explanation: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webPlayerView: UIView!

    @IBOutlet weak var youTublePlayerView: YTPlayerView!
    
    private var webPlayer: WKWebView!
    private var mediaRendererType: MediaRenderType = .image
    
    var apod: AstronomyPod? = nil {
        willSet {
            guard let apodInstance = newValue else {
                return
            }
            
            imageTitle.text = apodInstance.title
            explanation.text = apodInstance.explanation
            
            switch apodInstance.mediaType {
            case .image:
                mediaRendererType = .image
                showCurrentPlayerAndHideOtherPlayers()
                imageView.loadRemoteImage(urlPath: apodInstance.hdUrl!, placeHolderImage: nil) { image in
                    LoadingView.stop()
                    guard let downloadedImage = image else {
                        self.loadSavedMedia()
                        return
                    }
                    
                    ApodDataStorage.shared.update(apod: self.apod, image: downloadedImage, key: Constants.activeRequestId)
                    ApodDataStorage.shared.updateSavedItem()
                }
                
            case .video:
                loadRemoteVideo(apod: apodInstance)
            }
        }
    }
    
    private let nibFileName = "MediaRenderingView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("MediaRenderingView", owner: self, options: nil)?.first as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        youTublePlayerView.delegate = self
        setupWebView()
    }
    
    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true

        webPlayer = WKWebView(frame: self.webPlayerView.bounds, configuration: webConfiguration)
        webPlayer.navigationDelegate = self
        webPlayer.accessibilityIdentifier = "webPlayer"
        webPlayer.backgroundColor = .clear
        webPlayer.isOpaque = false
        webPlayerView.addSubview(self.webPlayer)
        
        // wkwebview not responding to constraints
        webPlayer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    /// Renders the remote video
    /// - Parameter apod: AstronomyPod
    func loadRemoteVideo(apod: AstronomyPod) {
        
        if apod.url.isValidYouTubeUrlPath() {
            guard let videoId = apod.url.youtubeID else {
                LoadingView.stop()
                return
            }
            mediaRendererType = .youtube
            showCurrentPlayerAndHideOtherPlayers()
            youTublePlayerView.load(withVideoId: videoId, playerVars: ["playsinline": "1"])
            
        } else {
            AsyncVideoLoader().loadMediaFrom(url: apod.url) { htmlString, error in
                
                if error != nil {
                    LoadingView.stop()
                    return
                }
                self.mediaRendererType = .web
                self.showCurrentPlayerAndHideOtherPlayers()
                self.webPlayer.loadHTMLString(htmlString!, baseURL: nil)
                self.webPlayerView.layoutIfNeeded()
            }
        }
        ApodDataStorage.shared.updateSavedItem()
    }
    
    /// Loads and plays downloaded or streamed video
    /// - Parameter videoUrlPath: String
    func loadNativePlayer(videoUrlPath: String) {
        guard let videoUrl = URL(string: videoUrlPath) else {
            // Invalid url, can't pay video
            return
        }

        youTublePlayerView.stopVideo()
        imageView.isHidden = true
        youTublePlayerView.isHidden = true

        let player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = youTublePlayerView.bounds
        self.layer.addSublayer(playerLayer)
        player.play()
    }
    
    /// Loads Saved Media On failure to download selected remote image / video file
    func loadSavedMedia() {
        
        guard let savedMedia = ApodDataStorage.shared.fetchValueFor(key: Constants.savedRequestId),
              let apod = savedMedia.apod else {
            return
        }
        
        imageTitle.text = apod.title
        explanation.text = apod.explanation
        
        if apod.mediaType == .image, let image = savedMedia.image {
            webPlayerView.isHidden = true
            youTublePlayerView.stopVideo()
            youTublePlayerView.isHidden = true
            imageView.isHidden = false
            imageView.image = image
        } else if apod.mediaType == .video {
            imageView.isHidden = true
            webPlayerView.isHidden = false
            youTublePlayerView.stopVideo()
            youTublePlayerView.isHidden = false
            loadRemoteVideo(apod: apod)
        }
    }
    
    func showCurrentPlayerAndHideOtherPlayers() {
        switch mediaRendererType {
        case .image:
            webPlayerView.isHidden = true
            webPlayer.stopLoading()
            youTublePlayerView.stopVideo()
            youTublePlayerView.isHidden = true
            imageView.isHidden = false
            
        case .youtube:
            youTublePlayerView.stopVideo()
            imageView.isHidden = true
            webPlayerView.isHidden = true
            webPlayer.stopLoading()
            youTublePlayerView.isHidden = false
            
        case .web:
            self.youTublePlayerView.stopVideo()
            self.youTublePlayerView.isHidden = true
            self.imageView.isHidden = true
            self.webPlayer.stopLoading()
            self.webPlayerView.isHidden = false
            
        case .native:
            // Not in use
            break
        }
    }
}

extension MediaRenderingView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ApodDataStorage.shared.updateSavedItem()
        LoadingView.stop()
    }
}

extension MediaRenderingView: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        LoadingView.stop()
    }
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .clear
    }
}
