//
//  PrivacyParser.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 20.07.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

extension String {
    func replacePattern(_ pattern: String, with template: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return self }
        
        let range = NSRange(location: 0, length: characters.count)
        let replaced = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: template)
        
        return replaced
    }
    
    func strippedPrefix(count: Int = 1) -> String {
        let stripIndex = index(startIndex, offsetBy: count)
        
        return substring(from: stripIndex)
    }
}

protocol MarkdownParser {
    func outputParsed(markdown: [String]) -> String
}

struct HTMLOutputParser: MarkdownParser {
    
    private static let template = [
        "<!DOCTYPE html>\n" +
        "<html>\n" +
        "<head>\n" +
        "  <title>Let Swift - Privacy policy</title>\n" +
        "  <style type=\"text/css\">\n" +
        "    body {\n" +
        "      font-family: sans-serif;\n" +
        "    }\n" +
        "    #policy {\n" +
        "      padding-top: 2%;\n" +
        "      padding-right: 10%;\n" +
        "      padding-bottom: 2%;\n" +
        "      padding-left: 10%;\n" +
        "    }\n" +
        "    h1 {\n" +
        "      padding-bottom: 10px;\n" +
        "    }\n" +
        "    h2 {\n" +
        "      padding-left: 10px;\n" +
        "    }\n" +
        "    h3 {\n" +
        "      padding-left: 20px;\n" +
        "    }\n" +
        "    p {\n" +
        "      padding-left: 30px;\n" +
        "      padding-bottom: 10px;\n" +
        "    }\n" +
        "    a, a:visited {\n" +
        "      color: blue;\n" +
        "    }\n" +
        "  </style>\n" +
        "</head>\n" +
        "<body>\n" +
        "  <div id=\"policy\">\n",
        "\n  </div>\n" +
        "</body>\n" +
        "</html>"
    ]
    
    private static let parseRules = [
        (markdown: "# ", opening: "<h1>", closing: "</h1>"),
        (markdown: "## ", opening: "<h2>", closing: "</h2>"),
        (markdown: "### ", opening: "<h3>", closing: "</h3>"),
        (markdown: "", opening: "<p>", closing: "</p>")
    ]
    
    private func replaceLinks(line: String) -> String {
        return line.replacePattern("(https?:\\/\\/\\S*\\w)", with: "<a href=\"$1\">$1</a>")
            .replacePattern("(\\S+@\\S+)", with: "<a href=\"mailto:$1\">$1</a>")
    }
    
    private func outputLine(line: String) -> String {
        let offset = 4
        let padding = String(repeating: " ", count: offset)
        let outLine = replaceLinks(line: line)
        
        for rule in HTMLOutputParser.parseRules where outLine.hasPrefix(rule.markdown) {
            let strippedLine = outLine.strippedPrefix(count: rule.markdown.characters.count)
            
            return padding + rule.opening + strippedLine + rule.closing
        }
        
        return outLine
    }
    
    func outputParsed(markdown: [String]) -> String {
        let newLines = markdown.map(outputLine).joined(separator: "\n")
        
        return HTMLOutputParser.template[0] + newLines + HTMLOutputParser.template[1]
    }
}

struct PlistOutputParser: MarkdownParser {
    
    private static let template = [
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
        "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n" +
        "<plist version=\"1.0\">\n" +
        "<dict>\n" +
        "\t<key>PreferenceSpecifiers</key>\n" +
        "\t<array>\n" +
        "\t\t<dict>\n" +
        "\t\t\t<key>Title</key>\n" +
        "\t\t\t<string>Privacy Policy</string>\n" +
        "\t\t\t<key>FooterText</key>\n" +
        "\t\t\t<string>",
        "</string>\n" +
        "\t\t\t<key>Type</key>\n" +
        "\t\t\t<string>PSGroupSpecifier</string>\n" +
        "\t\t</dict>\n" +
        "\t</array>\n" +
        "</dict>\n" +
        "</plist>"
    ]
    
    private func outputLine(line: String) -> String {
        guard !line.hasPrefix("# ") else { return "" }
        
        let newLine = "\n"
        
        for prefix in ["## ", "### "] where line.hasPrefix(prefix) {
            return line.strippedPrefix(count: prefix.characters.count) + newLine
        }
        
        return line + newLine
    }
    
    func outputParsed(markdown: [String]) -> String {
        let newLines = markdown.map(outputLine).joined(separator: "\n").trimmingCharacters(in: .newlines)
        
        return PlistOutputParser.template[0] + newLines + PlistOutputParser.template[1]
    }
}

let parsers: [String: MarkdownParser] = [
    "html": HTMLOutputParser(),
    "plist": PlistOutputParser()
]

func parseAndOutput(path: String, parser: MarkdownParser) -> String? {
    let url = URL(fileURLWithPath: path)
    guard let fileContents = try? String(contentsOf: url) else { return nil }
    
    let lines = fileContents.components(separatedBy: CharacterSet.newlines).filter { !$0.isEmpty }
    
    return parser.outputParsed(markdown: lines)
}

func main() {
    guard CommandLine.arguments.count == 3 else {
        print("Provide parser type and markdown path as an argument")
        return
    }
    
    let type = CommandLine.arguments[1]
    let path = CommandLine.arguments[2]
    
    guard let parser = parsers[type] else {
        print("Invalid parser type (not \(parsers.keys.joined(separator: ", ")))")
        return
    }
    
    guard let parsedOutput = parseAndOutput(path: path, parser: parser) else {
        print("Failed to open \(path)")
        return
    }
    
    print(parsedOutput)
}

main()
