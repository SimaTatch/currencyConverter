//
//  ListTableViewCell.swift
//  CurrencyConverter
//
//  Created by Серафима  Татченкова  on 13.01.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    
    
    let backgroundViewCell: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameCellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var maskedCorners: CellRound? {
        didSet {
            applyMask()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func applyMask() {
        guard let corners = self.maskedCorners?.corners else {
            self.backgroundViewCell.layer.cornerRadius = 0
            return
            
        }
        self.backgroundViewCell.layer.cornerRadius = 10
        self.backgroundViewCell.layer.maskedCorners = corners
    }
    
    func setConstraints() {
        
        self.addSubview(backgroundViewCell)
        NSLayoutConstraint.activate([
            backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        self.addSubview(nameCellLabel)
        NSLayoutConstraint.activate([
            nameCellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameCellLabel.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor, constant: 15)
        ])
    }
    
    override func prepareForReuse() {
        maskedCorners = nil
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyMask()
    }
}
