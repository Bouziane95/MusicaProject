//
//  RoundTextView.swift
//  Musica
//
//  Created by Bouziane Bey on 11/03/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import UIKit
@IBDesignable

class RoundTextView: UITextView {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
           didSet{
               self.layer.cornerRadius = cornerRadius
           }
       }
       
       @IBInspectable var borderWidth: CGFloat = 0{
           didSet{
               self.layer.borderWidth = borderWidth
           }
       }
       
       @IBInspectable var borderColor: UIColor = UIColor.clear{
              didSet{
               self.layer.borderColor = borderColor.cgColor
              }
          }
    

}
