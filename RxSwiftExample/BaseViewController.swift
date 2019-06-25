//
//  BaseViewController.swift
//  RxSwiftExample
//
//  Created by 엄기철 on 2019/06/23.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: Properties
    private var baseDisposeBag = DisposeBag()
    
    private(set) var didSetupConstraints = false
    private(set) var didSetupSubViews = false
    
    private var scrollViewOriginalContentInsetAdjustmentBehaviorRawValue: Int?
    
    // MARK: UI Properties
    var backBarButtonImage: UIImage? = nil {
        didSet {
            self.customBackBarButtonItem(image: backBarButtonImage)
        }
    }
    
    // MARK: Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        
        self.view.setNeedsUpdateConstraints()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //fix is 11 scroll view bug
        if #available(iOS 11, *) {
            if let scrollView = self.view.subviews.first as? UIScrollView {
                self.scrollViewOriginalContentInsetAdjustmentBehaviorRawValue = scrollView.contentInsetAdjustmentBehavior.rawValue
                scrollView.contentInsetAdjustmentBehavior = .never
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navi = self.navigationController, navi.viewControllers.first != self {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        if #available(iOS 11, *) {
            if let scrollView = self.view.subviews.first as? UIScrollView,
                let rawValue = self.scrollViewOriginalContentInsetAdjustmentBehaviorRawValue,
                let behavior = UIScrollView.ContentInsetAdjustmentBehavior(rawValue: rawValue) {
                scrollView.contentInsetAdjustmentBehavior = behavior
            }
        }
    }
    
    //뷰 컨크롤의 뷰 제약조건을 업데이트 하기 위해 호출
    override func updateViewConstraints() {
        if self.didSetupConstraints == false {
            
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    //뷰컨트롤러의 뷰가 하위뷰를 표시했음을 알리기 위해 호출
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.didSetupSubViews == false {
            self.setupSubViews()
            self.didSetupSubViews = true
        }
    }
    
    
    
    // MARK: Func
    func setupConstraints() {}
    
    func setupSubViews() {}
    
    func command() {}
    
    func state() {}
    
    private func customBackBarButtonItem(image: UIImage?) {
        let itme = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
            //UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain)
        self.navigationItem.leftBarButtonItem = itme
        
        itme.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.baseDisposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension BaseViewController: UIGestureRecognizerDelegate {
    
}


extension BaseViewController {
    func bottomTabBarHidden (_ checked: Bool) {
        UIView.animate(withDuration: 0.5) {
            if checked {
                self.tabBarController?.tabBar.alpha = 0
            } else {
                self.tabBarController?.tabBar.alpha = 1
            }
        }
    }
}
