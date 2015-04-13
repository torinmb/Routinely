//
//  TableViewCell.swift
//  Routinely
//
//  Created by Torin Blankensmith on 4/7/15.
//  Copyright (c) 2015 Torin Blankensmith. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let gradientLayer = CAGradientLayer()
    @IBOutlet weak var label: UITextField!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let tapGesutre = UIGestureRecognizer(target: self, action: "textTapGestureRecognized:")
        label?.addGestureRecognizer(tapGesutre)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        // gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).CGColor as CGColorRef
        let color2 = UIColor(white: 1.0, alpha: 0.1).CGColor as CGColorRef
        let color3 = UIColor.clearColor().CGColor as CGColorRef
        let color4 = UIColor(white: 0.0, alpha: 0.1).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, atIndex: 0)
        
//        label.delegate = self
//        label.contentVerticalAlignment = .Center
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        // close the keyboard on Enter
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldBeginEditing(textField: UITextField!) -> Bool {
        // disable editing of completed to-do items
        if label != nil {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        if label != nil {
            label?.text = textField.text
        }
    }
    

//    func textFieldDidBeginEditing(textField: UITextField!) {
//        if delegate != nil {
//            delegate!.cellDidBeginEditing(self)
//        }
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

}
