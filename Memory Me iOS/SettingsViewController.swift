//
//  SettingsViewController.swift
//  Memory Me iOS
//
//  Created by Tristan Dube on 2019-03-23.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import UIKit

protocol SettingsChangeDelegate
{
    init()
    
    func settingsAccepted(_ vm: SettingsViewModel);
    
    func settingsCancelled();
    
    func deleteDataRequest();
}

class SettingsViewController : UITableViewController
{
    public var settingsDelegate: SettingsChangeDelegate?;
    public var viewModel = SettingsViewModel();
    
    @IBOutlet weak private var cheatsSwitch: UISwitch!;
    @IBOutlet weak private var debugLayerSwitch: UISwitch!;
    @IBOutlet weak private var trackingSwitch: UISwitch!;
    
    override func viewDidLoad()
    {
        cheatsSwitch.isOn = viewModel.enableCheats;
        debugLayerSwitch.isOn = viewModel.showDebugLayer;
        trackingSwitch.isOn = viewModel.enableTracking;
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        viewModel.enableCheats = cheatsSwitch.isOn;
        viewModel.showDebugLayer = debugLayerSwitch.isOn;
        viewModel.enableTracking = trackingSwitch.isOn;
        
        // TODO : Check if accepted or cancelled
        settingsDelegate?.settingsAccepted(viewModel);
    }
    
    @IBAction func deleteDataPressed(_ sender: UIButton)
    {
        settingsDelegate?.deleteDataRequest();
        
        self.navigationController?.popViewController(animated: true);
    }
    
}
