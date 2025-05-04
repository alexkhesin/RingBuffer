import Foundation

class RingBuffer<Element> : BidirectionalCollection  {
  private var data : [Element] = []
  private var head: Int = 0
  private var size: Int = 0

  public init(_ size: Int) {
    data.reserveCapacity(size)
    self.size = size
  }

  public func reset() {
    data.removeAll(keepingCapacity: true)
    head = 0
  }

  public func put(_ val: Element) {
    if (data.count < size) {
      data.append(val)
    } else {
      data[head] = val
      head = (head + 1) % size
    }
  }

  public func empty() -> Bool { return data.count == 0 }
  public func count() -> Int { return data.count }

  // Collection methods
  var startIndex: Int   { return 0 }
  var endIndex: Int     { return data.count }
  subscript(index: Int) -> Element {
    precondition(index < endIndex, "Can't advance beyond endIndex")
    precondition(index >= startIndex, "Can't advance below startIndex")
    return data[(head + index) % data.count];
  }
  func index(after i: Int) -> Int {
    precondition(i < endIndex, "Can't advance beyond endIndex")
    // print("after \(i)")
    return i + 1
  }
  func index(before i: Int) -> Int {
    precondition(i >= startIndex, "Can't advance below startIndex")
    // print("before \(i)")
    return i - 1
  }

  // Sequence methods
  /*
    public func makeIterator() -> RingBufferIterator<Element> {
      return RingBufferIterator(data, head, data.count)
    }
  */
}
