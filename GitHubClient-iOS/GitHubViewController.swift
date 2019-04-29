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


class GitHubViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    
    let client = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repositories = client.create(url: "https://api.github.com/users/bassaer/repos")
        
        repositories
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element.name
                cell.detailTextLabel?.text = element.language
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(RepoEntity.self)
            .subscribe(onNext: { value in
                log.debug("tapped \(value)")
            })
            .disposed(by: disposeBag)
    }
}
