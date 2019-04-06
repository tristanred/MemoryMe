//
//  BetaInfoViewController.swift
//  Memory Me iOS
//
//  Created by Tristan Dube on 2019-03-31.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation
import UIKit

class BetaInfoViewController : UIViewController
{
    @IBOutlet weak var SkipViewSwitch: UISwitch!
    
    @IBAction func OkButtonClicked(_ sender: UIButton)
    {
        self.dismiss(animated: false, completion: nil);
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
        
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated);
        
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        
        if(SkipViewSwitch.isOn)
        {
            PreferenceManager.current.SetSkipBetaView(toValue: true);
            
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        // Doesn't do anything apparently.
        return .portrait;
    }
}
