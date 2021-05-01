//
//  ViewController.swift
//  F1StatisticsApp
//
//  Created by Mac on 30.04.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private let defaultYear = "2020"
    private let minYear = 1980
    private let maxYear = 2021
    
    private var alertShow = false
    
    var racingData: Welcome?
    
    @IBOutlet var yearTF: UITextField!
    
    
    @IBAction func statButtonTapped() {
        prepareBeforeSegue()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let statisticsVC = segue.destination as? StatisticsViewController else { return }
        statisticsVC.data = racingData
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func fetch() {
        let statisticsRequest = StatisticsRequest(year: yearTF.text ?? defaultYear)
        statisticsRequest.getStatistics { result in
            switch result {
            case .success(let stats):
                self.racingData = stats
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func alert() {
        let ac = UIAlertController(title: "Enter year of season", message: "Enter year in range of 1980 to 2021", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(ok)
        present(ac, animated: true)
        alertShow = true
    }
    
    private func prepareBeforeSegue() {
        guard let text = yearTF.text else { return }
        if let num = Int(text), num >= minYear && num <= maxYear {
            fetch()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.afterCheckPerformSegue()
            }
        } else {
            alert()
            yearTF.text = .none
        }
    }
    
    private func afterCheckPerformSegue() {
        performSegue(withIdentifier: "statistics", sender: nil)
    }
    
}
extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        if let num = Int(newText), num >= 0 && num <= maxYear {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addDoneButtonOnKeyboard()
        if !alertShow {
            alert()
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonTapped))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        yearTF.inputAccessoryView = keyboardToolbar
    }
    
    @objc func doneButtonTapped() {
        prepareBeforeSegue()
        view.endEditing(true)
    }
}


