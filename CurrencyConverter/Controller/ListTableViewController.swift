

import UIKit

protocol ListTableViewControllerDelegate: AnyObject {
    func appendSelectedCell(cell: TableViewCellModel)
}

class ListTableViewController: UIViewController {
    
    @IBOutlet weak var tableOfAllCurrencies: UITableView!
    
    weak var delegate: ListTableViewControllerDelegate?
    
    
    var currencyKey:[String] = []
    var currencyKeyAndValue:[CurrencyModel] = []
    var sections = [Section]()
    var filteredArray = [Section]()
    private let idCell = "cellList"
    private let idHeader = "cellListHeader"
    let apiMan: ApiManagerProtocol = APIManager()
    
    //      MARK: - CreateSearchController
    private let mySearchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = mySearchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return mySearchController.isActive && !searchBarIsEmpty
    }
    
    
    //    MARK: - NavigationBar
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Currency")
        let back = UIBarButtonItem(title: "< Converter", style: .plain, target: nil ,action: #selector(backToVC))
        back.setBackButtonBackgroundImage(UIImage(named: "chevron.left"), for: UIControl.State.normal, barMetrics: UIBarMetrics(rawValue: 0)!)
        back.tintColor = .specialBlue
        back.setTitleTextAttributes([
            .foregroundColor: UIColor.specialBlue,
            .font: UIFont(name: "Lato-Regular", size: 18) as Any ],
                                    for: UIControl.State.normal)
        navItem.leftBarButtonItem = back
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    @objc func backToVC() {
        dismiss(animated: true, completion: nil)
    }
    
//    MARK: - TableViewSetup
    func setupTableViewProperties() {
     self.tableOfAllCurrencies.layer.masksToBounds = false
     self.tableOfAllCurrencies.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
     self.tableOfAllCurrencies.layer.shadowOpacity = 1
     self.tableOfAllCurrencies.layer.shadowRadius = 4
     self.tableOfAllCurrencies.layer.shadowOffset = CGSize(width: 0, height: 4)
        
     self.tableOfAllCurrencies.backgroundColor = UIColor.clear
     self.tableOfAllCurrencies.separatorStyle = .none
     self.tableOfAllCurrencies.separatorColor = .clear
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        setupTableViewProperties()
        
        //        MARK: - SearchController
        mySearchController.searchResultsUpdater = self
        mySearchController.hidesNavigationBarDuringPresentation = false
        mySearchController.searchBar.placeholder = "Search Currency"
        mySearchController.searchBar.sizeToFit()
        self.tableOfAllCurrencies.tableHeaderView = mySearchController.searchBar
        
        //        MARK: - TableView
        self.view.backgroundColor = #colorLiteral(red: 0.9594197869, green: 0.9599153399, blue: 0.975127399, alpha: 1)
        self.tableOfAllCurrencies.register(ListTableViewCell.self, forCellReuseIdentifier: idCell)
        self.tableOfAllCurrencies.delegate = self
        self.tableOfAllCurrencies.dataSource = self
        
        //        MARK: - FetchJSON
        DispatchQueue.main.async {
            self.apiMan.fetchJson(key: "USD") { results in
                self.currencyKey.append(contentsOf: results.rates.keys)
                self.currencyKeyAndValue = results.rates.map { key, value in
                    CurrencyModel.init(key: key, rate: value )
                }
                
                let groupedCurrencyKey = Dictionary(grouping: self.currencyKey, by: {String($0.prefix(1))})
                let keys = groupedCurrencyKey.keys.sorted()
                self.sections = keys.map{ Section(letter: $0, currencyName: groupedCurrencyKey[$0]!.sorted()) }
                DispatchQueue.main.async {
                    self.tableOfAllCurrencies.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableOfAllCurrencies.reloadData()
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension ListTableViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return filteredArray.count
        }
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredArray[section].currencyName.count
        }
        return sections[section].currencyName.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as? ListTableViewCell {
            
            var section: Section

            if isFiltering {
                section = filteredArray[indexPath.section]
            } else {
                section = sections[indexPath.section]
            }

            let username = section.currencyName[indexPath.row]
            cell.nameCellLabel.text = username
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering {
            return filteredArray.map{$0.letter}
        }
        return sections.map{$0.letter}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return filteredArray[section].letter
        }
        return sections[section].letter
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var section: Section
        
        if isFiltering {
            section = filteredArray[indexPath.section]
        } else {
            section = sections[indexPath.section]
        }
        let selectedCur = self.currencyKeyAndValue.first(where: { $0.key == section.currencyName[indexPath.row]})!
        let selectedCurModel = TableViewCellModel(delegate: nil, currency: selectedCur)
        self.delegate?.appendSelectedCell(cell: selectedCurModel)
        self.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}

//MARK: - UISearchResultsUpdating
extension ListTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredArray = sections.compactMap({ section in
            let items = section.currencyName.filter({ currencyName in currencyName.lowercased().contains(searchText.lowercased())
            })
            guard !items.isEmpty else {return nil}
            return Section(letter: section.letter, currencyName: items)
        })
//            .filter({ (section: Section) -> Bool in
//            let sections = section.currencyName.filter({ currencyName in
//                currencyName.lowercased().contains(searchText.lowercased())
//        })
//            return !sections.isEmpty
//        })
        tableOfAllCurrencies.reloadData()
    }

}
