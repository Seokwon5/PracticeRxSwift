import Foundation
import RxSwift

print("----------Just------------") //element 하나만 방출.
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("----------arr1------------")
Observable<Int>.of(1,2,3,4,5)
    .subscribe(onNext: {
        print($0)
    })

print("-----------arr2-----------")
Observable.of([1,2,3,4,5]) //just와 같음.
    .subscribe(onNext: {
        print($0)
    })

print("-----------From-----------") // Array만 가능. 하나씩 꺼내어 방출
Observable.from([1,2,3,4,5])
    .subscribe(onNext: {
        print($0)
    })

print("-----------subScibe1-----------") //onNext안했을 경우.
Observable.of(1,2,3)
    .subscribe {
        print($0)
    }

print("-----------subScibe2-----------") //element값만을 방출.
Observable.of(1,2,3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

print("-----------subScibe3-----------") //element값만을 방출.
Observable.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    })

print("-----------Range-----------")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2*\($0)=\(2*$0)")
    })
         
let disposeBag = DisposeBag()
Observable.of(1,2)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

print("-----------create-----------")

enum MyError : Error {
    case anError
}

Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)                //observer는 1을 내뱉는다
    observer.onError(MyError.anError) //위에서 만든 에러를 내뱉는다.
    observer.onCompleted()            //컴플리트함.
    observer.onNext(2)                //2를 내뱉는다.
    return Disposables.create()       //리턴
}
.subscribe(
    onNext: {
        print($0) //엘리멘트 방출
    },
    onError: {
        print($0.localizedDescription) //해당 에러 표현
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag) //메모리 누수를 방지하기 위함.


print("-----------defered-----------") //Observable을 감싸는 Observable
Observable.deferred{
    Observable.of(1,2,3)
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)


print("-----------defered2-----------")

var back: Bool = false

let factory : Observable<String> = Observable.deferred {
    back = !back
    
    if back {
        return Observable.of("앞")
    }else {
        return Observable.of("뒤")
    }
}

for _ in 0...3 {
    factory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}
    
