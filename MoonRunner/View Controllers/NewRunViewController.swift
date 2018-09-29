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
import CoreLocation
import MapKit
import AVFoundation

class NewRunViewController: UIViewController {
  
  @IBOutlet weak var launchPromptStackView: UIStackView!
  @IBOutlet weak var dataStackView: UIStackView!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var mapContainerView: UIView!
  @IBOutlet weak var badgeStackView: UIStackView!
  @IBOutlet weak var badgeImageView: UIImageView!
  @IBOutlet weak var badgeInfoLabel: UILabel!

  private var run: Run? // create Run instance
  private let locationManager = LocationManager.shared //object used to start/stop location services
  private var seconds = 0 //tracks duration of run
  private var timer: Timer? //fires each second to update UI
  private var distance = Measurement(value: 0, unit: UnitLength.meters) //holds cumulative distance of the run
  private var locationList: [CLLocation] = [] //holds all CLLocation objects collected during the run
  
  private var upcomingBadge: Badge!
  
  //create audio to be played when a new badge is earned
  private let successSound: AVAudioPlayer = {
    guard let successSound = NSDataAsset(name: "success") else {
      return AVAudioPlayer()
    }
    return try! AVAudioPlayer(data: successSound.data)
  }()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataStackView.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    //stop timer and location updates (battery consumer) when user navigates away from view
    timer?.invalidate()
    locationManager.stopUpdatingLocation()
  }
  
  //called once per second by timer
  func eachSecond() {
    seconds += 1
    //every second, check if a badge has been achieved
    checkNextBadge()
    updateDisplay()
  }
  
  //uses formatting ability from FormatDisplay.swift to update UI will details of current run
  private func updateDisplay() {
    let formattedDistance = FormatDisplay.distance(distance)
    let formattedTime = FormatDisplay.time(seconds)
    let formattedPace = FormatDisplay.pace(distance: distance,
                                           seconds: seconds,
                                           outputUnit: UnitSpeed.minutesPerMile)
    
    distanceLabel.text = "Distance:  \(formattedDistance)"
    timeLabel.text = "Time:  \(formattedTime)"
    paceLabel.text = "Pace:  \(formattedPace)"
    
    //get distance remaining until user earns next badge and displays this info to user
    let distanceRemaining = upcomingBadge.distance - distance.value
    let formattedDistanceRemaining = FormatDisplay.distance(distanceRemaining)
    badgeInfoLabel.text = "\(formattedDistanceRemaining) until \(upcomingBadge.name)"

  }
  
  private func startRun() {
    mapContainerView.isHidden = false
    mapView.removeOverlays(mapView.overlays)
    launchPromptStackView.isHidden = true
    dataStackView.isHidden = false
    startButton.isHidden = true
    stopButton.isHidden = false
    
    //resets duration, distance, locations to 0 , starts timer when starting new run
    seconds = 0
    distance = Measurement(value: 0, unit: UnitLength.meters)
    locationList.removeAll()
    
    //shows initial badge to earn??
    badgeStackView.isHidden = false
    upcomingBadge = Badge.next(for: 0)
    badgeImageView.image = UIImage(named: upcomingBadge.imageName)

    updateDisplay()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      self.eachSecond()
    }
    startLocationUpdates() //begins collection location updates
  }
  
  private func stopRun() {
    //hide details between runs
    badgeStackView.isHidden = true
    mapContainerView.isHidden = true
    launchPromptStackView.isHidden = false
    dataStackView.isHidden = true
    startButton.isHidden = false
    stopButton.isHidden = true
    locationManager.stopUpdatingLocation() //when user wants to end run, stop tracking location
  }
  
  private func startLocationUpdates() {
    locationManager.allowsBackgroundLocationUpdates = true;
    locationManager.delegate = self //make this class delegate for Core Location so we can receive and process location updates
    locationManager.activityType = .fitness //helps device intelligently save power throughout run (ex:stopping to cross road)
    locationManager.distanceFilter = 10 //since location readings can deviate from straight line, this reduces zig zagging and produces mreo accure line
    locationManager.startUpdatingLocation() //tell Core Location to start getting location updates
  }
  
  private func saveRun() {
    let newRun = Run(context: CoreDataStack.context) //create new run object
    
    //initialize it with the desired run's recorded distance, duration, and date
    newRun.distance = distance.value
    newRun.duration = Int16(seconds)
    newRun.timestamp = Date()
    
    //for each CLLocation recorded
    for location in locationList {
      let locationObject = Location(context: CoreDataStack.context) //create location object
      //save location data
      locationObject.timestamp = location.timestamp
      locationObject.latitude = location.coordinate.latitude
      locationObject.longitude = location.coordinate.longitude
      newRun.addToLocations(locationObject) //add each location to Run using automatically generated (addToLocations)
    }
    
    CoreDataStack.saveContext()
    
    run = newRun
  }
  //???
  //detects when a badge has been achieved
  private func checkNextBadge() {
    let nextBadge = Badge.next(for: distance.value)
    if upcomingBadge != nextBadge { //if the upcoming badge is not the next badge, next badge has been achieved
      badgeImageView.image = UIImage(named: nextBadge.imageName)
      upcomingBadge = nextBadge //reset upcoming badge
      successSound.play()
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
  }

  @IBAction func startTapped() {
    startRun()
  }
  
  //when user taps stop button, give them optopn to save, discard, or continue run
  @IBAction func stopTapped() {
    let alertController = UIAlertController(title: "End run?",
                                            message: "Do you wish to end your run?",
                                            preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
      self.stopRun()
      self.saveRun() //save run details to core data
      self.performSegue(withIdentifier: .details, sender: nil)
    })
    alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
      self.stopRun()
      _ = self.navigationController?.popToRootViewController(animated: true)
    })
    
    present(alertController, animated: true)
  }
  
}

//to avoid a stringly typed interface by using enum instead of string for segue id
extension NewRunViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case details = "RunDetailsViewController"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segueIdentifier(for: segue) {
    case .details:
      let destination = segue.destination as! RunDetailsViewController
      destination.run = run
    }
  }
}

//used to report location updates
//called each time core location updates user location
//provides array of CLLocation devices (locationList)
extension NewRunViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      //if location isn't confident within 20 meters or not recent, keep out of data set
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
      
      //if CLLocation is reliable, find distance between it and most recently saved point
      //and add to cumulative distance of run
      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation) //get distance between locations
        distance = distance + Measurement(value: delta, unit: UnitLength.meters) //distance with units
        let coordinates = [lastLocation.coordinate, newLocation.coordinate] //get location coordinates
        mapView.add(MKPolyline(coordinates: coordinates, count: 2))
        let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)

      }
      
      locationList.append(newLocation)
    }
  }
}

//renders line while you are running
//allows you to see map and route while running, similar to extension from runDetailsViewController
extension NewRunViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    
    //line to show route you are taking is in blue while you are still running
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = .blue
    renderer.lineWidth = 3
    return renderer
  }
}



