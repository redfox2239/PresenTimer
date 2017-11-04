//
//  SelectTimeViewController.swift
//  presenTimer
//
//  Created by REO HARADA on 2017/10/22.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit

// UIPickerViewと相談する準備
// UITableViewと相談する準備
class SelectTimeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    // タイマーの最大設定値（分）
    let maxTime = 25
    // タイマーの設定幅（分）
    let step = 5
    // UIPickerViewの名前
    @IBOutlet weak var timePickerView: UIPickerView!
    // UITableViewの名前
    @IBOutlet weak var favoriteTableView: UITableView!
    
    // お気にリイタイマーのデータ
    var favoriteData = [[Any]]()
    
    // 画面が表示される瞬間どうするぅ？
    override func viewWillAppear(_ animated: Bool) {
        // UserDefaultsさん（データを保存したり、取得したりしてくれる人を呼んでくる
        let userDefault = UserDefaults.standard
        // 保存されてるお気に入りのタイマーを取得する("myTimers"という場所にある)
        if let myTimers = userDefault.object(forKey: "myTimers") as? [[Any]] {
            favoriteData = myTimers
        }
    }
    
    // ********** UIPickerViewとの相談 **********
    // コンポーネントの数どうするぅ？
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 1でお願いします
        return 1
    }
    
    // コンポーネント内の行数はどうするぅ？
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 25÷5 = 5 個でお願いします。
        return Int(maxTime / step)
    }
    
    // 各行のデータはどうするぅ？
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 0行目→(0+1)x5=5分でお願いします
        // 1行目→(1+1)x5=10分でお願いします
        // 2行目→(2+1)x5=15分でお願いします
        // ・・・
        return "\((row+1)*step)分"
    }
    // ********** UIPickerViewとの相談 **********
    
    // ********** UITableViewとの相談 **********
    // セクションの数どうするぅ？
    func numberOfSections(in tableView: UITableView) -> Int {
        // 1個でお願いします
        return 1
    }
    
    // セクション内のセルの数どうするぅ？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // favoriteDataの数でお願いします
        return favoriteData.count
    }
    
    // 各行のセルの中身どうするぅ？
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // "cell"と名前つけた白いセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // xx番目のfavoriteDataの最初のデータを取得する（合計値）
        guard let sumTime = favoriteData[indexPath.row].first as? Int else {
            return cell
        }
        // xx番目のfavoriteDataの二番目のデータを取得する（アラートを鳴らすタイミングの値）
        guard let alertTimes = favoriteData[indexPath.row][1] as? [Int] else {
            return cell
        }
        // アラートタイムの時間
        var alertString = "アラートタイム:"
        // alertTimesを一行一行みていく
        alertTimes.forEach { (val) in
            // alertStringに一つずつ文字を結合する
            alertString.append("\(val)分 ")
        }
        // セルのラベルに文字を設定する
        cell.textLabel?.text = "セットタイム \(sumTime)分 "+alertString
        // 文字数が多いと切れてしまうため、ラベルの行数を0行に設定しておく（無制限）
        cell.textLabel?.numberOfLines = 0
        // 文字数に合わせてサイズを調整
        cell.textLabel?.sizeToFit()
        // このセルでお願いします
        return cell
    }
    
    // セルを選択したときどうするぅ？
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // xx番目のfavoriteDataの最初のデータを取得する（合計値）
        guard let sumTime = favoriteData[indexPath.row].first as? Int else {
            return
        }
        // xx番目のfavoriteDataの二番目のデータを取得する（アラートを鳴らすタイミングの値）
        guard let alertTimes = favoriteData[indexPath.row][1] as? [Int] else {
            return
        }
        // 移動先の画面を呼んでくる
        let vc = storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        // タイマーの時間を渡す
        vc.selectTime = sumTime
        // アラートを鳴らす時間のデータを渡す
        vc.alertTimes = alertTimes
        // お気に入りのデータからタイマーを起動したため、お気に入りボタンが押せないようにしておく（すでにお気に入り登録されてるため）
        vc.isEnableFavorite = false
        // 移動先の画面を表示する
        present(vc, animated: true, completion: nil)
    }
    
    // セルを削除したときどうするするぅ？
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // favoriteDataから選択した行のデータを削除
        favoriteData.remove(at: indexPath.row)
        // tableViewから指定の行を削除
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
        // UserDefaultsさん（データを保存したり、取得したりしてくれる人を呼んでくる
        let userDefault = UserDefaults.standard
        // favoriteDataを上書き保存する
        userDefault.set(favoriteData, forKey: "myTimers")
        // 今すぐ保存してね
        userDefault.synchronize()
    }
    // ********** UITableViewとの相談 **********
    
    // 決定ボタンを押したときどうするぅ？
    @IBAction func tapCompleteButton(_ sender: Any) {
        // (timePickerViewで選択した行 + 1)x5して、設定したいタイマーの時間を取得する
        let selectTime = (timePickerView.selectedRow(inComponent: 0)+1)*step
        // 移動先の画面を呼んでくる
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectAlertViewController") as! SelectAlertViewController
        // timePickerViewを次の画面に渡す
        vc.selectTime = selectTime
        // 移動先の画面を表示する
        show(vc, sender: nil)
    }

}
