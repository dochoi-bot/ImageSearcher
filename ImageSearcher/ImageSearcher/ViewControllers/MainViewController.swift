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
    private var documents: [Document] = []
    private var state: MainViewState = MainViewState(totalCount: 0, pageableCount: 0, isEnd: true, pageIndex: 0)
    private var timer = Timer()
    private var footerView: UICollectionReusableView?
    private var query: String = "" {
        didSet(oldValue) {
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self, query] _  in
                guard let self = self else { return }
                if !query.isEmpty {
                    self.fetchData(query: query)
            } else {
                self.documents = []
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
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = UICollectionViewFlowLayout()

        layout.minimumLineSpacing = .defaultSpacing
        layout.minimumInteritemSpacing = .defaultSpacing
        collectionView.contentInset = .init(top: 0, left: .defaultPadding, bottom: 0, right: .defaultPadding)
        
        let flexibleWidth = CGFloat.flexibleWidth(minimum: 90, maximum: 130, baseWidth: collectionView.bounds.width)
        layout.itemSize = .init(width: flexibleWidth, height: flexibleWidth)
        collectionView.collectionViewLayout = layout
    }
    
    private func createSpinnerFooter() -> UIView {
          let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 100))
          
          let spinner = UIActivityIndicatorView()
          spinner.center = footerView.center
          footerView.addSubview(spinner)
          spinner.startAnimating()
          
          return footerView
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
    
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cellNib = UINib(nibName: ImageThumbnailViewCell.identifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: ImageThumbnailViewCell.identifier)
  
        let footerNib = UINib(nibName: FooterView.identifier, bundle: nil)
        collectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.identifier)
    }
    
    func dependencyInject() {
        let networkService = NetworkService()
        let imageService = ImageService()
        container = DIContainer(networkService: networkService, imageService: imageService)
    }
    
    func errorHandler(message: String) {
        documents = []
        state = MainViewState(totalCount: 0, pageableCount: 0, isEnd: true, pageIndex: 1)
        self.state.isPagianting = false
        self.footerView?.isHidden = true
        self.collectionView.reloadData()
        showAlert(message: message)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchData(query: String) {
        let endPoint = ImageEndPoint(header: ["Content-Type": "application/json", "Authorization": "KakaoAK cff5a3414b3a2d55dce43b07873577aa"], parameter: ["query": query], method: .get)
        
        container.networkService.request(requestType: endPoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                guard let response = try? JSONDecoder().decode(Response.self, from: data) else { return }
                self.state = MainViewState(totalCount: response.meta.totalCount, pageableCount: response.meta.pageableCount, isEnd: response.meta.isEnd, pageIndex: 1)
                self.documents = response.documents
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
                return
            case let .failure(error):
                DispatchQueue.main.async { [weak self] in
                    self?.errorHandler(message: error.localizedDescription)
                }
                
            }
        }
    }
    
    func appendData(query: String) {
        guard !state.isEnd else { return }
        let endPoint = ImageEndPoint(header: ["Content-Type": "application/json", "Authorization": "KakaoAK cff5a3414b3a2d55dce43b07873577aa"], parameter: ["query": query], method: .get)
        container.networkService.request(requestType: endPoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                guard let response = try? JSONDecoder().decode(Response.self, from: data) else { return }
                self.state = MainViewState(totalCount: response.meta.totalCount, pageableCount: response.meta.pageableCount, isEnd: response.meta.isEnd, pageIndex: self.state.pageIndex + 1)
                self.documents.append(contentsOf: response.documents)
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                    self?.state.isPagianting = false
                    self?.footerView?.isHidden = true
                }
                return
            case let .failure(error):
                DispatchQueue.main.async { [weak self] in
                    self?.errorHandler(message: error.localizedDescription)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterView.identifier, for: indexPath)
        footerView.isHidden = true
        self.footerView = footerView
          return footerView

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !state.isPagianting,
              !query.isEmpty else { return }
        let position = scrollView.contentOffset.y
        if position > collectionView.contentSize.height  - scrollView.frame.size.height {
            state.isPagianting = true
            footerView?.isHidden = false
            appendData(query: query)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100.0)
 }

}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageThumbnailViewCell.identifier, for: indexPath) as? ImageThumbnailViewCell else { return UICollectionViewCell()
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self,
                  indexPath.item < self.documents.count  else { return }
            
            let url = self.documents[indexPath.item].thumbnailURL
            let image = self.container.imageService.loadImage(by: url)
            DispatchQueue.main.async {
                cell.imageView.image = image
                cell.indicator.stopAnimating()
            }
        }
        return cell
    }
}
