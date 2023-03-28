import RxSwift

//Subject는 Observable이자, obserble인 것.

let disposeBag = DisposeBag()

print("---------publishSubject--------")
let publishSubject = PublishSubject<String>() //publishSubject 생성.

//observable의 특징: 이벤트를 내뱉을 수 있음.
publishSubject.onNext("1.여러분 안녕하세요.") //하나의 string내뱉기

//첫번째 구독자 : 첫번째 이벤트가 발생한 바로 다음부터 구독을 시작함.
let 구독자1 = publishSubject
    .subscribe(onNext: { //구독하기
        print("첫번째 구독자: \($0)") //구독한 내용 프린트
    })

//구독을 시작한 다음 또 이벤트를 내뱉기
publishSubject.onNext("2.들리세요?")
publishSubject.on(.next("3.안들리시나요? "))

구독자1.dispose() //수동으로 구독자 dispose

//두번째 구독자 : 앞에 세가지 이벤트를 방출한 뒤에 구독을 시작함.
let 구독자2 = publishSubject
    .subscribe(onNext: {
        print("두번째 구독자: \($0)")
    })
//네번째 이벤트 : 마지막 이벤트 발생 후 컴플리트.
publishSubject.onNext("4.여보세요")
publishSubject.onCompleted()
//완료 후 5번째 이벤트 방출
publishSubject.onNext("5. 끝났나요?")

구독자2.dispose()

//세번째 구독자 : 바라보고 있는 observable이 이미 complete 되었으므로 찍히지 않음.
publishSubject
    .subscribe {
        print("세번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

publishSubject.onNext("6. 찍힐까요?")



print("---------behaviorSubject--------")
//Error 커스텀
enum SubjectError: Error {
    case error1
}
//behaviorSubject는 반드시 초기값을 가짐.
let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")

behaviorSubject.onNext("1. 첫번째값")

behaviorSubject.subscribe{
    print("첫번째 구독:", $0.element ?? $0) //element값이 없다면 어떤 이벤트를 받았는지 표현
    
}
.disposed(by: disposeBag)

//구독자가 생긴 이후에 Error발생.
//behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe{
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

//behaviorSubject는 value라는것을 제공받음.
let value = try? behaviorSubject.value()
print(value) //결과로는 첫번째값을 가져옴. rx에선 잘 사용하진 않음.

print("---------ReplaySubject--------")
//두개의 버퍼사이즈를 가진 replaySubject 생성.
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. 여러분")
replaySubject.onNext("2. 힘내세요")
replaySubject.onNext("3. 어렵지만")

replaySubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4. 할수 있어요.")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()
replaySubject.subscribe {
    print("세번째 구독:", $0.element ?? $0)
    //이미 dispose되었는데 에러가 발생되니 rxswift에서 에러 발생.
}
.disposed(by: disposeBag)

