//
//  Theme_VC.swift
//  Pocket Peace
//
//  Created by Cody Walters on 4/9/17.
//  Copyright © 2017 Cody. All rights reserved.
//

import UIKit

class Theme_VC: UIViewController {

    var theme_selected = [true, false, false, false]
    
    @IBOutlet weak var btn_ocean: UIButton!
    @IBOutlet weak var btn_beach: UIButton!
    @IBOutlet weak var btn_mountain: UIButton!
    @IBOutlet weak var btn_clouds: UIButton!
    
    @IBAction func backgroundChanged(_ sender: UIButton) {
        
        let newTheme: Int = Int(sender.accessibilityIdentifier!)!
       theme_selected = [false, false, false, false]
        theme_selected[newTheme] = true
        if newTheme == 0 {
            theme = "ocean"
        }
        else if newTheme == 1 {
            theme = "beach"
        }
        else if newTheme == 2 {
            theme = "mountain"
        }
        else {
            theme = "clouds"
        }
        
        setImageHighlight()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_ocean.accessibilityIdentifier = "0"
        btn_beach.accessibilityIdentifier = "1"
        btn_mountain.accessibilityIdentifier = "2"
        btn_clouds.accessibilityIdentifier = "3"

        
        btn_ocean.layer.borderColor = UIColor.white.cgColor
        
        btn_beach.layer.borderColor = UIColor.white.cgColor
        
        btn_mountain.layer.borderColor = UIColor.white.cgColor
        
        btn_clouds.layer.borderColor = UIColor.white.cgColor
        
        setImageHighlight()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImageHighlight() {
        if theme_selected[0] {
            btn_ocean.layer.borderWidth = 3

        } else {
            btn_ocean.layer.borderWidth = 0
        }
        
        if theme_selected[1] {
            btn_beach.layer.borderWidth = 3
        } else {
            btn_beach.layer.borderWidth = 0
        }
        
        if theme_selected[2] {
            btn_mountain.layer.borderWidth = 3
        } else {
            btn_mountain.layer.borderWidth = 0
        }
        
        if theme_selected[3] {
            btn_clouds.layer.borderWidth = 3
        } else {
            btn_clouds.layer.borderWidth = 0
        }
    }

}
