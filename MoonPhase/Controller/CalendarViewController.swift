//
//  CalendarViewController.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2022 Dylan Park. All rights reserved.

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var calendarStackView: UIStackView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var userSelectedDate: Date?
    let dateFormatter = DateFormatter()
    let colourModel = ColourModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        doneButton.layer.masksToBounds = true
        doneButton.addBorders(edges: .left, color: UIColor(named: "Light Grey")!, thickness: 0.5)
        
        buttonStackView.layer.masksToBounds = true
        buttonStackView.addBorders(edges: .top, color: UIColor(named: "Light Grey")!, thickness: 0.5)
        
        calendarStackView.layer.cornerRadius = 10
        calendarStackView.layer.masksToBounds = true
        calendarStackView.layer.borderWidth = 1
        calendarStackView.clipsToBounds = true
        calendarStackView.layer.borderColor = colourModel.lightGrey
    }
    
    deinit {
      print("OS Reclaiming Memory - No Retain Cycle/Leak")
    }
    
    @IBAction func selectedDate(_ sender: Any) {
        self.userSelectedDate = self.datePicker.date
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dateFormatter.dateFormat = "EEE, d MMM"
        
        if segue.identifier == "donePressed" {
            let destinationController = segue.destination as! ViewController
            destinationController.userSelectedDate = userSelectedDate ?? Date()
        }
    }
    
}

//MARK: - UIView Borders

extension UIView {
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }

}
