//
//  AddViewController.swift
//  HydrationTracker
//
//  Created by apple on 26/11/24.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var myTitleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var quantityTextField: UITextField!
    let units = ["ml", "oz"]
    let imageArry = ["Group-4","Group-5","Group-6","Group-7","Group-8","Group-9","Group-10","Group-11"]
    var unitValue = ["100ml","200ml","300ml","400ml","500ml","600ml","700ml","800ml"]
    var getValue : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AddCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        quantityTextField.layer.borderWidth = 2
        quantityTextField.layer.cornerRadius = 10
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.myTitleLabel.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    @IBAction func saveLogTapped(_ sender: UIButton) {
        print("Quantity Text Field: \(quantityTextField.text ?? "nil")")
        print("Selected Unit: \(getValue)")
        
        guard let quantityText = quantityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let numericValue = Double(quantityText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()),
              !getValue.isEmpty else {
            print("Error: Quantity is missing or invalid")
            return
        }
        
        let newLog = WaterLogUnit(context: PersistenceController.shared.context)
        newLog.id = UUID()
        newLog.date = Date()
        newLog.quantity = numericValue // Save the numeric value
        newLog.unit = getValue // Save the selected unit
        
        // Save to persistent storage
        PersistenceController.shared.saveContext()
        
        print("Saved Log: \(newLog.quantity) \(newLog.unit)")
        navigationController?.popViewController(animated: true)
    }
     
    
}
extension AddViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddCollectionViewCell
        cell.imageView.image = UIImage(named: imageArry[indexPath.item])
        cell.titleLabel.text = unitValue[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getValue = unitValue[indexPath.item]
        print(getValue)
        print("Selected Index: \(indexPath.item), Updated Value: \(unitValue[indexPath.item])")
        quantityTextField.text = "  \(getValue)"
    }
}
extension AddViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2  // Two columns
        let padding: CGFloat = 20     // Adjust padding as needed (for spacing between cells)
        
        // Calculate total padding: (number of spaces between items + edge insets)
        let totalPadding = padding * (itemsPerRow + 1)
        
        // Calculate width per item
        let width = (collectionView.frame.width - totalPadding) / itemsPerRow
        
        // Set height equal to width for square cells
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10  // Adjust spacing between rows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10  // Adjust spacing between items in a row
    }


    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)  // Adjust padding as needed
//        layout.minimumInteritemSpacing = 0  // Horizontal spacing between items
//        layout.minimumLineSpacing = 0  // Vertical spacing between rows
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}
