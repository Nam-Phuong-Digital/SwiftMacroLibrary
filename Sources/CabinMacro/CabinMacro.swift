// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: named(init))
public macro DecodeInit() = #externalMacro(module: "CabinMacroMacros", type: "DecodeInitMacro")

@freestanding(declaration,names: arbitrary)
public macro Localizable(_: String) = #externalMacro(module: "CabinMacroMacros", type: "LocalizableMacro")

@freestanding(declaration,names: arbitrary)
public macro Localizable2(_: String) = #externalMacro(module: "CabinMacroMacros", type: "LocalizableMacro2")
