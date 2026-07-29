import SwiftUI
import AVFoundation

struct VideoBackgroundView: UIViewRepresentable {
    let videoName: String
    let videoType: String

    func makeUIView(context: Context) -> UIView {
        return QueuePlayerUIView(videoName: videoName, videoType: videoType)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

class QueuePlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?

    init(videoName: String, videoType: String) {
        super.init(frame: .zero)
        guard let path = Bundle.main.path(forResource: videoName, ofType: videoType) else { return }
        let fileURL = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: fileURL)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)

        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        playerLayer.player = queuePlayer
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)

        queuePlayer.play()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
