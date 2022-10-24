//
//  CategoryItemVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/12/22.
//

import UIKit

private enum SectionType {
    case gross
    case miles
    case route
    case fuel
    case expenses
    case documents
}

private enum RowType: String {
    case gross, miles
    case routeFrom, routeTo, addToRoute
    case document, addDocument
    case name, date, frequency
    case location, store, type, price, quantity
    
    var title: String {
        return self.rawValue
    }
}

private struct Section {
    var type: SectionType
    var rows: [RowType]
}


class CategoryItemVC: UIViewController {
    
    @IBOutlet weak var itemAmountTextField: UITextField!
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var tableBackgoundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var sections = [Section]()
    var currentCategory: TrackerCategoryType = .gross {
        didSet {
            updateUI()
            updateSectionsRows()
        }
    }
    
    
    @IBAction func didTapCategoryButton(_ sender: UIButton) {
        guard let index = categoryButtons.firstIndex(of: sender) else { return }
        
        categoryButtons.forEach { $0.isSelected = $0 == sender }
        currentCategory = TrackerCategoryType.allCases[index]
    }
    
    // VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavBar()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        applyGradients()
    }

    // UI Configuration
    func configureNavBar() {
        navigationItem.title = "New Item"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbols.xmark,
            style: .plain,
            target: self,
            action: #selector(dismissVC))
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
    
    
    func configureUI() {
        deleteButton.isHidden = true
        tableBackgoundView.layer.cornerRadius = 30
    }
    
    func updateUI() {
        UIView.animate(withDuration: 0.25) {
            self.selectedCategoryImageView.image = self.currentCategory.image
            self.selectedCategoryImageView.tintColor = self.currentCategory.imageTintColor
            
            self.view.backgroundColor = self.currentCategory == .gross
                                  || self.currentCategory == .miles ? #colorLiteral(red: 0.03529411765, green: 0.09019607843, blue: 0.06666666667, alpha: 1) : #colorLiteral(red: 0.1176470588, green: 0.03137254902, blue: 0.02352941176, alpha: 1)
        }
    }
    
    func applyGradients() {
        if let gradientLayer = (tableBackgoundView.layer.sublayers?.compactMap{ $0 as? CAGradientLayer })?.first {
            gradientLayer.removeFromSuperlayer()
        }
        
        let startGradientColor = self.currentCategory == .gross
                              || self.currentCategory == .miles ? #colorLiteral(red: 0.137254902, green: 0.1921568627, blue: 0.1764705882, alpha: 1) : #colorLiteral(red: 0.2431372549, green: 0.08235294118, blue: 0.06666666667, alpha: 1)
        self.tableBackgoundView.applyGradient(colors: [startGradientColor, .black], locations: [0, 1])
    }
    
    // TableView Configuration
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.sectionHeaderTopPadding = 0
        tableView.estimatedSectionHeaderHeight = 0.0
        
        tableView.register(ItemDetailCell.nib, forCellReuseIdentifier: ItemDetailCell.identifier)
        tableView.register(ItemPickerCell.nib, forCellReuseIdentifier: ItemPickerCell.identifier)
        tableView.register(RouteCell.nib, forCellReuseIdentifier: RouteCell.identifier)
        tableView.register(DocumentCell.nib, forCellReuseIdentifier: DocumentCell.identifier)
        tableView.register(AddDocRouteCell.nib, forCellReuseIdentifier: AddDocRouteCell.identifier)
        updateSectionsRows()
    }
    
    func updateSectionsRows() {
        sections.removeAll()
        
        switch currentCategory {
        case .gross:
            sections = [
                Section(type: .gross, rows: [.miles]),
                Section(type: .route, rows: [.routeFrom, .routeTo, .addToRoute])
            ]
        case .miles:
            sections = [
                Section(type: .miles, rows: [.gross]),
                Section(type: .route, rows: [.routeFrom, .routeTo, .addToRoute])
            ]
        case .expenses:
            sections = [
                Section(type: .expenses, rows: [.name, .date, .frequency]),
            ]
        case .fuel:
            sections = [
                Section(type: .fuel, rows: [.location, .store, .type,
                                             .price, .quantity, .date])
            ]
        }
        
        sections.append(Section(type: .documents, rows: [.document, .addDocument]))
        tableView.reloadData()
    }
    
    // Navigation
    func showPickerVC(for pickerType: PickerType) {
        let pickerVC = TRPickerVC(picker: pickerType)
        pickerVC.modalPresentationStyle = .overCurrentContext
        pickerVC.modalTransitionStyle = .coverVertical

        navigationController?.present(pickerVC, animated: true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoryItemVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section].type {
        case .documents:
            return DocumentsHeaderView(frame: CGRect(x: 0, y: 0,
                                                     width: tableView.frame.width, height: 30))
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section].type {
        case .route:
            return 10
        case .documents:
            return 35
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].rows[indexPath.row]
        switch item {
            
        case .gross, .miles, .name, .location, .store, .price, .quantity:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailCell.identifier) as! ItemDetailCell
            cell.itemName = item.title.capitalized
            return cell
            
        case .date, .frequency, .type:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemPickerCell.identifier) as! ItemPickerCell
            cell.pickerName = item.title.capitalized
            
            var pickerValue = ""
            var pickerType = PickerType.date
            if item == .date {
                pickerValue = "\(Date.now.formatted(.dateTime.day().month()))"
            } else if item == .frequency {
                pickerType = .frequency
                pickerValue = "\(pickerType.itemTypes.first?.rawValue.capitalized ?? "Select Frequency")"
            } else if item == .type {
                pickerType = .fuel
                pickerValue = "\(pickerType.itemTypes.first?.rawValue.capitalized ?? "Select Fuel Type")"
            }
            
            cell.pickerValue = pickerValue
            cell.pickerTextFieldPressed = {
                self.showPickerVC(for: pickerType)
            }
            
            return cell
            
        case .routeFrom, .routeTo:
            let cell = tableView.dequeueReusableCell(withIdentifier: RouteCell.identifier) as! RouteCell
            cell.direction = item == .routeFrom ? .from : .to
            
            return cell
            
        case .addToRoute, .addDocument:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddDocRouteCell.identifier) as! AddDocRouteCell
            cell.cellType = item == .addToRoute ? .route : .document
            
            cell.addButtonPressed = { }
            
            return cell
            
        case .document:
            let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.identifier) as! DocumentCell
            cell.docName = "Document2022.pdf"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].rows[indexPath.row]
        switch item {
        case .routeFrom, .routeTo:
            return 60
        case .document:
            return 40
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
