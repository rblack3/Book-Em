//
//  OpenLibraryEndpoint.swift
//  midterm
//
//  Created by Hayden B on 3/4/24.
//

import Foundation

struct OpenLibraryEndpoint {
    let baseUrl = "https://openlibrary.org/works/"
    let bookId: String

    var url: URL? {
        URL(string: baseUrl + "\(bookId).json")
    }
}

