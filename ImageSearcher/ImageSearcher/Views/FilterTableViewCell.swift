//
//  FilterTableViewCell.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/14.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {

    static var identifier: String {
        return String(describing: Self.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            accessoryType = .checkmark
        }
        else {
            accessoryType = .none
        }
    }
}
