//
//  TRPickerVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/22/22.
//

import UIKit

// MARK: - TRPickerDelegate
protocol TRPickerDelegate: AnyObject {
    func didSelectRow(_ row: Int)
}

// MARK: - TRPickerVC
class TRPickerVC: UIViewController {
    
    let pickerTintColor: UIColor = #colorLiteral(red: 0.1843137255, green: 0.6, blue: 0.4274509804, alpha: 1)
    let toolbarColor: UIColor = .systemGray5
    let pickerBackgroundColor: UIColor = .systemGray6
    
    private var toolbar = UIToolbar()
    private let containerView = UIView()
    private let pickerView = UIPickerView()

    var pickerItems: [String]!
    var selectedRow: Int!
    
    var delegate: TRPickerDelegate?
    
    // Life cycle
    init(pickerItems: [String], selectedRow: Int) {
        super.init(nibName: nil, bundle: nil)
        self.pickerItems = pickerItems
        self.selectedRow = selectedRow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContainerView()
        configureToolbar()
        configurePickerView()
    }
    
    // Dismiss on background tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first else { return }

        let location = touch.location(in: view)
        if !containerView.frame.contains(location) {
            self.dismiss(animated: true)
        }
    }
    
    // Container View
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = pickerBackgroundColor
        
        let containerHeight: CGFloat = 300
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
    }

    // Toolbar
    private func configureToolbar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        containerView.addSubview(toolbar)

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
        selectedRow = pickerView.selectedRow(inComponent: 0)
        delegate?.didSelectRow(selectedRow)
        
        self.dismiss(animated: true)
    }

    // Picker View
    private func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if pickerItems.indices.contains(selectedRow) {
            pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        }
        
        containerView.addSubview(pickerView)
        pickerView.backgroundColor = .clear

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
        return pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
}
