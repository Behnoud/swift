// RUN: %target-typecheck-verify-swift -verify-ignore-unknown

// Simple structs where Codable conformance is added in extensions should still
// derive conformance.
struct SimpleStruct {
  var x: Int
  var y: Double
  static var z: String = "foo"

  // These lines have to be within the SimpleStruct type because CodingKeys
  // should be private.
  func foo() {
    // They should receive synthesized init(from:) and an encode(to:).
    let _ = SimpleStruct.init(from:)
    let _ = SimpleStruct.encode(to:)

    // They should receive a synthesized CodingKeys enum.
    let _ = SimpleStruct.CodingKeys.self

    // The enum should have a case for each of the vars.
    let _ = SimpleStruct.CodingKeys.x
    let _ = SimpleStruct.CodingKeys.y

    // Static vars should not be part of the CodingKeys enum.
    let _ = SimpleStruct.CodingKeys.z // expected-error {{type 'SimpleStruct.CodingKeys' has no member 'z'}}
  }
}

extension SimpleStruct : Codable {}

// These are wrapped in a dummy function to avoid binding a global variable.
func foo() {
  // The synthesized CodingKeys type should not be accessible from outside the
  // struct.
  let _ = SimpleStruct.CodingKeys.self // expected-error {{'CodingKeys' is inaccessible due to 'private' protection level}}
}
