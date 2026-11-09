//
//  DishPortraitCollectionViewCell.swift
//  App
//
//  Created by xianshen Jiang on 2026/10/7.
//

import UIKit

class DishPortraitCollectionViewCell: UICollectionViewCell {

    static let identifier = "DishPortraitCollectionViewCell"
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var caloriesLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    func setup(music: Music) {
        titleLbl.text = music.name
        dishImageView.kf.setImage(with: music.image?.asUrl)
        caloriesLbl.text = music.formattedCalories
        descriptionLbl.text = music.description
    }
}
