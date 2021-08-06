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
            case .mixed:
                assertionFailure("No such thing as mixed")
            default:
                assertionFailure("Don't know how to handle: (sender.state)")
        }
    }
    private var fixedZoom: Bool = false {
        didSet {
            print("Force fixed zoom now")
        }
    }
    
    @IBAction func toggleDefaultFullScreen(_ sender: NSMenuItem) {
        switch sender.state {
            case .on:
                self.defaultFullScreen = false
                sender.state = .off
            case .off:
                self.defaultFullScreen = true
                sender.state = .on
            case .mixed:
                assertionFailure("No such thing as mixed")
            default:
                assertionFailure("Don't know how to handle: (sender.state)")
        }
    }
    
    private var defaultFullScreen: Bool = false {
        didSet {
            print("Force default full now")
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
