//
//  VideoCollectionViewCell.swift
//  MomsVideoPlayer
//
//  Created by Hardik Parmar on 19/01/21.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let playerView:PlayerView = {
        let view = PlayerView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var url: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }
    
    func setUpUI() {
        
        self.addSubview(containerView)
        
        containerView.applyConstraints(.fitInView(self))
        
        // Setup video views
        self.containerView.addSubview(playerView)
        
        playerView.applyConstraints(.fitInView(self.containerView))
        
    }
    
    @objc
    func volumeAction(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        playerView.isMuted = sender.isSelected
        PlayerView.videoIsMuted = sender.isSelected
    }
    
    func play() {
        if let url = url {
            playerView.prepareToPlay(withUrl: url, shouldPlayImmediately: true)
        }
    }
    
    func pause() {
        playerView.pause()
    }
    
    func configure(_ videoUrl: String) {
        guard let url = URL(string: videoUrl) else { return }
        self.url = url
        playerView.prepareToPlay(withUrl: url, shouldPlayImmediately: false)
    }
}
