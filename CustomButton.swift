//
//  CustomButton.swift
//  taskapp
//
//  Created by Liu Peiwen on 2021/04/18.
//

import Foundation
import UIKit

//extension UIButton {
//
//    class func mainButton(frame: CGRect) -> UIButton {
//
//        let button = UIButton(frame: frame)
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 10
//        button.layer.borderColor = UIColor.orange.cgColor
//        button.layer.borderWidth = 2.0
//
//        return button
//    }
//}

@IBDesignable
class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customDesign()
    }
    
    override func prepareForInterfaceBuilder() {
      super.prepareForInterfaceBuilder()
      customDesign()
    }
    
    private func customDesign() {
        backgroundColor = UIColor.customSeaGreen
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layer.cornerRadius = 20.0
    }
}
