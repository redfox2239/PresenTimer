//
//  SelectTimeViewController.swift
//  presenTimer
//
//  Created by REO HARADA on 2017/10/22.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit

class SelectTimeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    let maxTime = 25
    let step = 5
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var favoriteData = [[Any]]()
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefault = UserDefaults.standard
        if let myTimers = userDefault.object(forKey: "myTimers") as? [[Any]] {
            favoriteData = myTimers
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Int(maxTime / step)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\((row+1)*step)分"
    }
    
    @IBAction func tapCompleteButton(_ sender: Any) {
        let selectTime = (timePickerView.selectedRow(inComponent: 0)+1)*5
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectAlertViewController") as! SelectAlertViewController
        vc.selectTime = selectTime
        show(vc, sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let sumTime = favoriteData[indexPath.row].first as? Int else {
            return cell
        }
        guard let alertTimes = favoriteData[indexPath.row][1] as? [Int] else {
            return cell
        }
        var alertString = "アラートタイム:"
        alertTimes.forEach { (val) in
            alertString.append("\(val)分 ")
        }
        cell.textLabel?.text = "セットタイム \(sumTime)分 "+alertString
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sumTime = favoriteData[indexPath.row].first as? Int else {
            return
        }
        guard let alertTimes = favoriteData[indexPath.row][1] as? [Int] else {
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        vc.selectTime = sumTime
        vc.alertTimes = alertTimes
        vc.isEnableFavorite = false
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        favoriteData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
        let userDefault = UserDefaults.standard
        userDefault.set(favoriteData, forKey: "myTimers")
        userDefault.synchronize()
    }
    
}
