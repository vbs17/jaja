
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
    let player = AVAudioPlayerNode()
    let audioEngine = AVAudioEngine()

    
    func play() {
        if let url = NSBundle.mainBundle().URLForResource("sound-file", withExtension: "wav") {
            do {
                let audioFile = try AVAudioFile(forReading: url)
                audioEngine.attachNode(player)
                let mixer = audioEngine.mainMixerNode

                audioEngine.connect(player,
                                    to: mixer,
                                    format: audioFile.processingFormat)
                player.scheduleFile(audioFile, atTime: nil) {
                    print("complete")
                }
                try audioEngine.start()
                player.play()
            } catch let error {
                print(error)
            }
        } else {
            print("File not found")
        }
    }
    
    func record() {
        do {
            let documentDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            let filePath = NSURL(fileURLWithPath: documentDir + "/sample.caf")
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

    @IBOutlet weak var rec: UIButton!
    @IBAction func recGo(sender: AnyObject) {
        record()
    }
    @IBOutlet weak var all: UIButton!
    @IBAction func allGo(sender: AnyObject) {
        play()
    }

}

