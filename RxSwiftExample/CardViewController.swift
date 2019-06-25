//
//  CardViewController.swift
//  RxSwiftExample
//
//  Created by 엄기철 on 2019/06/23.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

import SnapKit
import RxViewBinder
import RxSwift
import RxCocoa

final class  CardViewController: BaseViewController, BindView {
    
    typealias ViewBinder = CardViewModel
    
    // MARK: Constants
    private enum Constants {
    }
    
    // MARK: Properties
    
    // MARK: UI Properties
    let handleArea: UIView  = {
        let view = UIView()
        view.backgroundColor = .red
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
        [handleArea].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        handleArea.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    func command(viewBinder: CardViewModel) {
        super.command()
        
    }
    
    func state(viewBinder: CardViewModel) {
        super.state()
    }
}


