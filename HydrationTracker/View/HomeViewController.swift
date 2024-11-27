import UIKit
import CoreData
import WaterDrops

class HomeViewController: UIViewController {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    //UIViews for Showing Percentage
    @IBOutlet weak var view100: UIView!
    @IBOutlet weak var view80: UIView!
    @IBOutlet weak var view60: UIView!
    @IBOutlet weak var view40: UIView!
    @IBOutlet weak var view20: UIView!
    
    @IBOutlet weak var mainJarImage: UIImageView!
    
    var currPercentage : Float = 0.0
    
    var logs: [WaterLogUnit] = []
    let dailyGoal: Double = 2000.0 // ml
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "LogCell")
        
        fetchLogs()
        self.view20.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.view100.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addWaterDrops()
    }
    
    
    
    
    
    func addWaterDrops() {
        
        let waveFrame = self.view20.bounds
        
        let waterDropsView = WaterDropsView(frame: waveFrame,
                                            direction: .up,
                                            dropNum: 150,
                                            color: UIColor.white.withAlphaComponent(0.7),
                                            minDropSize: 05,
                                            maxDropSize: 12,
                                            minLength: 60,
                                            maxLength: 150,
                                            minDuration: 4,
                                            maxDuration: 8)
        
        self.view20.clipsToBounds = false
        waterDropsView.addAnimation()
        self.view20.addSubview(waterDropsView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLogs()
    }
    
    func fetchLogs() {
        let fetchRequest: NSFetchRequest<WaterLogUnit> = WaterLogUnit.fetchRequest()
        do {
            logs = try PersistenceController.shared.context.fetch(fetchRequest)
            updateProgress()
            tableView.reloadData()
        } catch {
            print("Failed to fetch logs: \(error)")
        }
    }
    
    func updateProgress() {
        let today = Calendar.current.startOfDay(for: Date())
        let totalIntakeToday = logs.filter { $0.date ?? Date() >= today }.reduce(0) { $0 + $1.quantity }
        
        // If the total intake reaches or exceeds the goal
        if totalIntakeToday >= dailyGoal {
            // Show congratulatory alert
            showCongratulatoryAlert(totalIntake: totalIntakeToday)
        }
        
        // Update progress bar and label
        progressBar.progress = Float(totalIntakeToday / dailyGoal)
        progressLabel.text = "\(Int(totalIntakeToday)) / \(Int(dailyGoal)) ml"
        
        let percentage = Float(totalIntakeToday / dailyGoal) * 100
        settingUpJarWater(for: Int(percentage))
        print("Debug: percentage",percentage)
    }
    
    // Show congratulatory alert and reset progress
    func showCongratulatoryAlert(totalIntake: Double) {
        let alertController = UIAlertController(
            title: "Congratulations!",
            message: "You've reached your hydration goal! You consumed \(Int(totalIntake)) ml today.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            // Reset the progress after the alert is dismissed
            self?.resetProgress()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetProgress() {
        // Reset the intake logs for the day and reload the table
        let today = Calendar.current.startOfDay(for: Date())
        for log in logs where log.date ?? Date() >= today {
            PersistenceController.shared.context.delete(log)
        }
        PersistenceController.shared.saveContext()
        fetchLogs()  // Refresh the logs and progress
    }
    
    
    @IBAction func btnDrinkWaterClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "AddViewController") as! AddViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addLogTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "AddViewController") as! AddViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func formatDateTime(_ date: Date?) -> String {
        guard let date = date else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium  // Display date like "Nov 26, 2024"
        formatter.timeStyle = .short   // Display time like "4:06 PM"
        return formatter.string(from: date)
    }
 
}




extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! HomeTableViewCell
        let log = logs[indexPath.row]
        let globalFunction = GlobalFunction()
        let timeString = globalFunction.timeAgoSinceDate(from: log.date!)
        cell.quantityLabel?.text = "\(log.unit ?? "")"
        cell.dateLabel?.text = timeString
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let logToDelete = logs[indexPath.row]
            PersistenceController.shared.context.delete(logToDelete)
            PersistenceController.shared.saveContext()
            fetchLogs()
        }
    }
}

extension UIView {

  func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
      self.layer.maskedCorners = corners
      self.layer.cornerRadius = radius
      self.layer.borderWidth = borderWidth
      self.layer.borderColor = borderColor.cgColor
  }

}

//MARK: SettingUpJarWater
extension HomeViewController
{
    func settingUpJarWater(for percent: Int) {
        switch percent {
        case 100:
            // All views are visible
            setViewsVisibility(hidden20: false, hidden40: false, hidden60: false, hidden80: false, hidden100: false)
            
        case 81...99:
            // Up to 80% visible, 100% hidden
            setViewsVisibility(hidden20: false, hidden40: false, hidden60: false, hidden80: false, hidden100: true)
            
        case 61...80:
            // Up to 60% visible, 80% and 100% hidden
            setViewsVisibility(hidden20: false, hidden40: false, hidden60: false, hidden80: true, hidden100: true)
            
        case 41...60:
            // Up to 40% visible, 60%, 80%, and 100% hidden
            setViewsVisibility(hidden20: false, hidden40: false, hidden60: true, hidden80: true, hidden100: true)
            
        case 21...40:
            // Only 20% visible, others hidden
            setViewsVisibility(hidden20: false, hidden40: true, hidden60: true, hidden80: true, hidden100: true)
            
        default:
            // Everything hidden
            setViewsVisibility(hidden20: true, hidden40: true, hidden60: true, hidden80: true, hidden100: true)
        }
    }

    // Helper function to set visibility for clarity and avoid repetition
    private func setViewsVisibility(hidden20: Bool, hidden40: Bool, hidden60: Bool, hidden80: Bool, hidden100: Bool) {
        self.view20.isHidden = hidden20
        self.view40.isHidden = hidden40
        self.view60.isHidden = hidden60
        self.view80.isHidden = hidden80
        self.view100.isHidden = hidden100
    }
    
}

