//
//  ImageThumbnailViewCell.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/12.
//

import UIKit

final class ImageThumbnailViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    static let reuseIdentifier: String = "ImageThumbnailViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
