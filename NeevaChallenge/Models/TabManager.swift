//
//  TabManager.swift
//  NeevaChallenge
//
//  Created by Toni Tran on 3/19/21.
//

import Foundation

class TabManager {
    private var tabs: [String] = ["(Empty Tab)"]
    private var currentIndex = 0
    
    func addTab() -> Void {
        tabs.insert(K.emptyTabPlaceholder, at: 0)
        currentIndex = 0
    }
    
    func updateTab(urlString: String) -> Void {
        tabs[currentIndex] = urlString
    }
    
    func updateCurrentIndex(index: Int) -> Void {
        currentIndex = index
    }
    
    func getTabs() -> [String] {
        return tabs
    }
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    func getCurrentTab() -> String {
        return tabs[currentIndex]
    }
    
    func deleteTab(index: Int) -> Void {
        if index <= currentIndex {
            if currentIndex - 1 >= 0 {
                currentIndex -= 1
            }
        }
        tabs.remove(at: index)
        if tabs.count == 0 {
            addTab()
        }
    }
}
