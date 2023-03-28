import RxSwift
import Foundation

let disposeBag = DisposeBag()

enum TraitsError : Error {
    case single
    case maybe
    case completable
}

//single
Single<String>.just("토레스")
    .subscribe(
    //syccess는 Next + Completed이다. 방출 후 바로 종료.
    onSuccess: {
        print($0)
    },
    onFailure: {
        print("error: \($0)")
    },
    onDisposed: {
        print("영입 완료")
    }
    )
    .disposed(by: disposeBag)


//Observable<String>.just("토레스")
//    .subscribe(
//    onNext: {},
//    onError: {},
//    onCompleted: {},
//    onDisposed: {}
//    )
//    .disposed(by: disposeBag)

Observable<String>.just("제라드")
    .asSingle()
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("영입 완료")
        }
    )
    .disposed(by: disposeBag)

print("----------Single of JsonDeCoder--------------")

struct SomeJSON : Decodable {
    let name: String
}

enum JsonError : Error {
    case decodingError
}

let json1 = """
    {"name" : "Seokwon"}
"""

let json2 = """
    {"my_name" : "Naymar"}
"""

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
        else {
            observer(.failure(JsonError.decodingError))
            return Disposables.create()
        }
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

 
print("------------Maybe1------------")

Maybe<String>.just("손흥민")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onError: {
            print($0)
        },
        onCompleted: {
           print("complete")
        },
        onDisposed: {
            print("disposed")
        }
    )

