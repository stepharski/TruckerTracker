//
//  CategoryItemVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/12/22.
//

import UIKit

// MARK: - SectionsRows Definition
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
        return self.rawValue.capitalized
    }
}

private struct Section {
    var type: SectionType
    var rows: [RowType]
}

// MARK: - CategoryItemVC
class CategoryItemVC: UIViewController {
    
    @IBOutlet var itemAmountTextField: UITextField!
    @IBOutlet var selectedCategoryImageView: UIImageView!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet var tableBackgoundView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var deleteButton: UIButton!
    
    private var sections = [Section]()
    var currentCategory: TrackerCategoryType = .gross {
        didSet {
            updateUI()
            updateSectionsRows()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavBar()
        configureTableView()
    }
    
    
    // @IBAction
    @IBAction func didTapCategoryButton(_ sender: UIButton) {
        guard let index = categoryButtons.firstIndex(of: sender) else { return }
        
        categoryButtons.forEach { $0.isSelected = $0 == sender }
        currentCategory = TrackerCategoryType.allCases[index]
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
        tableBackgoundView.roundEdges()
        tableBackgoundView.applyGradient(colors: [.black.withAlphaComponent(0.5), .clear], locations: [0, 1])
    }
    
    func updateUI() {
        UIView.animate(withDuration: 0.25) {
            self.selectedCategoryImageView.image = self.currentCategory.image
            self.selectedCategoryImageView.tintColor = self.currentCategory.imageTintColor
            self.view.backgroundColor = self.currentCategory == .gross
            || self.currentCategory == .miles ? #colorLiteral(red: 0.07058823529, green: 0.1921568627, blue: 0.1647058824, alpha: 1) : #colorLiteral(red: 0.3960784314, green: 0.09411764706, blue: 0.06274509804, alpha: 1)
        }
    }
    
    
    // TableView Configuration
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RouteCell.nib, forCellReuseIdentifier: RouteCell.identifier)
        tableView.register(TRItemCell.nib, forCellReuseIdentifier: TRItemCell.identifier)
        tableView.register(DocumentCell.nib, forCellReuseIdentifier: DocumentCell.identifier)
        tableView.register(AddDocRouteCell.nib, forCellReuseIdentifier: AddDocRouteCell.identifier)
        tableView.register(DocumentsHeaderView.self, forHeaderFooterViewReuseIdentifier: DocumentsHeaderView.identifier)
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
    func showDatePickerVC() {
        let datePickerVC = DatePickerVC()
        datePickerVC.modalPresentationStyle = .pageSheet
        datePickerVC.sheetPresentationController?.detents = [.medium()]
        datePickerVC.sheetPresentationController?.largestUndimmedDetentIdentifier = .large
        
        present(datePickerVC, animated: true)
    }
    
    func showPickerVC(for pickerItems: [String], at selectedRow: Int) {
            let pickerVC = TRPickerVC(pickerItems: pickerItems,
                                      selectedRow: selectedRow)
            pickerVC.modalPresentationStyle = .overCurrentContext
            pickerVC.modalTransitionStyle = .coverVertical
        
            present(pickerVC, animated: true)
    }
    
    func showLocationSearchVC() {
        let locationSearchVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardIdentifiers.locationSearchVC) as! LocationSearchVC
        
        navigationController?.pushViewController(locationSearchVC, animated: true)
    }
}


// MARK: - UITableViewDataSource
extension CategoryItemVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].rows[indexPath.row]
        switch item {

        case .gross, .miles,
                .name, .date, .frequency,
                .location, .store, .type, .price, .quantity:
            let cell = tableView.dequeueReusableCell(withIdentifier: TRItemCell.identifier) as! TRItemCell
            cell.itemName = item.title
            return cell

        case .routeFrom, .routeTo:
            let cell = tableView.dequeueReusableCell(withIdentifier: RouteCell.identifier) as! RouteCell
            cell.direction = item == .routeFrom ? .from : .to

            cell.dateTextFieldPressed = {
                self.showDatePickerVC()
            }

            cell.locationTextFieldPressed = {
                self.showLocationSearchVC()
            }

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
}

// MARK: - UITableViewDelegate
extension CategoryItemVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section].type {
        case .documents:
            let headerView = DocumentsHeaderView(frame: CGRect(x: 0, y: 0,
                                                               width: tableView.frame.width, height: 35))
            headerView.title = "Documents"

            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section].type {
        case .route:
            return 10
        case .documents:
            return 20
        default:
            return CGFloat.leastNonzeroMagnitude
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
        let selectedRow = sections[indexPath.section].rows[indexPath.row]
        
        switch selectedRow {
        case .miles, .gross,
                .name, .store,
                .price, .quantity:
            //TODO: Show TextField + Keyboard
            print(selectedRow)
            return
            
        case .date:
            showDatePickerVC()
            
        case .frequency, .type:
            print(selectedRow)
            showPickerVC(for: [], at: 0)
            
        case .location:
            showLocationSearchVC()
            
        case .document:
            // TODO: Show DocumentDetailVC
            print(selectedRow)
            return
            
        case .addDocument, .addToRoute:
            // TODO: Show AddToVC
            print(selectedRow)
            return
            
        case .routeFrom, .routeTo:
            print(selectedRow)
            return
        }
    }
}
