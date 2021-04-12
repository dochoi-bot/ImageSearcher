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
    private var timer = Timer()
    private var query: String = "" {
        didSet(oldValue) {
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _  in
                guard let self = self else { return }
                if oldValue != self.query && !self.query.isEmpty {
                    self.loadImage(query: self.query)
            } else {
                self.response = nil
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dependencyInject()
        configureViews()
    }
}

private extension MainViewController {
    
    func configureViews() {
        title = "Image Searcher"
        let searchController = UISearchController()
     
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search Images"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 80, height: 80)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: ImageThumbnailViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ImageThumbnailViewCell.identifier)
  
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(refresh:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refresh(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        loadImage(query: query)
    }
    
    func dependencyInject() {
        let networkService = NetworkService()
        let imageService = ImageService()
        container = DIContainer(networkService: networkService, imageService: imageService)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
    }
    
    func loadImage(query: String) {
        let endPoint = ImageEndPoint(header: ["Content-Type": "application/json", "Authorization": "KakaoAK cff5a3414b3a2d55dce43b07873577aa"], parameter: ["query": query], method: .get)
        
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

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_: UISearchBar, textDidChange: String) {
        query = textDidChange
    }
}

extension MainViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        query.removeAll()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageThumbnailViewCell.identifier, for: indexPath) as? ImageThumbnailViewCell else { return UICollectionViewCell()
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self,
                  let response = self.response,
                  indexPath.item < response.documents.count  else { return }
            
            let url = response.documents[indexPath.item].thumbnailURL
            let image = self.container.imageService.loadImage(by: url)
            DispatchQueue.main.async {
                cell.imageView.image = image
                cell.indicator.stopAnimating()
            }
        }
        return cell
    }
}
