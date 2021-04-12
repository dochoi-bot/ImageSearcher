//
//  ImageThumbnailViewCell.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/12.
//

import UIKit

final class ImageThumbnailViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        indicator.startAnimating()
    }
}
