

import Foundation
import UIKit

class MainCurrencyView: UIView, TableViewCellDelegate, ListTableViewControllerDelegate {
    
    var listTableVC = ListTableViewController()
    var currencies: [CurrencyModel] = []
    var selectedCurrencies: [TableViewCellModel] = []
    
    private let idCalendarCell = "cell"
    let apiMan: ApiManagerProtocol = APIManager()

    weak var delegate: MainCurrencyViewDelegate? //ViewController

    func appendSelectedCell(cell: TableViewCellModel) {
        DispatchQueue.main.async {
            self.selectedCurrencies.append(cell)
            self.tableView.reloadData()
        }
    }
    
    private let buyOrCellSegmentControl: UISegmentedControl = {
        let buyOrSellItems = ["Buy","Sell"]
        let segmentControl = UISegmentedControl(items: buyOrSellItems)
        segmentControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .specialBlue
        segmentControl.frame = CGRect(x: 0, y: 0, width: 350, height: 50)
        return segmentControl
    }()
    
    @objc func indexChanged(_ segmentControl: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        default:
            break
            
        }
    }
    
     let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 4.0
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(buyOrCellSegmentControl)
        addSubview(tableView)
    }
    private func setDelegates() {
        tableView.dataSource = self
        tableView.layer.borderColor = UIColor.red.cgColor
        listTableVC.delegate = self // MainCurrencyView
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: idCalendarCell)
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        setupViews()
        setDelegates()
        setConstraints()
        
//        MARK: - HideKeyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        addGestureRecognizer(tap)
        
        apiMan.fetchJson (key: "USD"){ result in

            self.currencies = result.rates.map { key, value in
                CurrencyModel.init(key: key, rate: value )
            }
            
            let usd = self.currencies.first(where: { $0.key == "USD"})!
            let usdModel = TableViewCellModel(delegate: nil, currency: usd)
            
            let eur = self.currencies.first(where: { $0.key == "EUR"})!
            let eurModel = TableViewCellModel(delegate: nil, currency: eur)
            
            let rub = self.currencies.first(where: { $0.key == "RUB"})!
            let rubModel = TableViewCellModel(delegate: nil, currency: rub)
            
            self.selectedCurrencies = [usdModel, eurModel, rubModel]
            DispatchQueue.main.async {
                self.tableView.reloadData()

                self.delegate?.dateDidChange(date: result.time_last_update_utc)
            }
        }
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        endEditing(true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MainCurrencyView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? TableViewCell else {return UITableViewCell()}
        
        let model = selectedCurrencies[indexPath.row]
        let item = model.currency
        
        cell.currencyLabel.text = item.key
        cell.currencyLabel.font = UIFont(name: "Lato-Regular", size: 16)
        cell.currencyLabel.textColor = .specialDarkBlue
        cell.currencyTextField.accessibilityIdentifier = item.key
        cell.currencyTextField.text = String(item.rate)
        cell.currencyTextField.backgroundColor = #colorLiteral(red: 0.9847063422, green: 0.9758779407, blue: 0.9938308597, alpha: 1)
        cell.currencyTextField.textColor = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1)
        model.delegate = cell
        cell.delegate = self
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            selectedCurrencies.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    
    func didChangeValue(value: Double, cell: TableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let currentCurrency = selectedCurrencies[indexPath.row]
        let base = currentCurrency.convertToBase(amount: value)
        selectedCurrencies.filter({$0.currency.key != currentCurrency.currency.key})
            .forEach { model in
            model.convertFromBase(amount: base)
        }
    }
}

extension MainCurrencyView {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -90),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            buyOrCellSegmentControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
