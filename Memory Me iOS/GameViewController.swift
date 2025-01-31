//
//  GameViewController.swift
//  Memory Me iOS
//
//  Created by Tristan Dube on 2019-01-03.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, SettingsChangeDelegate
{
    var seenDisclaimers = false;
    var loadedGameScene: GameScene?;
    
    @IBAction func screenEdgeSwipe(_ sender: UIGestureRecognizer) {
        print("wololo");
        
        if(sender.state == .ended)
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController;
            newViewController.settingsDelegate = self;
            newViewController.viewModel = loadedGameScene?.sendUserPreferences() ?? SettingsViewModel();
            
            self.navigationController?.pushViewController(newViewController, animated: true);
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
        
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let showDisclaimers = PreferenceManager.current.GetSkipBetaView() == false;
        
        if(showDisclaimers && seenDisclaimers == false)
        {
            seenDisclaimers = true;
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Disclaimer") as! BetaInfoViewController;
            
            self.present(newViewController, animated: false);
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        self.navigationController?.setNavigationBarHidden(false, animated: false);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene.newGameScene();
        
        loadedGameScene = scene;

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        //skView.showsFPS = true
        //skView.showsNodeCount = true
    }
    
    func settingsAccepted(_ vm: SettingsViewModel)
    {
        loadedGameScene?.receiveUpdatedPreferences(vm);
    }
    
    func settingsCancelled()
    {
        
    }
    
    func deleteDataRequest()
    {
        self.loadedGameScene?.deletePlayerData();
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator);
        
        self.loadedGameScene?.changedOrientation(to: size);
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
