import SwiftSyntaxMacros
import CabinMacroMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
//import CabinMacro
import CabinMacro

let testMacros: [String: Macro.Type] = [
    "DecodeInit": DecodeInitMacro.self,
    "Localizable": LocalizableMacro.self,
]

final class CabinMacroTests: XCTestCase {
    func testDecodeInit() {
        assertMacroExpansion(
                   """
                   @DecodeInit
                   public struct Book: Codable {
                       public let handOverid, price: Int
                       public let title: String
                       public var docs: [String] = []
                        enum CodingKeys:String, CodingKey {
                            case handOverid = "id"
                            case title
                            case price
                        }
                   }
                   """,
                   expandedSource:
                   """
                   
                   public struct Book: Codable {
                       public let id, price: Int
                       public let title: String
                       public let docs: [String]
                   
                       public init(id: Int, price: Int, title: String, docs: [String]) {
                           self.id = id
                           self.price = price
                           self.title = title
                           self.docs = docs
                       }
                   
                       public init(from decoder: Decoder) throws {let container = try decoder.container(keyedBy: CodingKeys.self)
                           self.id = try container.decode(Int.self, forKey: .id)
                           self.price = try container.decode(Int.self, forKey: .price)
                           self.title = try container.decode(String.self, forKey: .title)
                           self.docs = try container.decode([String].self, forKey: .docs)
                       }
                   }
                   """,
                   macros: testMacros
               )
    }
}
