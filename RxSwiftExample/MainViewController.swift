//
//  MainViewController.swift
//  RxSwiftExample
//
//  Created by 엄기철 on 2019/06/22.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxViewBinder
import SnapKit

final class MainViewController: BaseViewController, BindView {
    
    typealias ViewBinder = MainViewModel
    
    // MARK: Constants
    private enum Constants {
    }
    
    // MARK: Properties
    lazy var cardView: CardViewController = {
      let cardView = CardViewController(viewBinder: CardViewModel())
        cardView.view.frame = CGRect(x: 0,
                                     y: self.view.frame.height - cardHandleAreaHeight,
                                     width: self.view.bounds.width,
                                     height: self.view.frame.height - self.statusBarHeight )
        cardView.view.clipsToBounds = true
        cardView.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(handleCardTap(recognzier:))))
        cardView.view.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                                  action: #selector(handleCardPan(recognzier:))))
        return cardView
    }()
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    var cardHeight: CGFloat {
        return self.view.frame.height > 600 ? 600 - self.statusBarHeight : 500 - self.statusBarHeight
    }
    
    let cardHandleAreaHeight: CGFloat = 65
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    // MARK: UI Properties
    let exImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "beach-2213623_1920"))
        view.contentMode = UIView.ContentMode.scaleToFill
        view.clipsToBounds = true
        return view
    }()
    
    let  visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        return view
    }()
    
    
    // MARK: Initializing
    init(viewBinder: ViewBinder) {
        defer {
            self.viewBinder = viewBinder
        }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        
    }
    
    func configureUI() {
        [exImageView ,visualEffectView].forEach {
            self.view.addSubview($0)
        }
        
        self.addChild(cardView)
        
        [cardView].forEach {
            self.view.addSubview($0.view)
        }
        
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        exImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    func command(viewBinder: MainViewModel) {
        
        
    }
    
    func state(viewBinder: MainViewModel) {
        
    }
}


extension MainViewController {
    
    @objc
    func handleCardTap(recognzier: UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeede(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan(recognzier: UIPanGestureRecognizer) {
        switch recognzier.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognzier.translation(in: self.cardView.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
          break
        }
    }
    
    func animateTransitionIfNeede(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAniimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardView.view.frame.origin.y = self.view.frame.height - self.cardHeight
                    print(self.cardView.view.frame.origin.y)
                case .collapsed:
                    self.cardView.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAniimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAniimator.startAnimation()
            runningAnimations.append(frameAniimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardView.view.layer.cornerRadius  = 12
                case .collapsed:
                    self.cardView.view.layer.cornerRadius  = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
            
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
          animateTransitionIfNeede(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil , durationFactor: 0)
        }
    }
}


