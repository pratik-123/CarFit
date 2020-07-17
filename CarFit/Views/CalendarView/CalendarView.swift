//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDate(_ dateObject: CalendarPO)
}

class CalendarView: UIView {

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate? {
        didSet {
            //first time move to selected date
            moveToSelectedDate()
        }
    }
    
    /// selected date store default current date set
    var selectedDate = Date() {
        didSet {
            //default selected date set
            selectedMonthDate = selectedDate
        }
    }
    /// selected month set for calculations of next previous month
    var selectedMonthDate = Date() {
        didSet {
            // change month refill data and update view
            fillCalendarData()
        }
    }
    
    /// array of date for month
    private var calendarArray = [CalendarPO]() {
        didSet {
            daysCollectionView.reloadData()
        }
    }
    
    
    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
    }
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
        if sender == leftBtn {
            let changeDate = selectedMonthDate.addingMonth(value: -1)
            selectedMonthDate = changeDate
        } else if sender == rightBtn {
            let changeDate = selectedMonthDate.addingMonth()
            selectedMonthDate = changeDate
        }
        moveToSelectedDate()
    }
    
    /// Fill calendar array based on selected month
    private func fillCalendarData() {
        let startDate = selectedMonthDate.startDateOfMonth()
        let endDate = selectedMonthDate.endDateOfMonth()
        CalendarView.getArrayOfDate(fromDate: startDate, toDate: endDate) { (arrayOfCalendar) in
            calendarArray = arrayOfCalendar
        }
        let dateFormatter = DateFormaterEnum.formate(type: .onlyMonthYear)
        monthAndYear.text = dateFormatter.string(from: selectedMonthDate)
    }
    
    /// Selected date scroll to center position
    private func moveToSelectedDate() {
        var dateFormatter = DateFormaterEnum.formate(type: .onlyMonthYear)
        if dateFormatter.string(from: selectedDate) == dateFormatter.string(from: selectedMonthDate) {
            dateFormatter = DateFormaterEnum.formate(type:. onlyDay)
            let selectedDateString = dateFormatter.string(from: selectedDate)
            if let index = calendarArray.firstIndex(where: {$0.day == selectedDateString}) {
                daysCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
            }
        } else {
            daysCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        }
    }
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell
        if calendarArray.indices.contains(indexPath.row) {
            let object = calendarArray[indexPath.row]
            cell.cellDataSetup(object: object, selectedDate: selectedDate)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            if calendarArray.indices.contains(indexPath.row) {
                let object = calendarArray[indexPath.row]
                selectedDate = object.date
                cell.daySelection(object: object, selectedDate: selectedDate)
                delegate?.getSelectedDate(object)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            cell.dayView.backgroundColor = .clear
        }
    }
    
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}

extension CalendarView {
    
    /// Generate array of date from two dates
    /// - Parameters:
    ///   - fromDate: from date
    ///   - toDate: to date
    ///   - completion: array of date between two dates
    static func getArrayOfDate(fromDate: Date, toDate: Date, completion: ((_ arrayOfCalendar:[CalendarPO]) -> Void)) {
        let formatterDay = DateFormaterEnum.formate(type: .onlyDay)
        let formatterWeekDay = DateFormaterEnum.formate(type: .onlyWeekDay)
        
        var arrayOfDate = [CalendarPO]()
        let calendar = Calendar.current
        
        
        // first date add in array
        let firstDate = CalendarPO(day: formatterDay.string(from: fromDate), weekday: formatterWeekDay.string(from: fromDate), date: fromDate)
        arrayOfDate.append(firstDate)
        
        var date = fromDate
        //loop excute till to date 
        while date < toDate {
            guard let newDate = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
            
            let object = CalendarPO(day: formatterDay.string(from: date), weekday: formatterWeekDay.string(from: date), date: date)
            arrayOfDate.append(object)
        }
        completion(arrayOfDate)
    }
}
