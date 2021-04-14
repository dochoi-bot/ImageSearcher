//
//  FilterViewController.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/13.
//

import UIKit

final class FilterViewController: UIViewController {

    var seletedOption: String {
        return options[selectedIndex]
    }
    private(set) var selectedIndex: Int = 0
    private var options: [String] = ["all"]
    private let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        tableView.selectRow(at: IndexPath.init(item: selectedIndex, section: 0), animated: false, scrollPosition: .none)
    }
}

extension FilterViewController {
    
    func initSelectedIndex() {
        selectedIndex = 0
    }
    
    func setOptions(_ options: [String]) {
        self.options = ["all"]
        self.options.append(contentsOf: options)
    }
}

private extension FilterViewController {
    
    func configure() {
        title = "filter"
        view.addSubview(tableView)
        let cellNib = UINib(nibName: FilterTableViewCell.identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: FilterTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
    }
}

extension FilterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier) as? FilterTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = options[indexPath.item]
        return cell
    }
}
