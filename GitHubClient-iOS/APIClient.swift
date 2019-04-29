//
//  APIClient.swift
//  GitHubClient-iOS
//
//  Created by 中山翼 on 2019/04/30.
//  Copyright © 2019 Tsubasa Nakayama. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
import Alamofire

struct RepoEntity: Mappable {
    var name: String?
    var language: String?
    var star: Int?

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        language <- map["language"]
        star <- map["stargazers_count"]
    }
}

class APIClient {
    
    private let disposeBag = DisposeBag()
    
    func call() {
       create(url: "https://api.github.com/users/bassaer/repos")
        .subscribe(
            onNext: { entites in
                for entity in entites {
                    log.debug(entity.name!)
                }
            },
            onError: { error in
                log.debug("Error!!!")
                log.debug(error.localizedDescription)
            },
            onCompleted: {
                log.debug("Completed!!!")
            }
        )
        .disposed(by: disposeBag)
    }
    
    func create(url: String) -> Observable<[RepoEntity]> {
        return Observable<[RepoEntity]>.create { observer in
            let request = Alamofire.request(url).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let entities = Mapper<RepoEntity>().mapArray(JSONObject: data) {
                        observer.onNext(entities)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {request.cancel()}
        }
    }
}
