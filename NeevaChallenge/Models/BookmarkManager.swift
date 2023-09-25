//
//  BookmarkManager.swift
//  NeevaChallenge
//
//  Created by Toni Tran on 3/19/21.
//

import Foundation

class BookmarkManager {
    private var bookmarks : [String] = []
    
    func addBookmark(urlString: String) -> Void {
        if (!isBookMarked(urlString: urlString) && urlString != K.blankURL) {
            bookmarks.insert(urlString, at: 0)
        }
    }
    
    func deleteBookmark(index: Int) -> Void {
        bookmarks.remove(at: index)
    }
    
    func isBookMarked(urlString : String) -> Bool {
        return bookmarks.contains(urlString)
    }
    
    func getBookmarks() -> [String] {
        return bookmarks
    }
}
