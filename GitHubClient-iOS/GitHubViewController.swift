//
//  GitHub.swift
//  GitHubClient-iOS
//
//  Created by 中山翼 on 2019/04/29.
//  Copyright © 2019 Tsubasa Nakayama. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftUtilities
import RxCocoa


class GitHubViewController: UIViewController {
    
    let url = "https://api.github.com/users/bassaer/repos?sort=pushed"
    
    @IBOutlet weak var tableView: UITableView!
    var activityIndicatorView = UIActivityIndicatorView()
    let disposeBag = DisposeBag()
    let client = APIClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = ActivityIndicator()
        let repos = client.create(url: self.url)
            .trackActivity(indicator)

        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .green
        
        view.addSubview(activityIndicatorView)
        
        indicator.asDriver()
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        repos
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element.name
                cell.detailTextLabel?.text = element.language
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(RepoEntity.self)
            .subscribe(
                onNext: { value in
                    log.debug("tapped \(value)")
                })
           .disposed(by: disposeBag)
    }
}
