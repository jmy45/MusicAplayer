//
//  DishDetailViewController.swift
//  App
//
//  Created by xianshen Jiang on 2026/10/8.
//

import UIKit
import ProgressHUD
import SwiftUI

class DishDetailViewController: UIViewController {

    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var caloriesLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var nameField: UITextField!

    var music: Music!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
    }
    
    private func populateView() {
         dishImageView.kf.setImage(with: music.image?.asUrl)
         titleLbl.text = music.name
         descriptionLbl.text = music.description
         caloriesLbl.text = music.formattedCalories
     }
    
    @IBAction func PlaceOrderBtnClicked(_ sender: UIButton) {
//        guard let name = nameField.text?.trimmingCharacters(in: .whitespaces),
//                      !name.isEmpty else {
//                    ProgressHUD.showError("Please enter your name")
//                    return
//                }
//        ProgressHUD.show("Placing Order...")
//        NetworkService.shared.placeOrder(dishId: dish.id ?? "", name: name) { (result) in
//            switch result {
//            case .success(_):
//                ProgressHUD.showSuccess("Your order has been received. 👨🏼‍🍳")
//            case .failure(let error):
//                ProgressHUD.showError(error.localizedDescription)
//            }
//        }
        let viewModal = PlayerView.ViewModel.shared
        let iv = UIImageView()
        iv.kf.setImage(with: music.album_cover_image.asUrl)
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                Task{@MainActor [weak self] in
                    guard let self else {return}
                    AudioController.shared.additem(audiourl: music.playurl, artist:String(localized:"jay chou"), title: music.name!, albumTitle: music.album,artworkimage: iv.image)
                    let swiftUIView = PlayerView(viewModel: viewModal)
                    let hostingController = UIHostingController(rootView: swiftUIView)
                    navigationController?.pushViewController(hostingController, animated: true)
                }
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
