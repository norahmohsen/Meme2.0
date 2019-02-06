//
//  MemeTableView.swift
//  MemeApp
//
//  Created by Nourah on 10/12/2018.
//  Copyright © 2018 Nourah. All rights reserved.


import UIKit

class MemeTableView: UITableViewController,
UINavigationControllerDelegate {
    //UITableViewDataSource,UITableViewDelegate
   
    @IBOutlet var myTableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    //    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the image
        
        cell.imageView?.image = meme.memedImage
        //
        //      cell.imageView?.image = self.memes[(indexPath as NSIndexPath).row].memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
       
    }
    
    
    
}
