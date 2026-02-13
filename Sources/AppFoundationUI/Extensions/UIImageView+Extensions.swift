//
//  UIImageView+Extensions.swift
//  AppFoundation
//
//  UIImageView extensions for image loading with Kingfisher.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    // MARK: - Basic Helpers
    
    /// Loads an image from a URL using Kingfisher
    /// - Parameters:
    ///   - url: Image URL
    ///   - placeholder: Placeholder image to show while loading
    ///   - completion: Optional completion handler
    func setImage(with url: URL?,
                  placeholder: UIImage? = nil,
                  completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ],
            completionHandler: completion
        )
    }
    
    /// Loads an image from a URL string using Kingfisher
    /// - Parameters:
    ///   - urlString: Image URL string
    ///   - placeholder: Placeholder image to show while loading
    func setImage(with urlString: String?, placeholder: UIImage? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholder
            return
        }
        setImage(with: url, placeholder: placeholder)
    }
    
    // MARK: - Advanced Helpers
    
    /// Loads an image with custom options
    /// - Parameters:
    ///   - url: Image URL
    ///   - placeholder: Placeholder image
    ///   - options: Kingfisher options
    ///   - progressBlock: Progress callback
    ///   - completion: Completion handler
    func setImage(with url: URL?,
                  placeholder: UIImage? = nil,
                  options: KingfisherOptionsInfo,
                  progressBlock: DownloadProgressBlock? = nil,
                  completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options,
            progressBlock: progressBlock,
            completionHandler: completion
        )
    }
    
    /// Cancels the current image download task
    func cancelImageDownload() {
        kf.cancelDownloadTask()
    }
}
