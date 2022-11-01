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

    let pickerTintColor = #colorLiteral(red: 0.1843137255, green: 0.6, blue: 0.4274509804, alpha: 1)
    let pickerBackgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1882352941, blue: 0.2196078431, alpha: 1)
    let toolbarBackgroundColor = #colorLiteral(red: 0.1882352941, green: 0.2235294118, blue: 0.2509803922, alpha: 1)
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: view)
        if !containerView.frame.contains(location) {
            self.dismiss(animated: true)
        }
    }
    
    
    private func configure() {
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
        containerView.backgroundColor = pickerBackgroundColor
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
    
    private func configureToolbar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        containerView.addSubview(toolbar)
        
        toolbar.barStyle = .default
        toolbar.isTranslucent = false
        toolbar.tintColor = .white
        toolbar.barTintColor = toolbarBackgroundColor
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
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.backgroundColor = .clear
        datePicker.tintColor = pickerTintColor
        
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
        pickerView.backgroundColor = pickerBackgroundColor

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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: picker.itemTypes[row].rawValue.capitalized,
                                  attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
    }
}
