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

import UIKit
import CoreData

class PastRunsViewController: UITableViewController {
  
  // array for storing runs
  var runs: [Run] = []
  // variable to hold reuse identifier to avoid hard coding the string
  let reuseID = "Cell"
  
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
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return runs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
    
    let run = runs[indexPath.row]
    
    let duration = run.duration / 60
    let distance = Double(run.distance)
    
    cell.textLabel?.text = "\(FormatDisplay.distance(distance)) miles | \(duration) minutes"
    
    return cell
  }
  
}