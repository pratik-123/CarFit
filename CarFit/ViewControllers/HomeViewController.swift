//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBOutlet weak var workOrderTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    private var refreshControl = UIRefreshControl()
    
    private var isCalendarOpen: Bool = false
    private let calendarViewHeight: CGFloat = 200
    private let workOrderTableViewTopSpace: CGFloat = 112
    private let cellID = "HomeTableViewCell"
    
    lazy var viewModel : CleanerListViewModel = {
        let viewModel = CleanerListViewModel()
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
    }

    /// page settings
    private func pageSetup() {
        setupUI()
        closureSetup()
        viewModel.fetchVisit()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarTappedOutside))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func closureSetup() {
        // add error handling
        self.viewModel.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                switch error {
                case .custom(let message):
                    self?.displayAlert(with: "An error occured", message: message)
                    break
                default:
                    self?.displayAlert(with: "An error occured", message: error?.localizedDescription ?? "error")
                    break
                }
            }
            //fetch allready added data from local db
            self?.viewModel.fetchTasks()
        }
        //refresh screen
        self.viewModel.onRefreshHandling = { [weak self] refreshType in
            switch refreshType {
            case .Visit:
                self?.viewModel.fetchTasks()
                break
            case .Task:
                self?.workOrderReload()
            case .none:
                break
            }
        }
    }
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            if let selectedDate = viewModel.selectedDate {
                calendar.selectedDate = selectedDate
            }
            calendar.delegate = self
        }
        //for first time bool true set so not perform animation
        openCloseCalendarView(isFirstTime: true)
    }

    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
        refreshControllerSetup()
    }
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        isCalendarOpen = !isCalendarOpen
        openCloseCalendarView()
    }
    
}
//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// tableview refresh controller setttings
    private func refreshControllerSetup() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        workOrderTableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    /// pull to refresh action
    @IBAction func pullToRefresh() {
        refreshControl.beginRefreshing()
        viewModel.fetchVisit()
    }

    /// Work order data reload
    private func workOrderReload() {
        let dateFormatter = DateFormaterEnum.formate(type: .onlyDate)
        DispatchQueue.main.async {
            self.workOrderTableView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            //title set
            self.navBar.topItem?.title = dateFormatter.string(from: self.viewModel.selectedDate ?? Date())
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
        cell.previousTask = viewModel.getPreviousTask(at: indexPath.row)
        cell.cellDataSetup(object: viewModel.getTask(at: indexPath.row))
        return cell
    }
}
//MARK: CalendarView settings
extension HomeViewController: UIGestureRecognizerDelegate {
    /// Constraint change based on open close calendar view
    private func openCloseCalendarView(isFirstTime : Bool = false) {
        self.calendarViewHeightConstraint.constant = self.isCalendarOpen ?  self.calendarViewHeight : 0
        self.workOrderTableViewTopConstraint.constant = self.isCalendarOpen ? self.workOrderTableViewTopSpace : 0
        UIView.animate(withDuration: isFirstTime ? 0 : 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    /// Calendar out side click to hide view
    @IBAction func calendarTappedOutside() {
        if isCalendarOpen == true {
            isCalendarOpen = !isCalendarOpen
            openCloseCalendarView()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //prevent calendar view click to hide
        if touch.view?.isDescendant(of: self.calendarView) == true {
            return false
        }
        return true
    }
}
//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    func getSelectedDate(_ dateObject: CalendarPO) {
        viewModel.setSelectedDate(date: dateObject.date)
    }
}
