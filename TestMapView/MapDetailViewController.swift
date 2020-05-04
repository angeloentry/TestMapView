//
//  MapDetailViewController.swift
//  TestMapView
//
//  Created by user167484 on 4/13/20.
//  Copyright © 2020 Allen Savio. All rights reserved.
//

import UIKit

class MapDetailViewController: UIViewController {
    var address: String = ""
    
    
    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressLabel.text = address
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
