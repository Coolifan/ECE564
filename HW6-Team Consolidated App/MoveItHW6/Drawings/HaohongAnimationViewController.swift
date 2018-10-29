import UIKit
import AVKit

class HaohongAnimationViewController: UIViewController {

    var player:AVAudioPlayer = AVAudioPlayer()
    @IBOutlet weak var imageView: UIImageView!
    var ryu : [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ryu = createImageArray(total: 14, prefix: "ryu-hadouken")
        animate(imageView: imageView, images: ryu, duration: 2.0)
        // Do any additional setup after loading the view.
        playMusic(name: "Haohong_bgm", type: "mp3")
    }
    
    func playMusic(name: String, type: String) {
        do{
            let audioPath = Bundle.main.path(forResource: name, ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        } catch {}
        player.play()
    }
    
    func createImageArray(total: Int, prefix: String) -> [UIImage] {
        var imageArray : [UIImage] = []
        for i in 0..<total {
            let imageURL = "\(prefix)-\(i)"
            let image = UIImage(named: imageURL)!
            imageArray.append(image)
        }
        return imageArray
    }
    
    func animate(imageView: UIImageView, images: [UIImage], duration: Double) {
        imageView.animationImages = images
        imageView.animationDuration = duration
        self.imageView.startAnimating()
        UIView.animate(withDuration: 4, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            let grow = CGAffineTransform(scaleX: 1.3, y: 1.3)
            let translate = CGAffineTransform(translationX: 0, y: -50)
            let angle = CGFloat(-30)
            let rotate = CGAffineTransform(rotationAngle: angle)
            let trans = grow.concatenating(translate.concatenating(rotate))
            self.imageView.transform = trans
        }) { (_) in
            self.ryu = self.createImageArray(total: 9, prefix: "ryu-kick")
            self.imageView.stopAnimating()
            self.imageView.animationImages = self.ryu
            self.imageView.startAnimating()
            UIView.animate(withDuration: 2, delay: 2, options: .curveEaseInOut, animations: {
                self.imageView.transform = CGAffineTransform(translationX: 150, y: 0)
            }, completion: { (_) in
                
            })
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
