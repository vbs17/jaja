

import UIKit
import AVFoundation


class MViewController: UIViewController {

    
    let player = AVAudioPlayerNode()
    let audioEngine = AVAudioEngine()
    var sound:NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func play(sender: AnyObject) {
        play()
    }
    
    
    func play() {
        if let url = sound {
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


    
}
