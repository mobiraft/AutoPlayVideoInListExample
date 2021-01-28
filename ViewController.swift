//
//  ViewController.swift
//  PrettyConstraintsExamples
//
//  Created by Hardik Parmar on 30/10/20.
//

import UIKit
import PrettyConstraints
import AVKit

class ViewController: UIViewController {
    
    let containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.footerReferenceSize = .zero
        layout.headerReferenceSize = .zero
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.setUpDataSource()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playFirstVisibleVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playFirstVisibleVideo(false)
    }
    
    func setUpUI() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(containerView)
        
        containerView.applyConstraints(.fitInSafeArea(self.view.safeAreaLayoutGuide))
        
        containerView.addSubview(collectionView)
        
        collectionView.applyConstraints(.fitInView(containerView))
        
    }
    
    var dataSource:[String] = []
    
    func setUpDataSource() {
        dataSource = [
            "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
            "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
            "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
            "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
            "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
            "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4"
        ]
        
        collectionView.reloadData()
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? VideoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(dataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 240)
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        playFirstVisibleVideo()
    }
    
}

extension ViewController {
    
    func playFirstVisibleVideo(_ shouldPlay:Bool = true) {
        // 1.
        let cells = collectionView.visibleCells.sorted {
            collectionView.indexPath(for: $0)?.item ?? 0 < collectionView.indexPath(for: $1)?.item ?? 0
        }
        // 2.
        let videoCells = cells.compactMap({ $0 as? VideoCollectionViewCell })
        if videoCells.count > 0 {
            // 3.
            let firstVisibileCell = videoCells.first(where: { checkVideoFrameVisibility(ofCell: $0) })
            // 4.
            for videoCell in videoCells {
                if shouldPlay && firstVisibileCell == videoCell {
                    videoCell.play()
                }
                else {
                    videoCell.pause()
                }
            }
        }
    }
    
    func checkVideoFrameVisibility(ofCell cell: VideoCollectionViewCell) -> Bool {
        var cellRect = cell.containerView.bounds
        cellRect = cell.containerView.convert(cell.containerView.bounds, to: collectionView.superview)
        return collectionView.frame.contains(cellRect)
    }
    
}
