//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by tb on 9/17/17.
//  Copyright © 2017 tb. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .short
  return formatter
}()

class LocationDetailsViewController: UITableViewController {
  
  var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var placemark: CLPlacemark?
  var categoryName = "No Category"
  
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBAction func done() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue)
  {
    let controller = segue.source as! CategoryPickerViewController
    categoryName = controller.selectedCategoryName
    categoryLabel.text = categoryName
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    descriptionTextView.text = ""
    categoryLabel.text = categoryName
    latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
    longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
    if let placemark = placemark {
      addressLabel.text = string(from: placemark)
    } else {
      addressLabel.text = "No Address Found"
    }
    
    dateLabel.text = format(date: Date())
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickCategory" {
      let controller = segue.destination as! CategoryPickerViewController
      controller.selectedCategoryName = categoryName
    }
  }
  
  func string(from placemark: CLPlacemark) -> String {
    var text = ""
    if let s = placemark.subThoroughfare {
      text += s + " "
    }
    if let s = placemark.thoroughfare {
      text += s + ", "
    }
    if let s = placemark.locality {
      text += s + ", "
    }
    if let s = placemark.administrativeArea {
      text += s + " "
    }
    if let s = placemark.postalCode {
      text += s + ", "
    }
    if let s = placemark.country {
      text += s
    }
    
    return text
  }
  
  func format(date: Date) -> String {
    return dateFormatter.string(from: date)
  }
  
  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
    // This is Description cell
    if (indexPath.section == 0 && indexPath.row == 0) {
      return 88
    }
    else if (indexPath.section == 2 && indexPath.row == 2) {
      // Address cell
      addressLabel.frame.size = CGSize(
        width: view.bounds.size.width - 115,
        height: 10000)
      addressLabel.sizeToFit()
      addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 15
      return addressLabel.frame.size.height + 20
    }
    else {
      return 44
    }
  }
}
