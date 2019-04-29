//
//  GitHub.swift
//  GitHubClient-iOS
//
//  Created by 中山翼 on 2019/04/29.
//  Copyright © 2019 Tsubasa Nakayama. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class GitHubViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just(
            (0..<30).map{"\($0)"}
        )
        

        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { value in
                log.debug("tapped \(value)")
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                log.debug("Tapped detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
}
