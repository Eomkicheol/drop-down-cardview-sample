//
//  CardViewModel.swift
//  RxSwiftExample
//
//  Created by 엄기철 on 2019/06/23.
//  Copyright © 2019 Hanzo. All rights reserved.
//


import RxViewBinder
import RxSwift
import RxCocoa

final class CardViewModel: ViewBindable {
    // MARK: Constants
    private enum Constants {}
    
    // MARK: Command
    enum Command {
        
    }
    
    // MARK: Action
    struct Action {
        
    }
    
    // MARK: State
    struct State {
        
        init(action: Action) {
            
        }
    }
    
    // MARK: Properties
    let action = Action()
    lazy var state = State(action: action)
    
    
    init() {
    }
    
    deinit {
        print(self)
    }
    
    func binding(command: Command) {}
    
}

