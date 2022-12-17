//
//  DatePickerVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/15/22.
//

import UIKit

protocol DatePickerVCDelegeate: AnyObject {
    func didSelect(date: Date)
}

class DatePickerVC: UIViewController {
    
    let pickerTintColor = #colorLiteral(red: 0.1843137255, green: 0.6, blue: 0.4274509804, alpha: 1)
    
    var toolbar = UIToolbar()
    var datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureToolbar()
        configureDatePicker()
    }

    // Toolbar
    private func configureToolbar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        view.addSubview(toolbar)

        toolbar.barStyle = .default
        toolbar.isTranslucent = false
        toolbar.tintColor = UIColor.label
        toolbar.barTintColor = .systemGray4
        toolbar.isUserInteractionEnabled = true

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                           action: #selector(cancelButtonPressed(_:)))
        let flexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                         action: #selector(doneButtonPressed(_:)))
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: true)
    }
    
    @objc private func cancelButtonPressed(_ button: UIBarButtonItem) {
        self.dismiss(animated: true)
    }

    @objc private func doneButtonPressed(_ button: UIBarButtonItem) {
        //TODO: Pass data
        self.dismiss(animated: true)
    }
    
    
    // DatePicker
    func configureDatePicker() {
        view.addSubview(datePicker)

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.backgroundColor = .systemGray5
        datePicker.tintColor = pickerTintColor

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
