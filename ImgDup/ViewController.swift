//
//  ViewController.swift
//  ImgDup
//
//  Created by Anja Berens on 1/15/21.
//

import Cocoa

private let kSpaceBar: UInt16 = 0x31

class ViewController: NSViewController {
    @IBOutlet weak var imageView: NSImageView!
    var images = [URL]()
    var currentIndex = 0
    var monitor: Any?
    
    
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
            if event.keyCode == kSpaceBar {
                self.forward()
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
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
