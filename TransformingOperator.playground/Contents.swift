import RxSwift
import Foundation

let disposeBag = DisposeBag()

print("-------toArray-------")
Observable.of("A","B","C") //just([ ]) 와 같다. 싱글 배열로 변환.
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------Map-------")
Observable.of(Date())
    .map { date -> String in
        let dateFommater = DateFormatter()
        dateFommater.dateFormat = "yyyy-MM-dd"
        dateFommater.locale = Locale(identifier: "ko-KR")
        return dateFommater.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------flatMap-------")
 
