import RxSwift

let disposeBag = DisposeBag()

print("-------igonreElements-------")

let 취침모드 = PublishSubject<String>()

취침모드
    .ignoreElements()
    .subscribe { _ in
        print("아침")
    }
    .disposed(by: disposeBag)

취침모드.onNext("알람울리기")
취침모드.onNext("알람울리기")
취침모드.onNext("알람울리기") //결과 : 아무것도 이뤄지지 않음.igonreElements는 Next이벤트를 무시함. Complete나 Error와 같은 정지 이벤트는 허용.

취침모드.onCompleted() //아침 출력

print("-------elementAt-------")

let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("알람") //index0
두번울면깨는사람.onNext("알람") //index1
두번울면깨는사람.onNext("기상") //index2
두번울면깨는사람.onNext("알람") //index3

print("-------filter-------")

Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .filter{ $0 % 2 == 0 }
    .subscribe(onNext : {
        print($0)
    })
    .disposed(by: disposeBag)


print("-------skip-------")

Observable.of(1, 2, 3, 4, 5)
    .skip(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)



print("-------skipwhile-------")
Observable.of(1, 2, 3, 4, 5)
    .skip(while: {
        $0 != 3 //3이 아닐때까지 skip후 방출
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------skipUntil-------")

let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()

손님
    .skip(until: 문여는시간) //문열기 전까지 skip
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

손님.onNext("1")
손님.onNext("2")
문여는시간.onNext("open")
손님.onNext("3")

print("-------take-------")


Observable.of(1, 2, 3, 4, 5)
    .take(3) //3까지만 출력됌
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------takeWhile-------")
Observable.of(1, 2, 3, 4, 5)
    .take(while: {
        $0 != 3 // 3이 아닐때까지 방출
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------enumerated-------")
Observable.of(1, 2, 3, 4, 5)
    .enumerated() //방출된 index를 참고하고 싶을때 씀.
    .takeWhile {
        $0.index < 3 //index가 3 이하인 엘리먼트들을 방출
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------takeUntil-------")

let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청
    .take(until: 신청마감)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

수강신청.onNext("C언어")
수강신청.onNext("Java")
신청마감.onNext("수강신청기간이 마감되었습니다.")
수강신청.onNext("Swift")

print("-------distinctUntilChanged-------")

Observable.of("이","이","석","석","석","원","입","입","니","다","다")
    .distinctUntilChanged()  //연달아 반복되는 단어를 하나로 압축.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
