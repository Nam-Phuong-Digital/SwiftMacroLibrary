//
//  File.swift
//  
//
//  Created by Dai Pham on 21/09/2023.
//

import Foundation
import SwiftSyntax

extension MemberBlockItemSyntax {
    var isCodingKeys:Bool {
        guard let enumo = self.decl.as(EnumDeclSyntax.self) else {return false}
        let inherit = enumo.inheritanceClause?.inheritedTypes.compactMap({$0.type}).compactMap({$0.as(IdentifierTypeSyntax.self)?.name.text})
        return inherit?.contains("CodingKey") == true
    }
}

extension EnumDeclSyntax {
    var enumsDecl:[EnumCaseDeclSyntax] {
        memberBlock.members.compactMap {$0.decl.as(EnumCaseDeclSyntax.self)}
    }
    
    var allMemberCase:[String] {
        enumsDecl.flatMap({$0.elements.compactMap({$0.as(EnumCaseElementSyntax.self)?.name.text})})
    }
}

extension StructDeclSyntax {
    var variablesDecl:[VariableDeclSyntax] {
        let members = memberBlock.members
        let result = members.compactMap {$0.decl.as(VariableDeclSyntax.self)}
        if let enumCase = members.first(where: {$0.isCodingKeys})?.decl.as(EnumDeclSyntax.self) {
            let allMembersCase = enumCase.allMemberCase
            return result.filter({r in
                let allVardel = r.bindings.compactMap({$0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text})
                return allMembersCase.contains { r1 in
                    allVardel.contains(r1)
                }
            })
        }
        return result
    }
    
    var modifierString: String? {
        modifiers
            .compactMap{$0.name.text}
            .filter{!$0.isEmpty}
            .joined(separator: " ")
    }
}

extension IdentifierTypeSyntax {
    var isInt:Bool {
        name.text == String(describing: Int.self)
    }
    
    var isString:Bool {
        name.text == String(describing: String.self)
    }
    
    var isCodable:Bool {
        name.text == "Codable"
    }
}

extension TypeSyntax {
    var isArray:Bool {
        self.as(ArrayTypeSyntax.self) != nil
    }
}
