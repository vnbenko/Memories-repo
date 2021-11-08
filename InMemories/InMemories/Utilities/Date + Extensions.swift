import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let value: Int
        let unit: String
        if secondsAgo < minute {
            value = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            value = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            value = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            value = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            value = secondsAgo / week
            unit = "week"
        } else {
            value = secondsAgo / month
            unit = "month"
        }
        
        return "\(value) \(unit)\(value == 1 ? "" : "s") ago"
        
    }
}
