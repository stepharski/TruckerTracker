//
//  PeriodPickerCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/20/23.
//

import UIKit

// MARK: - PeriodPickerCellDelegate
protocol PeriodPickerCellDelegate: AnyObject {
    func pickerDidSelect(row: Int, component: Int)
}

// MARK: - PeriodPickerCell
class PeriodPickerCell: UITableViewCell {

    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var pickerPlaceholderView: UIView!
    
    weak var delegate: PeriodPickerCellDelegate?
    
    var pickerData = [[String]]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    var selectedRows = [Int]() {
        didSet {
            selectPickerRows()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        
        selectionStyle = .none
        backgroundColor = .clear
        pickerPlaceholderView.roundEdges(by: 10)
    }
    
    
    func selectPickerRows() {
        guard !selectedRows.isEmpty else { return }
        pickerData.indices.forEach { pickerView.selectRow(selectedRows[$0], inComponent: $0, animated: true) }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension PeriodPickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        label.text = pickerData[component][row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.pickerDidSelect(row: row, component: component)
    }
}
