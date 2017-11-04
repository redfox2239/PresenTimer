//
//  TimerViewController.swift
//  presenTimer
//
//  Created by REO HARADA on 2017/10/22.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit
// 音を鳴らすためのパッケージをimport
import AVFoundation

class TimerViewController: UIViewController {
    
    // タイマーの設定時間（初期値は0）
    var selectTime = 0
    // アラートを鳴らすタイミングの時間（初期値は空のデータ）
    var alertTimes = [Int]()
    // タイマーを用意
    var timer: Timer!
    // タイマーが何秒経過したかを記録しておく部品
    var countTimer = 0
    // 音を出す最大ボリューム
    var maxVolume = Float(1.0)
    // 音を出す最低ボリューム
    var minVolume = Float(0.0)
    // 音の初期ボリューム
    var initVolume = Float(0.5)
    
    // ◯◯分経過しましたのアラートを表示するラベル
    @IBOutlet weak var alertLabel: UILabel!
    // タイマーのラベル
    @IBOutlet weak var timerLabel: UILabel!
    // 音を調整するUISlider
    @IBOutlet weak var volumeSlider: UISlider!
    // お気に入り登録ボタン
    @IBOutlet weak var favoriteButton: UIButton!
    
    // 音を再生してくれる部品
    var audioPlayer: AVAudioPlayer!
    
    // お気に入り登録ボタンが押せるかどうかを判定する部品（初期値はtrue）
    var isEnableFavorite = true
    
    // 画面を読み込まれたときどうするぅ？
    override func viewDidLoad() {
        super.viewDidLoad()
        // お気に入り登録ボタンが押せるかどうかを設定する
        favoriteButton.isEnabled = isEnableFavorite
        // タイマーのラベルに設定した時間を入れる
        timerLabel.text = "\(selectTime):00"
        // 音源のファイルのパス（場所または住所）を取得する
        if let filePath = Bundle.main.path(forResource: "music", ofType: "m4a") {
            // URLさんにiPhoneが分かる形にfilePathを翻訳してもらう
            if let fileURL = URL(string: filePath) {
                // AVAudioPlayerさんを呼んでくる、ついでに音源のファイルの場所を教えておく
                audioPlayer = try? AVAudioPlayer(contentsOf: fileURL)
                // audioPlayerに初期のボリュームを設定
                audioPlayer.volume = initVolume
                // audioPlayerさん音をだす準備する
                audioPlayer.prepareToPlay()
                // volumeSliderを表示する
                volumeSlider.isHidden = false
                // volumeSliderの最小値（音量の最小値）を設定する
                volumeSlider.minimumValue = minVolume
                // volumeSliderの最大値（音量の最大値）を設定する
                volumeSlider.maximumValue = maxVolume
                // いま設定されてる音源の位置にスライダーを移動する
                volumeSlider.value = initVolume
            }
        }
    }
    
    // 画面が表示される瞬間どうするぅ？
    override func viewWillAppear(_ animated: Bool) {
        // Timerさんを呼んでくる、タイマーの設定をしてスタートさせる（1.0秒のタイマー、繰り返す）
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (ti) in
            // 1秒経ったらどうするぅ？
            // もしタイマーが止められてなかったら
            if ti.isValid {
                // countTimerを+1する
                self.countTimer += 1
                // 残り時間を計算する
                let remainingTime = (self.selectTime * 60) - self.countTimer
                // 残り何分残ってるか計算する
                let remainingMinutes = Int(remainingTime/60)
                // 残り何秒残っているか計算する
                let remainingSecond = remainingTime - remainingMinutes*60
                // 残り何分、何秒をラベルに表示する（2桁表示）
                self.timerLabel.text = "\(String(format: "%02d", remainingMinutes)):\(String(format: "%02d", remainingSecond))"
                // もし、XX分00秒になったら
                if remainingSecond == 0 {
                    // もし、経過時間がalertTimesに含まれていたら
                    if self.alertTimes.contains(self.selectTime-remainingMinutes) {
                        // alertLabelを表示する
                        self.alertLabel.isHidden = false
                        // alertLabelに経過時間を表示する
                        self.alertLabel.text = "\(self.selectTime-remainingMinutes)分経ちました"
                        // もし、audioPlayerが設定されてれば
                        if self.audioPlayer != nil {
                            // 音を鳴らす
                            self.audioPlayer.play()
                        }
                        // UIViewさんを呼んでくる（アニメーションで3秒かけて、alertLabelの透明度を0%にする）
                        UIView.animate(withDuration: 3.0, animations: {
                            self.alertLabel.alpha = 0
                        }, completion: { (animate) in
                            // アニメーションが完了したら透明度を100%にもどす
                            self.alertLabel.alpha = 1.0
                            // alertLabelを隠す
                            self.alertLabel.isHidden = true
                        })
                    }
                    // もし、残り時間が0になったら
                    if remainingTime == 0 {
                        // alertLabelを表示する
                        self.alertLabel.isHidden = false
                        // alertLabelに"終了！"といれる
                        self.alertLabel.text = "終了！"
                        // もし、audioPlayerが設定されてれば
                        if self.audioPlayer != nil {
                            // 音を鳴らす
                            self.audioPlayer.play()
                        }
                        // タイマーを繰り返さない=タイマーを止める
                        ti.invalidate()
                    }
                }
            }
        })
    }
    
    // 画面が消えたあとどうするぅ？
    override func viewDidDisappear(_ animated: Bool) {
        // タイマーを繰り返さない=タイマーを止める
        timer.invalidate()
    }
    
    // メモリ解放のときどうするぅ？
    deinit {
        // タイマーを繰り返さない=タイマーを止める
        timer.invalidate()
    }
    
    // リセットボタンが押されたらどうするぅ？
    @IBAction func tapResetButton(_ sender: Any) {
        // タイマーを繰り返さない=タイマーを止める
        timer.invalidate()
        // 最初の画面=UINavigationControllerを呼んでくる
        let vc = storyboard?.instantiateViewController(withIdentifier: "FirstNavigationController")
        // UIWindowのrootにvcをセットする
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
    // 音源スライダーをスライドしたときどうするぅ？
    @IBAction func slideVolume(_ sender: Any) {
        // audioPlayerの音のボリュームをスライダーの値に変更する
        audioPlayer.volume = volumeSlider.value
    }
    
    // 音源スライダーをスライドし終わったらどうするぅ？
    @IBAction func slideEndEditing(_ sender: Any) {
        // 音量確認のため音を鳴らす
        audioPlayer.play()
    }
    
    // お気に入りボタンを押したらどうするぅ？
    @IBAction func tapFavoriteButton(_ sender: Any) {
        // お気に入りボタンを押せなくする
        (sender as? UIButton)?.isEnabled = false
        // 連想配列[Any]で、設定時間とアラートタイミングのデータを格納
        let myTimer = [selectTime, alertTimes] as [Any]
        // UserDefaultsさん（データを保存したり、取得したりしてくれる人を呼んでくる
        let userDefault = UserDefaults.standard
        // "myTimers"という場所にmyTimerのデータを保存する
        // もし、すでに"myTimers"にデータが有る場合
        if let myTimers = userDefault.object(forKey: "myTimers") as? [[Any]] {
            // myTimersにデータを追加して、"myTimers"に上書き保存する
            userDefault.set(myTimers+[myTimer], forKey: "myTimers")
        }
        else {
            // データがなければ、新規に保存を行う
            userDefault.set([myTimer], forKey: "myTimers")
        }
        // 今すぐ保存してね
        userDefault.synchronize()
    }
    
}
