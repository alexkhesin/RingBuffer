import Testing
@testable import RingBuffer

class ElC {
  public var e: Int
  public init(_ e: Int) { self.e = e }
}

struct ElS {
  var e: Int
  public init(_ e: Int) { self.e = e }
  mutating func set(_ e: Int) { self.e = e }
}

struct RingBufferTests {
  func getAll<Element>(_ rb: RingBuffer<Element>) -> [Element] {
    var arr = [Element]()
    for e in rb {
      arr.append(e)
    }
    return arr
  }
  
  func getAllReverse<Element>(_ rb: RingBuffer<Element>) -> [Element] {
    var arr = [Element]()
    for e in rb.reversed() {
      arr.append(e)
    }
    return arr
  }
  
  func verify(_ rb: RingBuffer<Int>, _ expected: [Int]) {
    #expect(getAll(rb) == expected)
    #expect(getAllReverse(rb) == expected.reversed())
  }
  
  @Test func testPopulate() {
    let rb = RingBuffer<Int>(3)
    rb.put(42)
    verify(rb, [42])
    rb.put(43)
    verify(rb, [42, 43])
    rb.put(44)
    verify(rb, [42, 43, 44])
    // This will start pushing out elements since the ring buffer capacity is 3 elements
    rb.put(45)
    verify(rb, [43, 44, 45])
    rb.put(46)
    verify(rb, [44, 45, 46])
  }
  
  func find(_ rb: RingBuffer<ElC>, _ val:Int) -> ElC? {
    for e in rb {
      if e.e == val { return e }
    }
    return nil
  }
  
  @Test func testFind() {
    let rb = RingBuffer<ElC>(3)
    rb.put(ElC(3))
    rb.put(ElC(4))
    rb.put(ElC(5))
    #expect(getAll(rb)[1].e == 4)
    find(rb, 4)?.e = 50
    #expect(getAll(rb)[0].e == 3)
    #expect(getAll(rb)[1].e == 50)
    #expect(getAll(rb)[2].e == 5)
  }
  
  @Test func testMutateClass() {
    let rb = RingBuffer<ElC>(3)
    rb.put(ElC(3))
    rb.put(ElC(4))
    rb.put(ElC(5))
    #expect(getAll(rb)[1].e == 4)
    for e in rb {
      e.e = 1
    }
    #expect(getAll(rb)[1].e == 1)
  }
  
  @Test func testMutateStruct() {
    let rb = RingBuffer<ElS>(3)
    rb.put(ElS(3))
    rb.put(ElS(4))
    rb.put(ElS(5))
    #expect(getAll(rb)[1].e == 4)
    for var e in rb {
      e.set(1)
    }
    #expect(getAll(rb)[1].e == 4)
  }
}
