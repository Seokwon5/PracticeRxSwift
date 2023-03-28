import RxSwift
import Foundation

let disposeBag = DisposeBag()


print("--------startWith--------")
let 첼시 = Observable.of("아자르", "오스카", "하베르츠")

첼시
    .enumerated() //index와 element를 분리
    .map { index, element in
        return element + "선수" + "\(index)"
    }
    .startWith("무리뉴") //이거먼저 방출
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
 
print("--------concat1--------")
let 첼시선수 = Observable<String>.of("아자르", "오스카", "하베르츠")
let 감독 = Observable<String>.of("투헬")

let 출전 = Observable
    .concat([감독, 첼시선수])

출전
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------concat2--------")
감독
    .concat(첼시선수)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------concatMap--------")
let 어린이집: [String: Observable<String>] = [
    "노랑반": Observable.of("김","이","박"),
    "파랑반": Observable.of("정", "한")
]
Observable.of("노랑반","파랑반")
    .concatMap { 반 in//두개의 시퀀스를 어팬드
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//시퀀스를 합치는 방법
print("--------merge1--------")
let 강북 = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(강북, 강남)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------merge2--------")
Observable.of(강북, 강남)
    .merge(maxConcurrent: 1)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------combineLatest1--------")
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름) { 성, 이름 in
        성 + 이름
    }

성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

성.onNext("김")
이름.onNext("주영")
이름.onNext("성아")
이름.onNext("내현")
성.onNext("안")
성.onNext("박")

print("--------combineLatest2--------")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short,.long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(날짜표시형식, 현재날짜,
    resultSelector: {형식, 날짜 -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = 형식
        return dateFormatter.string(from: 날짜)
    }
    )

현재날짜표시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("--------combineLatest3--------")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fulName = Observable
    .combineLatest([firstName, lastName]) {name in
        name.joined(separator: " ")
    }

fulName.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

lastName.onNext("kim")
firstName.onNext("sungA")
firstName.onNext("jooyoung")
firstName.onNext("gaon")
lastName.onNext("park")

print("--------zip--------")
enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable<String>.of("한국", "독일", "영국", "브라질", "일본"," 중국")

let 시합결과 = Observable
    .zip(승부, 선수) {결과, 대표선수 in
        return 대표선수 + "선수" + "\(결과)"
    }

시합결과
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------zip--------")
let 출발 = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

출발 //첫번째 옵저버블
    .withLatestFrom(달리기선수) //두번째 옵저버블
//    .distinctUntilChanged() 하면 sample과 같게 한번만 방출
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

달리기선수.onNext("🚴🏻")
달리기선수.onNext("🚴🏻‍♂️🚴🏻")
달리기선수.onNext("🚴‍♀️🚴🏻‍♂️🚴🏻")
출발.onNext(Void())
출발.onNext(Void()) //가장 최신꺼만 뱉어줌.

print("--------sample--------")
let 휘슬 = PublishSubject<Void>()
let 축구선수 = PublishSubject<String>()

축구선수
    .sample(휘슬)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

축구선수.onNext("메시")
축구선수.onNext("홀란드")
축구선수.onNext("네이마르")
휘슬.onNext(Void())
휘슬.onNext(Void()) //가장 최신꺼만 뱉고 한번만 방출.

//switch역할을 하는 오퍼레이터
print("--------amb--------")
let 버스1 = PublishSubject<String>()
let 버스2 = PublishSubject<String>()

let 버스정류장 = 버스1.amb(버스2) //뭐가 먼저 나올지 모르니 둘다 보고


버스정류장
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

버스2.onNext("메시") //처음으로 나온 버스2만 방출
버스2.onNext("홀란드")
버스1.onNext("네이마르") //버스1은 무시
버스2.onNext("음바페")
버스1.onNext("호날두")

print("--------switchLatest--------")
let 학생1 = PublishSubject<String>()
let 학생2 = PublishSubject<String>()
let 학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손들고말해라 = 손들기.switchLatest()

손들고말해라
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(학생1)
학생1.onNext("hi") //방출
학생2.onNext("hey")

손들기.onNext(학생2)
학생1.onNext("wow")
학생2.onNext("what") //방출

print("--------reduce--------")
Observable.from((1...10))
//    .reduce(0, accumulator: { summary, newValue in
//        return summary + newValue
//    })

//    .reduce(0) { summary, newValue in
//        return summary + newValue
//    }

    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("--------scan--------")
Observable.from((1...10))
    .scan(0, accumulator: +) //return값이 옵저버블임
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
