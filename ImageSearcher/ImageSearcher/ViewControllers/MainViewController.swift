//
//  ViewController.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/09.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var container: DIContainer!
    private var response: Response?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dependencyInject()
        configureViews()
    }
}

private extension MainViewController {
    
    func configureViews() {
        title = "Image Searcher"
        self.navigationItem.searchController = UISearchController()
        loadImage()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 80, height: 80)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: ImageThumbnailViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ImageThumbnailViewCell.reuseIdentifier)
  
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(refresh:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refresh(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        loadImage()
    }
    
    func dependencyInject() {
        let networkService = NetworkService()
        let imageService = ImageService()
        self.container = DIContainer(networkService: networkService, imageService: imageService)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadImage() {
        let endPoint = ImageEndPoint(header: ["Content-Type": "application/json", "Authorization": "KakaoAK cff5a3414b3a2d55dce43b07873577aa"], parameter: ["query": "설현"], method: .get)
        
        container.networkService.request(requestType: endPoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                let response = try? JSONDecoder().decode(Response.self, from: data)
                self.response = response
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
                return
            case let .failure(error):
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(message: error.localizedDescription)
                }
                
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response?.documents.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageThumbnailViewCell.reuseIdentifier, for: indexPath) as? ImageThumbnailViewCell else { return UICollectionViewCell()
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self,
                  let url = self.response?.documents[indexPath.item].thumbnailURL else { return }
            let image = self.container.imageService.loadImage(by: url)
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    
}
