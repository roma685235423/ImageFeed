//
//  ImageListCells.swift
//  ImageFeed
//
//  Created by Роман Бойко on 11/23/22.
//

import UIKit


final class ImagesListCell: UITableViewCell {

    @IBOutlet weak var imagesListCellImage: UIImageView!
    
    @IBOutlet weak var imagesListCellTextLabel: UILabel!
    
    @IBOutlet weak var imagesListCellLikeButton: UIButton!
    
    static let reusedIdentifier = "ImagesListCell"
    
}
