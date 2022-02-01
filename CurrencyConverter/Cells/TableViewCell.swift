

import UIKit



class TableViewCell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyTextField: UITextField!
    weak var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currencyTextField.addTarget(self, action: #selector(textFieldDidChangeValue), for: .editingChanged)
        self.currencyTextField.delegate = self
        currencyTextField.accessibilityIdentifier = currencyLabel.text
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    
    @objc func textFieldDidChangeValue(_ textField: UITextField) {
        guard let text = textField.text,
              let value = Double(text) else {return}
        delegate?.didChangeValue(value: value, cell: self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 6
        textField.layer.borderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
        textField.textColor = UIColor(red: 0, green: 0.191, blue: 0.4, alpha: 1)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.textColor = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1)
        return true
    }
    

}



extension TableViewCell: CurrencyModelDelegate {
    func valueChanged(value: Double) {
        guard value > 0 else {return}
        currencyTextField.text = String(format: "%.2f", value)
    }
}
