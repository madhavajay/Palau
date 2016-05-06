//
//  PalauDefaultsEntry.swift
//  Palau
//
//  Created by symentis GmbH on 26.04.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation


/// A PalauDefaultsEntry
///
/// This entry takes care of single values like
/// ```
/// public static var intValue: PalauDefaultsEntry<Int>
///   get { return value("intValue") }
///   set { }
/// }
/// ```
/// The value of the PalauDefaultsEntry is always an optional e.g.
/// ```
/// // val is of type Int?
/// let val = PalauDefaults.intValue.value
/// ```
public struct PalauDefaultsEntry<T: PalauDefaultable where T.ValueType == T>: PalauEntry {

  public typealias ValueType = T
  public typealias ReturnType = T

  /// for convenience
  public typealias PalauDidSetFunction = (newValue: ReturnType?, oldValue: ReturnType?) -> Void
  public typealias PalauEnsureFunction = (ReturnType?) -> ReturnType?

  /// The key of the entry
  public let key: String

  /// Access to the default
  public let defaults: NSUD

  /// A function to change the incoming and outgoing value
  public let ensure: PalauEnsureFunction

  /// A function as callback after set
  public let didSet: PalauDidSetFunction?

  /// a initializer
  public init(key: String, defaults: NSUserDefaults, didSet: PalauDidSetFunction? = nil, ensure: PalauEnsureFunction) {
    self.key = key
    self.defaults = defaults
    self.ensure = ensure
    self.didSet = didSet
  }

  /// The value
  /// use this property to get the Optional<ReturnType>
  /// or to set the ReturnType
  public var value: ReturnType? {
    get {
      return ensure(ValueType.get(key, from: defaults))
    }
    set {
      withDidSet {
        ValueType.set(self.ensure(newValue), forKey: self.key, in: self.defaults)
      }
    }
  }

}
