//
//  BaseLabel.swift
//  weather
//
//  Created by 이재문 on 2022/11/19.
//

import UIKit

class BaseLabel: UILabel {
    
    func setupView(font: UIFont = UIFont.systemFont(ofSize: 16), color: UIColor = .black) {
        self.font = font
        self.textColor = color
        self.textAlignment = .left
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
