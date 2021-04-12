//
//  ViewController.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/09.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let networkService = NetworkService()
    var welcome: Welcome? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Searcher"
        self.navigationItem.searchController = UISearchController()
        loadImage()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 80, height: 80)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: "ImageViewCell")
        // Do any additional setup after loading the view.
    }
}

private extension MainViewController {
    func loadImage() {
        let endPoint = ImageEndPoint(parameter: ["query": "설현"], method: .get)
        
        networkService.request(requestType: endPoint) { [weak self] result in
            switch result {
            case let .success(data):
                print("success")
                let welcome = try? JSONDecoder().decode(Welcome.self, from: data)
                self!.welcome = welcome
                DispatchQueue.main.async {
                    
                    self!.collectionView.reloadData()
                }
//                print(welcome)
                return
            case let .failure(error):
                print(error)
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
        return welcome?.documents.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as? ImageViewCell else { return UICollectionViewCell()
        }
        cell.backgroundColor = .red
        return cell
    }
    
    
}
