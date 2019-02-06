//
//  MemeClass.swift
//  MemeApp
//
//  Created by Nourah on 17/11/2018.
//  Copyright © 2018 Nourah. All rights reserved.
//


import UIKit
struct Meme{
    var topTextField =  ""
    var bottomTextField =  ""
    var imageView : UIImage!
    var memedImage : UIImage
    
    
    init(_ topTextField : String, _ bottomTextField : String, _ imageView : UIImage, _ memedImage : UIImage ) {
        
        self.topTextField = topTextField
        self.bottomTextField = bottomTextField
        self.imageView = imageView
        self.memedImage = memedImage
    }
}
