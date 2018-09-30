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

//Adrienne Corwin
//NEW FUNCTIONALITY

//https://www.verywellfit.com/tips-for-running-farther-2911290
//https://www.wikihow.life/Run-Longer
//https://www.popsugar.com/fitness/Long-Distance-Running-Tips-Beginners-8300122

//same logic as Faster Tips View Controller
import UIKit
class LongerTipsViewController: UIViewController {
  
  @IBOutlet var tipOne: UIButton!
  @IBOutlet var tipTwo: UIButton!
  @IBOutlet var tipThree: UIButton!
  @IBOutlet var tipFour: UIButton!
  @IBOutlet var tipFive: UIButton!
  @IBOutlet var tipSix: UIButton!
  @IBOutlet var tipSeven: UIButton!
  @IBOutlet var tipEight: UIButton!
  @IBOutlet var tipNine: UIButton!
  
  let tipTitles = ["2 Hour Rule", "Stop and Stretch", "Running Buddy", "Change It Up", "Good Form", "Rotate Intensity", "Walk When Necessary", "10% Rule", "Rest"]
  
  let tipDesc = ["Wait 2 hours after eating before running.", "Prevent having to stop from tightness in muscles.", "Run with others that can motivate you, push you, and distract you.", "Change up your route occassionally so you don't get bored.", "Pump arms, relax upper body, breath through nose and mouth.", "Alternate between fast, short runs and slower longer runs during the week", "Allow your body to build up endurance and recover in short intervals.", "Never increase weelky mileage by more than 10%", "Incorporate 1 or 2 rest days into your routine to allow your muscles to heal."]
  
  var tipsDict = [String:String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    for i in 0..<tipTitles.count{
      tipsDict[tipTitles[i]] = tipDesc[i]
    }
    
    tipOne.setTitle(tipTitles[0], for: .normal)
    tipTwo.setTitle(tipTitles[1], for: .normal)
    tipThree.setTitle(tipTitles[2], for: .normal)
    tipFour.setTitle(tipTitles[3], for: .normal)
    tipFive.setTitle(tipTitles[4], for: .normal)
    tipSix.setTitle(tipTitles[5], for: .normal)
    tipSeven.setTitle(tipTitles[6], for: .normal)
    tipEight.setTitle(tipTitles[7], for: .normal)
    tipNine.setTitle(tipTitles[8], for: .normal)
    
  }
  
  @IBAction func tipsTapped(_ sender: UIButton) {
    if(tipTitles.contains(sender.currentTitle!)){
      sender.setTitle(tipsDict[sender.currentTitle!], for: .normal)
    }
    else{
      let tipIndex = tipDesc.index(of: sender.currentTitle!)
      sender.setTitle(tipTitles[tipIndex!], for: .normal)
    }
  }
  
}
