
import Foundation

class Counter {
    var timer: Timer?
    var callback: (() -> ())
    var delay: TimeInterval
    
    init(delay: TimeInterval, callback: (@escaping () -> Void)) {
        self.delay = delay
        self.callback = callback
    }
    
    func call() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: false)
    }
    
    @objc func timerCallback() {
        callback()
    }
}
