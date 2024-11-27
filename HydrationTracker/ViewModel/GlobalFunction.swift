import UIKit

class GlobalFunction {
    func timeAgoSinceDate(from fromDate: Date) -> String {
        
        // To Time
        let toDate = Date()
        
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0 {
            return interval == 1 ? "\(interval) year ago" : "\(interval) years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0 {
            return interval == 1 ? "\(interval) month ago" : "\(interval) months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0 {
            return interval == 1 ? "\(interval) day ago" : "\(interval) days ago"
        }
        
        // Hour
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return interval == 1 ? "\(interval) hour ago" : "\(interval) hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return interval == 1 ? "\(interval) minute ago" : "\(interval) minutes ago"
        }
        
        return "a moment ago"
    }
    
    
    static func styleViewWithBorderAndShadow(view: UIView, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat) {
        view.layer.cornerRadius = radius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowRadius
        view.layer.masksToBounds = false  // Allows the shadow to extend outside the view's bounds
    }
    
}
