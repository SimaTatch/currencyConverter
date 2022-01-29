
import UIKit

class ViewController: UIViewController, MainCurrencyViewDelegate {
    
    let mainCurrencyView = MainCurrencyView()
    var selectedCurrency: TableViewCellModel?
    
    private func setupViews() {
        view.addSubview(blueElipseImage)
        view.addSubview(currencyConverterLabel)
        view.addSubview(mainCurrencyView)
        view.addSubview(addCurrencyButton)
        view.addSubview(lastTimeUpdateLabel)
        view.addSubview(shareButton)
    }
    
    private func setupDelegates() {
        mainCurrencyView.delegate = self
        mainCurrencyView.tableView.backgroundColor = .white
        mainCurrencyView.tableView.separatorStyle = .none
        mainCurrencyView.tableView.layer.borderColor = UIColor.blue.cgColor
    }
    
    func dateDidChange(date: String) {
        DispatchQueue.main.async {
            let parsed = date.replacingOccurrences(of: "+0000", with: "")
            self.lastTimeUpdateLabel.text = "Last Updated\n\(parsed)"
        }
    }
    
    private let blueElipseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let currencyConverterLabel: UILabel = {
        let label = UILabel()
        label.text = "Currency Converter"
        label.font = UIFont(name: "Lato-Bold", size: 24)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle(" Add Currency", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 18)
        button.tintColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lastTimeUpdateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .specialGray
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "square.and.arrow.up"), for: .normal)
        button.addTarget(self, action: #selector(presentShareSheet), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupDelegates()
    }

    @objc func presentShareSheet() {
        let activityVC = UIActivityViewController(activityItems: ["Currency"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @objc func tapOnButton() {
        let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! ListTableViewController
        listTableViewController.delegate = mainCurrencyView
        listTableViewController.modalPresentationStyle = .pageSheet
        present(listTableViewController, animated: true, completion: nil)
    }
    

}



//MARK: - Constraints
extension ViewController {
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            blueElipseImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 90),
            blueElipseImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -90),
            blueElipseImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
//            currencyConverterLabel.heightAnchor.constraint(equalToConstant: 42),
            currencyConverterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
//            currencyConverterLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            currencyConverterLabel.bottomAnchor.constraint(equalTo: mainCurrencyView.topAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            mainCurrencyView.widthAnchor.constraint(equalToConstant: 350),
            mainCurrencyView.heightAnchor.constraint(equalToConstant: 330),
            mainCurrencyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainCurrencyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addCurrencyButton.bottomAnchor.constraint(equalTo: mainCurrencyView.bottomAnchor, constant: -20),
            addCurrencyButton.leadingAnchor.constraint(equalTo: mainCurrencyView.leadingAnchor, constant: 60),
            addCurrencyButton.trailingAnchor.constraint(equalTo: mainCurrencyView.trailingAnchor, constant: -60)
        ])
        NSLayoutConstraint.activate([
            shareButton.bottomAnchor.constraint(equalTo: mainCurrencyView.bottomAnchor, constant: -10),
            shareButton.trailingAnchor.constraint(equalTo: mainCurrencyView.trailingAnchor, constant: -5),
            shareButton.widthAnchor.constraint(equalToConstant: 30),
            shareButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
//            lastTimeUpdateLabel.widthAnchor.constraint(equalToConstant: 150),
//            lastTimeUpdateLabel.heightAnchor.constraint(equalToConstant: 100),
            lastTimeUpdateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
//            lastTimeUpdateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            lastTimeUpdateLabel.topAnchor.constraint(equalTo: mainCurrencyView.bottomAnchor, constant: 10)
//            lastTimeUpdateLabel.bo.constraint(equalTo: mainCurrencyView.bottomAnchor, constant: 20)
        ])
    }
}


