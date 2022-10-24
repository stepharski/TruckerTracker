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
    var toolbar = UIToolbar()
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    let containerView = UIView()
    
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
        bindTapGestures()
        view.backgroundColor = .clear
        
        configureContainerView()
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
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        let containerHeight: CGFloat = picker == .date ?
        view.bounds.height * 0.52 : view.bounds.height * 0.35
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
    }
    
    private func bindTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: true)
    }
    
    private func configureToolbar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        containerView.addSubview(toolbar)
        
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
    }
    
    @objc private func cancelButtonPressed(_ button: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc private func doneButtonPressed(_ button: UIBarButtonItem) {
        //TODO: Pass data
        self.dismiss(animated: true)
    }
    
    private func configureDatePicker() {
        containerView.addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .black
        datePicker.backgroundColor = #colorLiteral(red: 0.9251462817, green: 0.9367927313, blue: 0.9365878701, alpha: 1)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        containerView.addSubview(pickerView)

        
        pickerView.backgroundColor = #colorLiteral(red: 0.9450981021, green: 0.9450981021, blue: 0.9450981021, alpha: 1)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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
