//
//  ViewController.swift
//  Pocket Peace
//
//  Created by Cody on 4/7/17.
//  Copyright © 2017 Cody. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

var metronomeTimer: Timer!
var oceanTimer: Timer!
var theme: String! = "ocean"

class MetronomeViewController: UIViewController {
    var player: AVPlayer?

    var metronomeIsOn = false
    var walkingIsOn = false
    var breathingIsOn = false
    
    var metronomeSoundPlayer: AVAudioPlayer!
    var oceanSoundPlayer: AVAudioPlayer!
    var tempo: TimeInterval = 60
    
    var themeList = ["ocean", "beach", "mountain", "clouds"]
    
    @IBOutlet weak var backgroundSoundSwitch: UISwitch!
    @IBOutlet weak var btn_walking: UIButton!
    @IBOutlet weak var btn_breathing: UIButton!
    @IBOutlet weak var img_Square: UIImageView!
    @IBOutlet weak var img_theme: UIImageView!
    
    @IBAction func toggleOceanSound(_ sender: UISwitch) {
        if backgroundSoundSwitch.isOn {
            let oceanTimeInterval:TimeInterval = 0
            oceanTimer = Timer.scheduledTimer(timeInterval: oceanTimeInterval, target: self, selector: #selector(MetronomeViewController.playOceanSound), userInfo: nil, repeats: true)
            metronomeTimer?.fire()
            print("playing")
        } else {
            oceanSoundPlayer.pause()
            oceanTimer.invalidate()
            print("pausing")
        }
        
    }
    
    @IBAction func toggleSquare(_ sender: UIButton) {
        if img_Square.isHidden {
            img_Square.isHidden = false
        } else {
            img_Square.isHidden = true
        }
    }
    
    
    
    @IBAction func toggleMetronome(_ toggleMetronomeButton: UIButton) {
        let toggleMetronomeButton = toggleMetronomeButton
        
        // If the metronome is currently on
        if metronomeIsOn {
            
            if toggleMetronomeButton.restorationIdentifier == "walking" && walkingIsOn {
                // Mark the metronome as off
                metronomeIsOn = false
                walkingIsOn = false
                // Stop the timer
                metronomeTimer?.invalidate()
                btn_walking.layer.borderWidth = 0
            }
            else if toggleMetronomeButton.restorationIdentifier == "breathing" && breathingIsOn {
                // Mark the metronome as off
                metronomeIsOn = false
                breathingIsOn = false
                // Stop the timer
                metronomeTimer?.invalidate()
                btn_breathing.layer.borderWidth = 0
            }
            else if toggleMetronomeButton.restorationIdentifier == "walking" && breathingIsOn {
                breathingIsOn = false
                walkingIsOn = true
                btn_breathing.layer.borderWidth = 0
                btn_walking.layer.borderWidth = 3
                // Stop the timer
                metronomeTimer?.invalidate()
                // Set new tempo
                tempo = 65
                // Start the metronome.
                startMetronome()
            }
            else if toggleMetronomeButton.restorationIdentifier == "breathing" && walkingIsOn {
                breathingIsOn = true
                walkingIsOn = false
                btn_breathing.layer.borderWidth = 3
                btn_walking.layer.borderWidth = 0
                // Stop the timer
                metronomeTimer?.invalidate()
                // Set new tempo
                tempo = 30
                // Start the metronome.
                startMetronome()
            }
        }
            
            // If the metronome is currently off, start the metronome and change
        else {
            // Mark the metronome as on.
            metronomeIsOn = true
            if toggleMetronomeButton.restorationIdentifier == "walking" {
                walkingIsOn = true
                tempo = 65
                btn_walking.layer.borderWidth = 3
                btn_breathing.layer.borderWidth = 0
            } else {
                breathingIsOn = true
                tempo = 30
                btn_walking.layer.borderWidth = 0
                btn_breathing.layer.borderWidth = 3
            }
            
            // Start the metronome.
            startMetronome()
        }
    }
    
    func touchesBegan(_ touches: NSSet, with event: UIEvent) {
        // Hide the keyboard
    }
    
    func playMetronomeSound() {
        let currentTime = CFAbsoluteTimeGetCurrent()
        print("Play metronome sound @ \(currentTime)")
        
        metronomeSoundPlayer.play()
    }
    
    func startMetronome() {
        let metronomeTimeInterval:TimeInterval = 60.0 / tempo
        metronomeTimer = Timer.scheduledTimer(timeInterval: metronomeTimeInterval, target: self, selector: #selector(MetronomeViewController.playMetronomeSound), userInfo: nil, repeats: true)
        metronomeTimer?.fire()
    }
    
    func playOceanSound() {
        oceanSoundPlayer.play()
    }
    
    // MARK: - UIViewController
    // MARK: Managing the View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //theme = "ocean"
        btn_walking.layer.cornerRadius = 15
        btn_walking.layer.borderWidth = 0
        btn_walking.layer.borderColor = UIColor.white.cgColor
        
        btn_breathing.layer.cornerRadius = 15
        btn_breathing.layer.borderWidth = 0
        btn_breathing.layer.borderColor = UIColor.white.cgColor
        
        //img_Square.isHidden = true
    
        // Set the inital value of the tempo.
        tempo = 120
        
        // Initialize the sound player
        let metronomeSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "metronomeClick", ofType: "mp3")!)
        
        let oceanSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "ocean", ofType: "mp3")!)
        do {
            let metronomeSound = try AVAudioPlayer(contentsOf: metronomeSoundURL)
            metronomeSoundPlayer = metronomeSound
            metronomeSound.prepareToPlay()
            
            let oceanSound = try AVAudioPlayer(contentsOf: oceanSoundURL)
            oceanSoundPlayer = oceanSound
            oceanSound.prepareToPlay()
        } catch {
            // couldn't load file :(
        }
        
        let oceanTimeInterval:TimeInterval = 0
        oceanTimer = Timer.scheduledTimer(timeInterval: oceanTimeInterval, target: self, selector: #selector(MetronomeViewController.playOceanSound), userInfo: nil, repeats: true)
        metronomeTimer?.fire()
        
        // Load the video from the app bundle.
        let videoURL: URL = Bundle.main.url(forResource: "background_ocean", withExtension: "mp4")!
        
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MetronomeViewController.loopVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        img_theme.image = UIImage(named: theme)
    }
    
    func loopVideo() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
}



