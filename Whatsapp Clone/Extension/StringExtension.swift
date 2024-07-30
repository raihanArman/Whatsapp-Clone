//
//  StringExtension.swift
//  Whatsapp Clone
//
//  Created by Raihan Arman on 30/07/24.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool { return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}
