//
//  MemeDetailViewController.swift
//  MemeApp
//
//  Created by Nourah on 08/12/2018.
//  Copyright © 2018 Nourah. All rights reserved.
//
import UIKit

// MARK: - VillainDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var meme: Meme!
    
    // MARK: Outlets
    
   
    @IBOutlet weak var image : UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
//       self.image!.image = UIImage(named: meme.memedImage)
        self.image!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
