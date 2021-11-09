//
//  NSAttributedStringExtensions.swift
//  BanchExample
//
//  Created by User on 9.11.21.
//

import Foundation

extension NSAttributedString {
    convenience init? (fileName: String, fileType: String, documentType: NSAttributedString.DocumentType) {
        guard let htmlFile = Bundle.main.path(forResource: fileName, ofType: fileType) else {
            print("\n LOG NSAttributedString: don't have file")
            return nil
        }

        guard let html = try? String(contentsOfFile: htmlFile, encoding: .utf8) else {
            print("\n LOG NSAttributedString: don't have string")
            return nil
        }

        let data = html.data(using: .utf16) ?? Data()

        do {
            try self.init(data: data, options: [.documentType: documentType], documentAttributes: nil)
        } catch (let error) {
            print("\n LOG NSAttributedString error: \(error.localizedDescription)")
            return nil
        }
    }
}
