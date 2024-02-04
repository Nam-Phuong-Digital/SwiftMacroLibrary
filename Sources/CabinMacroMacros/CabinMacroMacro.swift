import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct DecodeInitMacro: MemberMacro {
    public static func expansion<Declaration, Context>(of node: AttributeSyntax, providingMembersOf declaration: Declaration, in context: Context) throws -> [DeclSyntax] where Declaration : DeclGroupSyntax, Context : MacroExpansionContext {
        
        guard let structDecl =  declaration.as(StructDeclSyntax.self) else {
            throw UserMacroError.onlyApplicableToStruct
        }
        
        let inheritances = structDecl.inheritanceClause?.inheritedTypes.compactMap({$0.type})
        
        let varDecl = structDecl.variablesDecl
        let varNames = varDecl.flatMap({$0.bindings.compactMap({$0.pattern})})
        let varTypeS = varDecl.flatMap({
            if $0.bindings.count > 1 {
                return Array(repeating: $0.bindings.first(where: {$0.typeAnnotation != nil})?.typeAnnotation?.type, count: $0.bindings.count)
            } else {
                return $0.bindings.compactMap{$0.typeAnnotation?.type}
            }
        }).filter({$0 != nil}).map({$0!})
        
        
        let initializer = try InitializerDeclSyntax(
            generateInitialCode(
                structModifier:structDecl.modifierString,
                variablesName: varNames,
                variablesType:varTypeS
            )
        )
        {
            for name in varNames {
                ExprSyntax("self.\(name) = \(name)")
            }
        }
        
        let decodeInitializer = try InitializerDeclSyntax(
            generateInitialDecode(
                structModifier: structDecl.modifierString
            )
        )
        {
            
            ExprSyntax("let container = try decoder.container(keyedBy: CodingKeys.self)")
            for (name, type) in zip(varNames, varTypeS) {
                if let type = type.as(IdentifierTypeSyntax.self) {
                    ExprSyntax("self.\(name) = try container.decodeIfPresent(\(type).self, forKey: .\(name)) ?? \(type)()")
                } else if let type = type.as(OptionalTypeSyntax.self) {
                    ExprSyntax("self.\(name) = try container.decodeIfPresent(\(type.wrappedType).self, forKey: .\(name))")
                } else if let types = type.as(ArrayTypeSyntax.self) {
                    ExprSyntax("self.\(name) = try container.decodeIfPresent(\(types.leftSquare)\(types.element)\(types.rightSquare).self, forKey: .\(name)) ?? \(types.leftSquare)\(types.rightSquare)")
                }
            }
        }
        if inheritances?.contains(where: {$0.as(IdentifierTypeSyntax.self)?.isCodable == true}) == true {
            return [
                DeclSyntax(initializer),
                DeclSyntax(decodeInitializer)
            ]
        } else {
            return [
                DeclSyntax(initializer)
            ]
        }
    }
}

@main
struct CabinMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DecodeInitMacro.self,
    ]
}

enum UserMacroError: CustomStringConvertible, Error {
    case onlyApplicableToStruct
    case onlyApplicableToCodable
    
    var description: String {
        switch self {
        case .onlyApplicableToStruct: return "can only be applied to a structure"
        case .onlyApplicableToCodable: return "can only be applied to a structure conform Codable"
        }
    }
}

public func generateInitialCode(
    structModifier:String?,
    variablesName: [PatternSyntax],
    variablesType: [TypeSyntax]
) -> SyntaxNodeString {
    var initialCode: String = "init("
    for (name, type) in zip(variablesName, variablesType) {
        if let type = type.as(IdentifierTypeSyntax.self) {
            initialCode += "\(name): \(type) = \(type)(), "
        } else if let type = type.as(OptionalTypeSyntax.self) {
            initialCode += "\(name): \(type) = nil, "
        } else if let type = type.as(ArrayTypeSyntax.self) {
            initialCode += "\(name): \(type.leftSquare)\(type.element)\(type.rightSquare) = \(type.leftSquare)\(type.rightSquare), "
        }
    }
    initialCode = String(initialCode.dropLast(2))
    initialCode += ")"
    if let structModifier = structModifier {
        initialCode = structModifier + " " + initialCode
    }
    return SyntaxNodeString(stringLiteral: initialCode)
}


public func generateInitialDecode(
    structModifier:String?
) -> SyntaxNodeString {
    var initialCode: String = "init(from decoder: Decoder) throws"
    if let structModifier = structModifier{
        initialCode = structModifier + " " + initialCode
    }
    return SyntaxNodeString(stringLiteral: initialCode)
}
