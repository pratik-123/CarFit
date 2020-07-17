//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    //use for calculate location distance
    var previousTask: TaskPO?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    /// Cell data setup
    /// - Parameter object: TaskPO object
    func cellDataSetup(object : TaskPO?) {
        customer.text = object?.customer
        tasks.text = object?.taskTitle
        arrivalTime.text = object?.arrivalTime
        destination.text = object?.destination
        timeRequired.text = (object?.taskTimesInMinutes ?? 0).description + " min"
        status.text = object?.visitState
        statusView.backgroundColor = HomeTableViewCell.getStateColor(state: object?.visitState)
        
        let distanceString = HomeTableViewCell.calculateDistance(prevLat: previousTask?.houseOwnerLatitude, prevLong: previousTask?.houseOwnerLongitude, nextLat: object?.houseOwnerLatitude, nextLong: object?.houseOwnerLongitude)
        distance.text = distanceString
    }
}
extension HomeTableViewCell {
    /// enum use for server state store
    private enum VisitStateEnum {
        case ToDo, InProgress, Done, Rejected
        var serverKey : String {
            switch self {
            case .ToDo:
                return "ToDo"
            case .Done:
                return "Done"
            case .InProgress:
                return "InProgress"
            case .Rejected:
                return "Rejected"
            }
        }
    }
    
    /// get color based on state
    /// - Parameter state: state
    /// - Returns: UIColor
    static private func getStateColor(state : String?) -> UIColor {
        switch state {
        case VisitStateEnum.ToDo.serverKey:
            return UIColor.todoOption
        case VisitStateEnum.Done.serverKey:
            return UIColor.doneOption
        case VisitStateEnum.Rejected.serverKey:
            return UIColor.rejectedOption
        case VisitStateEnum.InProgress.serverKey:
            return UIColor.inProgressOption
        default:
            return UIColor.todoOption
        }
    }
    
    /// Calculate location between source and destination
    /// - Returns: distance string in km
    static private func calculateDistance(prevLat: NSNumber?, prevLong: NSNumber?, nextLat: NSNumber?, nextLong: NSNumber?) -> String {
        //calculate distance in km
        if let loc1Lat = prevLat?.doubleValue, let loc1Long = prevLong?.doubleValue, let loc2Lat = nextLat?.doubleValue, let loc2Long = nextLong?.doubleValue {
            let sourceLocation = CLLocation(latitude: loc1Lat, longitude: loc1Long)
            let destinationLocation = CLLocation(latitude: loc2Lat, longitude: loc2Long)
            //Measuring  distance (in km)
            let distance = sourceLocation.distance(from: destinationLocation) / 1000
            //Display the result in km
            let distanceString = String(format: "%.01f km", distance)
            return distanceString
        }
        return "0 km"
    }
}
