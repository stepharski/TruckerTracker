//
//  TRPickerVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/22/22.
//

import UIKit

protocol TRPickerVCDelegate: AnyObject {
    func didSelectDate(date: Date)
    func didSelectPickerItem()
}

class TRPickerVC: UIViewController {
    
    var picker: PickerType!
    let toolbar = UIToolbar()
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    
    init(picker: PickerType) {
        super.init(nibName: nil, bundle: nil)
        self.picker = picker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        configureToolbar()
        
        switch picker {
        case .date:
            configureDatePicker()
        case .frequency, .fuel:
            configurePickerView()
        case .none:
            break
        }
    }
    
    private func configureToolbar() {
        view.addSubview(toolbar)
        
        toolbar.barStyle = .default
        toolbar.tintColor = .black
        toolbar.isTranslucent = false
        toolbar.isUserInteractionEnabled = true
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                           action: #selector(cancelButtonPressed(_:)))
        let flexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                         action: #selector(doneButtonPressed(_:)))
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
    }
    
    @objc func cancelButtonPressed(_ button: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func doneButtonPressed(_ button: UIBarButtonItem) {
        //TODO: Pass data
        self.dismiss(animated: true)
    }
    
    private func configureDatePicker() {
        view.addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .black
        datePicker.backgroundColor = #colorLiteral(red: 0.9251462817, green: 0.9367927313, blue: 0.9365878701, alpha: 1)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.addSubview(pickerView)

        pickerView.backgroundColor = #colorLiteral(red: 0.9251462817, green: 0.9367927313, blue: 0.9365878701, alpha: 1)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension TRPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker.itemTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker.itemTypes[row].rawValue.capitalized
    }
}
