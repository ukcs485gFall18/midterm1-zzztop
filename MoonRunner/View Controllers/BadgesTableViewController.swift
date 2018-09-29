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
// All imported resources
//-----------------------------
import UIKit
import CoreData


//--------------------------------------
// Class: BadgesTableViewController
// Purpose: displays badges in a table
//--------------------------------------
class BadgesTableViewController: UITableViewController {
  
  //private member variable
  var statusList: [BadgeStatus]!
  
  //--------------------------------------------------------
  // viewDidLoad
  //--------------------------------------------------------
  // overloading viewdidLoad to get the saved runs
  // Pre: none
  // Post: returns nothing but sets the statusList to show
  // the badges earned
  //--------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()
    //when view loads ask get saved runs from Core Data
    statusList = BadgeStatus.badgesEarned(runs: getRuns())
  }
  
  //--------------------------------------------------------
  // getRuns
  //--------------------------------------------------------
  // Fetches the runs from coreData
  // Pre: none
  // Post: returns an array of Runs fetched from CoreData
  //--------------------------------------------------------
  private func getRuns() -> [Run] {
    let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest() //make request to core data for saved runs
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Run.timestamp), ascending: true) //sort runs by data
    fetchRequest.sortDescriptors = [sortDescriptor]
    do {
      return try CoreDataStack.context.fetch(fetchRequest)
    } catch {
      return [] //return an empty array
    }
  }
}

//redueces stringly typed code
extension BadgesTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return statusList.count //returns how many sections table should have
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: BadgeCell = tableView.dequeueReusableCell(for: indexPath)
    cell.status = statusList[indexPath.row] //set the status corresponding to badge at indexPath.row in table
    return cell
  }
}

extension BadgesTableViewController: SegueHandlerType {
  //giving the segue between views a name
  enum SegueIdentifier: String {
    case details = "BadgeDetailsViewController"
  }
  
  //--------------------------------------------------------
  // prepare
  //--------------------------------------------------------
  // pass BadgeStatus to badgeDetailsVC when badge in BadgeTableVC is tapped
  // Pre: segue and the sender (as an optional)
  // Post: returns nothing but determines the destination after picking a badge 
  //-------------------------------------------------------
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segueIdentifier(for: segue) {
    case .details:
      let destination = segue.destination as! BadgeDetailsViewController
      let indexPath = tableView.indexPathForSelectedRow!
      destination.status = statusList[indexPath.row] //gets badge status to pass
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    guard let segue = SegueIdentifier(rawValue: identifier) else { return false }
    switch segue {
    case .details:
      guard let cell = sender as? UITableViewCell else { return false }
      return cell.accessoryType == .disclosureIndicator
    }
  }
}


