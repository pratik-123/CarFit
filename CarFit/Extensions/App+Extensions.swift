//
//  App+Extensions.swift
//  Calendar
//
//Test Project

import UIKit

//MARK:- Navigation bar clear
extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
}
//MARK:- CodingUser codable key
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
//MARK:- Filemanger
extension FileManager {
    /// file read from bundle
    /// - Parameter fileName: filename
    /// - Parameter type: extension type
    /// - Returns: data
    static func readFile(forResource fileName: String, type : String = "json") -> Data? {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: fileName, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        return nil
    }
}
//MARK:- Date
extension Date {
    /// Start date for month return
    /// - Returns: start date
    func startDateOfMonth() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))) else {
            return Date()
        }
        return date
    }
    /// End date of month return
    /// - Returns: end date
    func endDateOfMonth() -> Date {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth()) else {
            return Date()
        }
        return date
    }
    /// adding month to date
    /// - Parameter value: int value to increament or decrement
    /// - Returns: date
    func addingMonth(value: Int = 1) -> Date {
        guard let date = Calendar.current.date(byAdding: .month, value: value, to: self) else {
            return Date()
        }
        return date
    }
}
