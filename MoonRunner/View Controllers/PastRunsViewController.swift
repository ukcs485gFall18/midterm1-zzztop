//
/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

//-----------------------------
// All online resources utilized include:
// https://stackoverflow.com/questions/31665927/setting-tableview-headers-height-in-swift
// https://www.ioscreator.com/tutorials/customizing-header-footer-table-view-ios8-swift
// https://stackoverflow.com/questions/31964941/swift-how-to-make-custom-header-for-uitableview
//------------------------------

//-----------------------------
// All imported resources
//-----------------------------
import UIKit
import CoreData

//-----------------------------------------------------------------------------
//This class is new functionality implemented by Jordan George and Kyra Seevers
//-----------------------------------------------------------------------------
class PastRunsViewController: UITableViewController {
  
  // array for storing runs
  var runs: [Run] = []
  // variable to hold reuse identifier to avoid hard coding the string
  let reuseID = "Cell"
  
  //completed by Jordan
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // alter navigation title name
    self.navigationItem.title = "Past Runs"
    // alter navigation title color
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    
    // register tableview
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
    
    // assign runs in reversed order within 'runs'
    runs = getRuns().reversed()
  }
  
  //completed by Jordan
  private func getRuns() -> [Run] {
     // make request to core data for saved runs
    let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
     // sort runs by data
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Run.timestamp), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    do {
      // get the data
      return try CoreDataStack.context.fetch(fetchRequest)
    } catch {
      return []
    }
  }
  
  //completed by Jordan
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return runs.count
  }
  
  //completed by Kyra Seevers
  //------------------------------------------------------
  // tableView (editing header)
  //------------------------------------------------------
  // Purpose: to edit the header cell of the UITableView
  // and place the cumulative run statistics inside of it
  // showing above the past runs data!
  // Pre: the UITableView, the header section
  // Post: returns the UIView (header Cell)
  //------------------------------------------------------
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    //creating the header cell as a member of the new custom header cell class
    let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! StatsHeaderCellTableViewCell
    headerCell.backgroundColor = UIColor.green

    var totalDistance:Double = 0;
    var totalDuration:Int16 = 0;
    
    //accumulating the total statistics
    for run in runs{
      totalDistance+=run.distance
      totalDuration+=run.duration
    }

    //calculating the average distance, duration, and pace with appropriate units
    let aveDistance = totalDistance/Double(runs.count);
    let aveDuration = Double(totalDuration)/Double(runs.count);
    let avePace = Double(aveDuration)/(aveDistance*0.000621371);
    
    //assigning the information to the display string (ensuring that the label text is set for 4 lines in the storyboard)
    var labelText:String = "Your Running Stats: \n"
    labelText += "Average distance: \(FormatDisplay.distance(aveDistance))\n"
    labelText += "Average duration: \(String(format: "%.2f", Float(aveDuration) / 60.00)) minutes \n"
    labelText += "Average pace: \(String(format: "%.2f", Float(avePace))) min/mi"
    headerCell.statsHeaderLabel.text = labelText
    
    //return the headerCell to be placed in the UITableView
    return headerCell
  }
  
  //------------------------------------------------------
  // tableView (header height)
  //------------------------------------------------------
  // Purpose: to lengthen the header height
  // Pre: the UITableView, the header section
  // Post: returns the height as a CGFloat
  //------------------------------------------------------
  //completed by Kyra Seevers
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let HeaderHeight:CGFloat = 100
    return HeaderHeight
  }
  
  //completed by Jordan George
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
    
    let run = runs[indexPath.row]
    
    // get distance of individual run
    let distance = FormatDisplay.distance(Double(run.distance))
    // get duration of individual run
    let duration = String(format: "%.2f", Float(run.duration) / 60.00)
    
    // display distance and duration in each cell for each past run
    cell.textLabel?.text = "\(distance) miles | \(duration) minutes"
    
    return cell
  }
  
}
