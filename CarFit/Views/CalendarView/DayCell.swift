//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    private lazy var formatter : DateFormatter = {
        return DateFormaterEnum.formate(type: .onlyDate)
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }
    ///Cell data setup
    func cellDataSetup(object : CalendarPO?, selectedDate : Date) {
        day.text = object?.day
        weekday.text = object?.weekday
        daySelection(object: object, selectedDate: selectedDate)
    }
    ///selected date backgroun view change
    func daySelection(object : CalendarPO?, selectedDate : Date) {
        if let objectDate = object?.date, formatter.string(from: objectDate) == formatter.string(from: selectedDate) {
            self.dayView.backgroundColor = UIColor.daySelected
        } else {
            self.dayView.backgroundColor = .clear
        }
    }
}
