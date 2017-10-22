//
//  TimerViewController.swift
//  presenTimer
//
//  Created by REO HARADA on 2017/10/22.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    
    var selectTime = 0
    var alertTimes = [Int]()
    var timer: Timer!
    var countTimer = 0
    var maxVolume = Float(1.0)
    var minVolume = Float(0.0)
    var initVolume = Float(0.5)
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    
    var isEnableFavorite = true
    
    override func viewDidLoad() {
        favoriteButton.isEnabled = isEnableFavorite
        timerLabel.text = "\(selectTime):00"
        if let filePath = Bundle.main.path(forResource: "music", ofType: "m4a") {
            if let fileURL = URL(string: filePath) {
                audioPlayer = try? AVAudioPlayer(contentsOf: fileURL)
                audioPlayer.volume = initVolume
                audioPlayer.prepareToPlay()
                volumeSlider.isHidden = false
                volumeSlider.minimumValue = minVolume
                volumeSlider.maximumValue = maxVolume
                volumeSlider.value = initVolume
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (ti) in
            if ti.isValid {
                self.countTimer += 1
                let remainingTime = (self.selectTime * 60) - self.countTimer
                let remainingMinutes = Int(remainingTime/60)
                print(remainingMinutes)
                let remainingSecond = remainingTime - remainingMinutes*60
                self.timerLabel.text = "\(String(format: "%02d", remainingMinutes)):\(String(format: "%02d", remainingSecond))"
                if remainingSecond == 0 {
                    if self.alertTimes.contains(self.selectTime-remainingMinutes) {
                        self.alertLabel.isHidden = false
                        self.alertLabel.text = "\(self.selectTime-remainingMinutes)分経ちました"
                        if self.audioPlayer != nil {
                            self.audioPlayer.play()
                        }
                        UIView.animate(withDuration: 3.0, animations: {
                            self.alertLabel.alpha = 0
                        }, completion: { (animate) in
                            self.alertLabel.alpha = 1.0
                            self.alertLabel.isHidden = true
                        })
                    }
                    if self.selectTime == remainingMinutes {
                        self.alertLabel.isHidden = false
                        self.alertLabel.text = "終了！"
                        if self.audioPlayer != nil {
                            self.audioPlayer.play()
                        }
                        ti.invalidate()
                    }
                }
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    deinit {
        timer.invalidate()
    }
    
    @IBAction func tapResetButton(_ sender: Any) {
        timer.invalidate()
        let vc = storyboard?.instantiateViewController(withIdentifier: "FirstNavigationController")
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
    @IBAction func slideVolume(_ sender: Any) {
        audioPlayer.volume = volumeSlider.value
    }
    
    @IBAction func tapFavoriteButton(_ sender: Any) {
        (sender as? UIButton)?.isEnabled = false
        let myTimer = [selectTime, alertTimes] as [Any]
        let userDefault = UserDefaults.standard
        if let myTimers = userDefault.object(forKey: "myTimers") as? [[Any]] {
            userDefault.set(myTimers+[myTimer], forKey: "myTimers")
        }
        else {
            userDefault.set([myTimer], forKey: "myTimers")
        }
        userDefault.synchronize()
    }
    
    @IBAction func slideEndEditing(_ sender: Any) {
        audioPlayer.play()
    }
    
}
