//
//  ViewController.swift
//  ImgDup
//
//  Created by Anja Berens on 1/15/21.
//

import Cocoa

// Keyboard bindings
private let kLeftArrow: UInt16 = 0x7B
private let kRightArrow: UInt16 = 0x7C

class ViewController: NSViewController {
    @IBOutlet weak var imageView: NSImageView!
    
    var images = [URL]()
    var currentIndex = 0
    var monitor: Any?
    
    @IBAction func toggleFixedZoom(_ sender: NSMenuItem) {
        switch sender.state {
            case .on:
                self.fixedZoom = false
                sender.state = .off
            case .off:
                self.fixedZoom = true
                sender.state = .on
            default:
                assertionFailure("Don't know how to handle: \(sender.state)")
        }
    }
    private var fixedZoom: Bool = false {
        didSet {
            print("Force fixed zoom now")
        }
    }
    
    @IBAction func toggleDefaultFullScreen(_ sender: NSMenuItem) {
        let defaults = UserDefaults.standard
        switch sender.state {
            case .on:
                defaults.set(false, forKey: "ForceFullScreen")
                sender.state = .off
            case .off:
                defaults.set(true, forKey: "ForceFullScreen")
                sender.state = .on
            default:
                assertionFailure("Don't know how to handle: \(sender.state)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        
        guard let directory = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first else {
            return
        }

        guard let contents = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
            return
        }

        images = contents.filter { !$0.hasDirectoryPath }
        
        // First load
        if let first = images.first {
            imageView.image = NSImage(contentsOf: first)
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        let menuItem = NSApp.mainMenu?.item(withTitle: "View")?.submenu?.item(withTitle: "Default Full Screen")
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "ForceFullScreen") {
            menuItem?.state = .on
            view.window!.toggleFullScreen(true)
        } else {
            menuItem?.state = .off
        }
        
        // Keyboard bits
        monitor = NSEvent.addLocalMonitorForEvents(
            matching: .keyDown
        ) {
            event -> NSEvent? in
            if event.keyCode ==  kRightArrow {
                self.forward()
            } else if event.keyCode == kLeftArrow {
                self.backward()
            }
            return event
        }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }

    func forward() {
        guard images.count > 0 else {return}
        
        currentIndex += 1
        if currentIndex >= images.count {
            currentIndex = 0
        }
        
        self.imageView.image = NSImage(contentsOf: images[currentIndex])
    }
    
    func backward() {
        guard images.count > 0 else {return}
        
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = images.count - 1
        }
        
        self.imageView.image = NSImage(contentsOf: images[currentIndex])
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
