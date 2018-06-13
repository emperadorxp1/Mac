//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Joshua Sosa on 5/28/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class VerSnapViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var snap = Snap()
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text? = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
    }



}
