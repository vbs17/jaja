
import UIKit
import AVFoundation


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    let engine = AVAudioEngine()
    var sound:NSURL!
    
    
    func record() {
        do {
            let documentDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            let filePath = NSURL(fileURLWithPath: documentDir + "/sample.caf")
            sound = filePath
            let format = AVAudioFormat(commonFormat: .PCMFormatFloat32  , sampleRate: 44100, channels: 1 , interleaved: true)
            let audioFile = try AVAudioFile(forWriting: filePath, settings: format.settings)
       
            let inputNode = engine.inputNode!
            inputNode.installTapOnBus(0, bufferSize: 4096, format: nil) { (buffer, when) in
                do {
                    try audioFile.writeFromBuffer(buffer)
                } catch let error {
                    print("audioFile.writeFromBuffer error:", error)
                }
            }
            
            do {
                try engine.start()
            } catch let error {
                print("engine.start() error:", error)
            }
        } catch let error {
            print("AVAudioFile error:", error)
        }
    }

    @IBAction func stop(sender: AnyObject) {
        engine.stop()
        let set = self.storyboard?.instantiateViewControllerWithIdentifier("M") as! MViewController
        set.sound = self.sound
        self.presentViewController(set, animated: true, completion: nil)
        
    }
    
    @IBAction func recGo(sender: AnyObject) {
        record()
    }
  }

