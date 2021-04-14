//
//  DetailImageViewController.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/13.
//

import UIKit

final class DetailImageViewController: UIViewController {
    private let imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     imageView.topAnchor.constraint(equalTo: view.topAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
    }
    
    func setImage(image: UIImage, contentMode: UIView.ContentMode = .scaleAspectFit) {
        imageView.image = image
        imageView.contentMode = contentMode
    }
}
