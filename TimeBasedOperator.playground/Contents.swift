import RxSwift

let disposeBag = DisposeBag()

print("--------replay-------")
let 일기내용 = PublishSubject<String>()
let 일기장 = 일기내용.replay(1) //버퍼의 개수만큼 최근부터 불러드림.
일기장.connect() //replay를 쓸때 반드시 해줘야함.

일기내용.onNext("4월 16일")
일기내용.onNext("6월 18일")

일기장 //구독을 늦게 했음에도 가져올 수 있음
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------replayAll-------")
let DoctorStrange = PublishSubject<String>()
let TimeStone = DoctorStrange.replayAll() //전부 불러들임.
TimeStone.connect() //replay를 쓸때 반드시 해줘야함.

DoctorStrange.onNext("도르마무")
DoctorStrange.onNext("거래를 하러왔다.")

TimeStone //구독을 늦게 했음에도 가져올 수 있음
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------buffer-------")
let source = PublishSubject<String>()

var count = 0
let timer = DispatchSource.makeTimerSource()

timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
timer.setEventHandler {
    count += 1
    source.onNext("\(count)")
}
timer.resume()

source
    .buffer(timeSpan: .seconds(2),
            count: 2,
            scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
