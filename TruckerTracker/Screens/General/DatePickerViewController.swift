//
//  DatePickerViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/2/23.
//

import UIKit

// MARK: - DatePicker Delegeate
protocol DatePickerDelegeate: AnyObject {
    func didSelect(date: Date)
}

// MARK: - DatePicker ViewController
class DatePickerViewController: UIViewController {
    
    let pickerTintColor: UIColor = #colorLiteral(red: 0.1843137255, green: 0.6, blue: 0.4274509804, alpha: 1)
    let toolbarColor: UIColor = .systemGray5
    let pickerBackgroundColor: UIColor = .systemGray6
    
    private var toolbar = UIToolbar()
    private var datePicker = UIDatePicker()
    
    weak var delegate: DatePickerDelegeate?
    
    var pickerDate: Date? {
        didSet { datePicker.date = pickerDate ?? Date().local() }
    }
    
    
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
        toolbar.barTintColor = toolbarColor
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
        delegate?.didSelect(date: datePicker.date)
        self.dismiss(animated: true)
    }
    
    
    // DatePicker
    func configureDatePicker() {
        view.addSubview(datePicker)

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.backgroundColor = pickerBackgroundColor
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
