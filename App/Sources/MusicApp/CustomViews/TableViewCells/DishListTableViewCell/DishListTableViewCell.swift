//
//  DishListTableViewCell.swift
//  App
//
//  Created by xianshen Jiang on 2026/10/8.
//

import UIKit

class DishListTableViewCell: UITableViewCell {

    static let identifier = "DishListTableViewCell"
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!

    func setup(dish: Music) {
         dishImageView.kf.setImage(with: dish.image?.asUrl)
         titleLbl.text = dish.name
         descriptionLbl.text = dish.description
     }
     
     func setup(order: Order) {
         dishImageView.kf.setImage(with: order.music?.image?.asUrl)
         titleLbl.text = order.music?.name
         descriptionLbl.text = order.name
     }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
