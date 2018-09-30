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

//TIPS FROM https://greatist.com/fitness/25-ways-run-faster-now

import UIKit
class FasterTipsViewController: UIViewController {
  
    @IBOutlet var tipOne: UIButton!
    @IBOutlet var tipTwo: UIButton!
    @IBOutlet var tipThree: UIButton!
    @IBOutlet var tipFour: UIButton!
    @IBOutlet var tipFive: UIButton!
    @IBOutlet var tipSix: UIButton!
    @IBOutlet var tipSeven: UIButton!
    @IBOutlet var tipEight: UIButton!
    @IBOutlet var tipNine: UIButton!
  
  //when you tap on a tip the button will toggle between showing the tip title and its corresponding description
  
  //set 9 tip titles
  let tipTitles = ["Jump Rope", "Lighter Shoes", "Core Workout", "Breathing", "Whole Grains", "Drink Coffee", "Toes", "Restistance Training", "Go Steady"]
  
  //set 9 tip descriptions so the elements in the tip descriptions array and tip titles array correspond
  let tipDesc = ["Jumping rope helps make your feet faster.", "Lighter sneakers mimic your foot's natural movement and improve your stride.", "Stronger core allows you to tap into more force.", "Use nose and mouth while breathing to get the maximum amount of oxygen to the muscles.", "Whole grains and pasta provide long-lasting energy without the crash.", "Drinking caffeine before running gives you an extra jolt of speed", "Arching toes upward means less of your foot hits the ground for a quicker stride turnover.", "Try a running parachute for added resistance.", "Finding a comfortably hard pace and holding it for a 20 minute period."]
  
  //dictionary where key will be tip title and value will be corresponding tip description
  var tipsDict = [String:String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //populate dictionary with tip titles and descriptions
    for i in 0..<tipTitles.count{
      tipsDict[tipTitles[i]] = tipDesc[i]
    }
    
    //set button titles
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
    //if the current title of the selected button is a tip title set the title to the tip title's corresponding description (from dict)
    if(tipTitles.contains(sender.currentTitle!)){
      sender.setTitle(tipsDict[sender.currentTitle!], for: .normal)
    }
    else{ //if the button title is a description, set title to tip title corresponding to description (parallel arrays)
      let tipIndex = tipDesc.index(of: sender.currentTitle!)
      sender.setTitle(tipTitles[tipIndex!], for: .normal)
    }
  }
  
  
}

