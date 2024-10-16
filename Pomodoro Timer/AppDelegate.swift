//
//  AppDelegate.swift
//  Pomodoro Timer
//
//  Created by Иван Мурашов on 04.10.2024.
//

import Cocoa
import AppKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    var menuManager: MenuManager?
    @IBOutlet weak var statusMenu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )
        
        statusItem?.menu = statusMenu
        statusItem?.button?.title = "Pomodoro"
        statusItem?.button?.imagePosition = .imageLeading
        statusItem?.button?.image = NSImage(
            systemSymbolName: "timer",
            accessibilityDescription: "Pomodoro"
        )
        
        statusItem?.button?.font = NSFont.monospacedDigitSystemFont(
            ofSize: NSFont.systemFontSize,
            weight: .regular
        )
        
        menuManager = MenuManager(statusMenu: statusMenu)
        statusMenu.delegate = menuManager
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

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
        showTasksInMenu()
    }
    
    func menuDidClose(_ menu: NSMenu) {
        menuISOpen = false
        clearTasksFromMenu()
    }
    
    func showTasksInMenu() {
        var index = itemsBeforeTasks
        var taskCounter = 0
        
        for task in tasks {
            let item = NSMenuItem()
            item.title = task.title
            
            statusMenu.insertItem(item, at: index)
            index += 1
            taskCounter += 1
            
            if taskCounter.isMultiple(of: 4) {
                statusMenu.insertItem(NSMenuItem.separator(), at: index)
                index += 1
            }
        }
    }
    
    func clearTasksFromMenu() {
        let stopAtIndex = statusMenu.items.count - itemsAfterTasks
        
        for _ in itemsBeforeTasks ..< stopAtIndex {
            statusMenu.removeItem(at: itemsBeforeTasks)
        }
    }
}

class TaskView: NSView {
    var task: Task?

    var imageView: NSImageView
    var titleLabel: NSTextField
    var infoLabel: NSTextField
    var progressBar: NSProgressIndicator

    override init(frame frameRect: NSRect) {
        imageView = NSImageView(frame: NSRect(x: 10, y: 10, width: 20, height: 20))
        imageView.imageScaling = .scaleProportionallyUpOrDown
        
        titleLabel = NSTextField(frame: NSRect(x: 40, y: 20, width: 220, height: 16))
        titleLabel.backgroundColor = .clear
        titleLabel.isBezeled = false
        titleLabel.isEditable = false
        titleLabel.font = NSFont.systemFont(ofSize: 14)
        titleLabel.lineBreakMode = .byTruncatingTail

        infoLabel = NSTextField(frame: NSRect(x: 40, y: 20, width: 220, height: 14))
        infoLabel.backgroundColor = .clear
        infoLabel.isBezeled = false
        infoLabel.isEditable = false
        infoLabel.font = NSFont.systemFont(ofSize: 11)
        
        progressBar = NSProgressIndicator(frame: NSRect(x: 40, y: 20, width: 220, height: 14))
        progressBar.minValue = 0
        progressBar.maxValue = 100
        progressBar.isIndeterminate = false

        super.init(frame: frameRect)

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(progressBar)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if let task = task {
            imageView.image = NSImage(
                systemSymbolName: task.status.iconName,
                accessibilityDescription: task.status.statusText
            )
            
            imageView.contentTintColor = task.status.textColor
            
            titleLabel.stringValue = task.title
            titleLabel.textColor = task.status.textColor
            
            infoLabel.stringValue = task.status.statusText
            infoLabel.textColor = task.status.textColor
            
            switch task.status {
            case .notStarted:
                progressBar.isHidden = true
            case .inProgress:
                progressBar.doubleValue = task.progressPercent
                progressBar.isHidden = false
            case .complete:
                progressBar.isHidden = true
            }
        }
    }
}
