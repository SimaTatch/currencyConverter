

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
//        ??
        textField.layer.borderColor = UIColor.red.cgColor
    }
}


extension TableViewCell: CurrencyModelDelegate {
    func valueChanged(value: Double) {
        guard value > 0 else {return}
        currencyTextField.text = String(format: "%.2f", value)
    }
}
