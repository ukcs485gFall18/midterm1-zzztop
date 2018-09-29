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

//-------------------------------------------------
// Class UnitConverterPace
//-------------------------------------------------
// Purpose: handles math of conversion from unit
// to unit
//-------------------------------------------------
class UnitConverterPace: UnitConverter {
  private let coefficient: Double
  
  //constructor for UnitConverterPace, holds coefficient
  init(coefficient: Double) {
    self.coefficient = coefficient
  }
  //--------------------------------------------------------
  // baseUnitValue
  //--------------------------------------------------------
  // overrides the inherited baseUnitValue
  // Pre: takes in a double
  // Post: returns the reciprocal of value * coeff
  //--------------------------------------------------------
  override func baseUnitValue(fromValue value: Double) -> Double {
    return reciprocal(value * coefficient)
  }
  //--------------------------------------------------------
  // value
  //--------------------------------------------------------
  // overrides the inherited value function
  // Pre: takes in a double
  // Post: returns the reciprocal of value * coeff
  //--------------------------------------------------------
  override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
    return reciprocal(baseUnitValue * coefficient)
  }
  
  //--------------------------------------------------------
  // reciprocal
  //--------------------------------------------------------
  // Pre: takes in a double
  // Post: returns the reciprocal of that number as a double
  //--------------------------------------------------------
  private func reciprocal(_ value: Double) -> Double {
    guard value != 0 else { return 0 }
    return 1.0 / value
  }
}
//--------------------------------------------------
// Class UnitConverterPace
//--------------------------------------------------
// Purpose: since runners use time per unit distance
// rather than speed, extend Unit speed to support
// conversion
//--------------------------------------------------
extension UnitSpeed { //extending the functionality of the original class
  class var secondsPerMeter: UnitSpeed {
    return UnitSpeed(symbol: "sec/m", converter: UnitConverterPace(coefficient: 1))
  }
  
  class var minutesPerKilometer: UnitSpeed {
    return UnitSpeed(symbol: "min/km", converter: UnitConverterPace(coefficient: 60.0 / 1000.0))
  }
  
  class var minutesPerMile: UnitSpeed {
    return UnitSpeed(symbol: "min/mi", converter: UnitConverterPace(coefficient: 60.0 / 1609.34))
  }
}

