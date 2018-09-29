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
import Foundation

//-----------------------------------------------
// Struct BadgeStatus
//-----------------------------------------------
// structure to store badges when they are earned
// will establish association between a run and a bage earned during the run
//-----------------------------------------------
struct BadgeStatus {
  //badge status attributes
  let badge: Badge
  let earned: Run?
  let silver: Run?
  let gold: Run?
  let best: Run?
  
  //defines the two upgarde versions of a badge
  //you can upgrade the badge if you run the badge distance the specified multiplier \
  //amount faster than the speed you ran when you first required badge
  static let silverMultiplier = 1.05
  static let goldMultiplier = 1.1
  
  //--------------------------------------------------------
  // badgesEarned
  //--------------------------------------------------------
  // compares badge speeds and awards runs silver/gold badges appropriately
  // returns the struct of newly formed badge attributes
  // Pre: An array of runs
  // Post: returns an array of BadgeStatus
  //--------------------------------------------------------
  static func badgesEarned(runs: [Run]) -> [BadgeStatus] {
    return Badge.allBadges.map { badge in
      //optional variables
      var earned: Run?
      var silver: Run?
      var gold: Run?
      var best: Run?
      
      //loops through the runs array and sees how many runs pass the badge distance requirements
      for run in runs where run.distance > badge.distance {
        if earned == nil {//if you haven't earned it before
          earned = run //if is earned
        }
        
        //determines the speed required to earn the badge
        let earnedSpeed = earned!.distance / Double(earned!.duration)
        //calculates the actual run speed
        let runSpeed = run.distance / Double(run.duration)
        
        //determine the level of earning (silver or gold)
        if silver == nil && runSpeed > earnedSpeed * silverMultiplier {
          silver = run
        }
        if gold == nil && runSpeed > earnedSpeed * goldMultiplier {
          gold = run
        }
        
        //keeps track of the run with fastest speed achieved for each badge
        if let existingBest = best {
          let bestSpeed = existingBest.distance / Double(existingBest.duration)
          if runSpeed > bestSpeed {
            best = run
          }
        } else { //if you weren't faster than before, put the previous run as the best
          best = run
        }
      }
      
      return BadgeStatus(badge: badge, earned: earned, silver: silver, gold: gold, best: best)//return the new badge
    }
  }

}

