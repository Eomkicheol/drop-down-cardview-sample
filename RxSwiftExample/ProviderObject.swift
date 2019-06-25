//
//  ProviderObject.swift
//  RxSwiftExample
//
//  Created by 엄기철 on 2019/06/22.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

enum ProviderObject {
    case main
}


extension ProviderObject {
    var viewController: UIViewController {
        switch self {
        case .main:
            let viewModel = MainViewModel()
            let viewController = MainViewController(viewBinder: viewModel)
            return viewController
        }
    }
}
