//
//  Symbols.swift
//  
//
//  Created by Cody Lewis on 2023-02-26.
//

import Foundation

/// Named collection of SF Symbols which can use displayed in the `SymbolPicker` view.
public struct SymbolGroup {
    var name: String
    var symbols: [String]
    var sections: [(section: String, symbols: [String])]
    
    /// Read a resource text file into an array of strings (split by new line in text file).
    /// Expects each line to contain the `systemName` for SF Symbols.
    private func fetchSymbols(_ filename: String) -> [String] {
        guard let path = Bundle.module.path(forResource: filename, ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            return []
        }
        return content
            .split(separator: "\n")
            .map({ String($0) })
    }
    
    /// Read a resource text file into an array of strings (split by new line in text file).
    /// Group each symbols into sections divided by `##`
    /// Expects each line to contain the `systemName` for SF Symbols.
    private func extractSections(from symbols: [String]) -> [(section: String, symbols: [String])] {
        var sections: [(section: String, symbols: [String])] = []
        var currentSection = ""
        var currentSymbols: [String] = []

        for line in symbols {
            if line.hasPrefix("## ") {
                if !currentSymbols.isEmpty {
                    sections.append((section: currentSection, symbols: currentSymbols))
                }
                
                currentSection = line.replacingOccurrences(of: "## ", with: "").trimmingCharacters(in: .whitespaces)
                currentSymbols = []
            } else if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                currentSymbols.append(line)
            }
        }
        
        if !currentSymbols.isEmpty {
            sections.append((section: currentSection, symbols: currentSymbols))
        }

        return sections
    }

    
    /// Initilise `SymbolGroup` using an array of symbol names (in string form).
    /// Useful when trying to make a small custom set of symbols for a specific use case.
    public init(_ name: String = "Symbols", symbols: [String]) {
        self.name = name
        self.symbols = symbols
        self.sections = []
    }
    
    /// Initialise `SymbolGroup` using a `.txt` file in the `Resources` directory.
    /// Useful when making a large custom set of symbols which are used extensively.
    public init(_ name: String = "Symbols", filename: String) {
        self.name = name
        self.symbols = []
        self.sections = []
        self.symbols = self.fetchSymbols(filename)
        self.sections = self.extractSections(from: symbols)
    }
}

/// All symbols in the SF Symbols v4 catalogue.
public let DefaultSymbols = SymbolGroup(filename: "SFSymbols")
