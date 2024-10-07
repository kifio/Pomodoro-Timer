//
//  MenuManager.swift
//  Pomodoro Timer
//
//  Created by Иван Мурашов on 07.10.2024.
//

import AppKit

class MenuManager: NSObject, NSMenuDelegate {
    
    let statusMenu: NSMenu
    
    var menuISOpen: Bool = false
    var tasks = Task.sampleTasksWithStatus
    
    let itemsBeforeTasks = 2
    let itemsAfterTasks = 6
    
    init(statusMenu: NSMenu) {
        self.statusMenu = statusMenu
        super.init()
    }

    func menuWillOpen(_ menu: NSMenu) {
        menuISOpen = true
    }
    
    func menuDidClose(_ menu: NSMenu) {
        menuISOpen = false
        clearTasksFromMenu()
    }
    
    func clearTasksFromMenu() {
        let stopAtIndex = statusMenu.items.count - itemsAfterTasks
        
        for _ in itemsBeforeTasks ..< stopAtIndex {
            statusMenu.removeItem(at: itemsBeforeTasks)
        }
    }
}
