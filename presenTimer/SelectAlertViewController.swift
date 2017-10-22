//
//  SelectAlertViewController.swift
//  presenTimer
//
//  Created by REO HARADA on 2017/10/22.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit

class SelectAlertViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    var selectTime = 0
    @IBOutlet weak var alertPickerView: UIPickerView!
    @IBOutlet weak var alertTableView: UITableView!
    @IBOutlet weak var completeButton: UITableView!
    var alertTimes = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
//        view.sendSubview(toBack: alertTableView)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectTime-1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)分経過後"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(alertTimes[indexPath.row])分経過後"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        alertTimes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
    }
    
    @IBAction func tapAddAlertButton(_ sender: Any) {
        let selectedAlertTime = alertPickerView.selectedRow(inComponent: 0) + 1
        if alertTimes.contains(selectedAlertTime) {
            return
        }
        alertTimes.append(selectedAlertTime)
        alertTableView.reloadData()
    }
    
    @IBAction func tapCompleteButton(_ sender: Any) {
        if alertTimes.count > 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
            vc.selectTime = selectTime
            vc.alertTimes = alertTimes
            present(vc, animated: true, completion: nil)
        }
    }
}
