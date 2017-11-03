//
//  SelectAlertViewController.swift
//  presenTimer
//
//  Created by REO HARADA on 2017/10/22.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit

// UIPickerViewと相談する準備
// UITableViewと相談する準備
class SelectAlertViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    // 設定したタイマーの時間（初期値は0分にしておく）
    var selectTime = 0
    // UIPickerViewの名前
    @IBOutlet weak var alertPickerView: UIPickerView!
    // UITableViewの名前
    @IBOutlet weak var alertTableView: UITableView!
    // 設定完了ボタン
    @IBOutlet weak var completeButton: UITableView!
    // アラートを鳴らすタイミングのデータ
    var alertTimes = [Int]()

    // ********** UIPickerViewとの相談 **********
    // コンポーネントの数どうするぅ？
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 1でお願いします
        return 1
    }
    
    // コンポーネント内の行数はどうするぅ？
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 設定した時間 - 1でお願いします
        return selectTime-1
    }
    
    // 各行のデータはどうするぅ？
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 0行目→0+1=1分経過後でお願いします
        // 1行目→1+1=2分経過後でお願いします
        // 2行目→2+1=3分経過後でお願いします
        // ・・・
        return "\(row+1)分経過後"
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
        // alertTimesの数でお願いします
        return alertTimes.count
    }
    
    // 各行のセルの中身どうするぅ？
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // "cell"と名前つけた白いセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // xx番目のalertTimesのデータをラベルに入れる
        cell.textLabel?.text = "\(alertTimes[indexPath.row])分経過後"
        // このセルでお願いします
        return cell
    }
    
    // セルを削除したときどうするするぅ？
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // alertTimesから選択した行のデータを削除する
        alertTimes.remove(at: indexPath.row)
        // tableViewから指定の行を削除
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
    }
    
    // 追加ボタンを押したらどうするぅ？
    @IBAction func tapAddAlertButton(_ sender: Any) {
        // alertPickerViewの選択した行 + 1分のデータを取得
        let selectedAlertTime = alertPickerView.selectedRow(inComponent: 0) + 1
        // alertTimesにすでにselectedAlertTimeが登録されていたら、登録しないで終了
        if alertTimes.contains(selectedAlertTime) {
            return
        }
        // alertTimesにselectedAlertTimeを追加する
        alertTimes.append(selectedAlertTime)
        // alertTableViewと相談し直す
        alertTableView.reloadData()
    }
    
    // 完了ボタン押されたらどうするぅ？
    @IBAction func tapCompleteButton(_ sender: Any) {
        // alertTimesの数が0より大きければ
        if alertTimes.count > 0 {
            // 移動先の画面を呼んでくる
            let vc = storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
            // 移動先の画面にタイマーの設定時間を渡す
            vc.selectTime = selectTime
            // 移動先の画面にアラートを鳴らしてほしいタイミングの時間を渡す
            vc.alertTimes = alertTimes
            // 呼んできた画面を表示する
            present(vc, animated: true, completion: nil)
        }
    }
}
