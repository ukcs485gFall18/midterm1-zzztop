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

@UIApplicationMain
//--------------------------------------
// Class: AppDelegate
// Purpose: delegated tasks
//--------------------------------------
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  //private member variable
  var window: UIWindow?
  
  //--------------------------------------------------------
  // application
  //--------------------------------------------------------
  // set up the application especially the UI elements and
  // locationManager
  // Pre: all UI elements
  // Post: return bool
  //--------------------------------------------------------
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().barTintColor = .black
    let locationManager = LocationManager.shared
    locationManager.requestAlwaysAuthorization() //request permission to use location information
    return true
  }
  
  //--------------------------------------------------------
  // applicationDidEnterBackground
  //--------------------------------------------------------
  // set up the coreData for usage and saving
  //--------------------------------------------------------
  func applicationDidEnterBackground(_ application: UIApplication) {
    CoreDataStack.saveContext()
  }
  
  //--------------------------------------------------------
  // applicationWillTerminate
  //--------------------------------------------------------
  // set up core data to save when the app ends
  //--------------------------------------------------------
  func applicationWillTerminate(_ application: UIApplication) {
    CoreDataStack.saveContext()
  }
  
}

