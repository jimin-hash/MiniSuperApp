

모듈 레벨 아키텍처

모노리틱 앱 구조 특징
1. 단일 타겟(모듈)
2. 객체 간 무분별한 참조
3. 코드 변경의 영향 범위 파악이 힘듦
4. 빌드 시간 증가에 따른 생산성 저하

모듈화를 완성시키기 위해서는 모듈간에 느슨하게 결합을 해야 진정한 모듈화가 완성된다.

소스코드 의존성
- 코드의 흐름은 런타임 의존성이라 부름
- 소스코드 의존성은 컴파일 타임 의존성이라 부름 (빌드시간을 좌우함)

example) 상위 모듈(10초)은 모듈1(10초)과 모듈2(50초)가 모두 컴파일된 후에야 컴파일이 가능
xcode10 이후에 병렬 빌드가 가능해져서 모듈1,2가 겹지는 부분이 없다고 가정하였을때, 상위 모듈이 컴파일이 진행할때 모듈1,2도 동시에 컴파일이 진행됨 총 60초가 소요됨
-> 앱의 빌드 시간을 줄이고 싶다면 전체 빌드에 직접적인 영향을 주는 병목 모듈(같은 레벨의 모듈)들을 찾아내서 그 모듈의 빌드 시간을 먼저 줄여야한다.
-> Solution: 코드를 모듈화해서 별도 프레임워크로 만들어서 해당 프레임워크만 빌드하는 xcode scheme을 만들어서 프레임워크 단독으로 빌드를 하고 또 Unit Test를 해볼수도 있다.

느슨한 결합
<img width="494" alt="스크린샷 2024-11-14 오후 3 51 17" src="https://github.com/user-attachments/assets/6db202c8-0d30-4fc9-9b6e-7c9325fe3539">
비즈니스 로직은 UserServiceImp 객체가 아니라 UserService라는 프로토콜에 소스 코드 의존성을 가짐
의존성 역전, 코드 호출 의존성과 소스 코드 의존성이 반대 방향으로 향함. 이것을 통해 비즈니스 로직을 구현제로부터 독립시키는 것이 가능함
<img width="713" alt="스크린샷 2024-11-14 오후 3 59 38" src="https://github.com/user-attachments/assets/04b178e1-807e-4ce0-9bd3-557d3695cb9d"> 
초록색: 코드 호출(Flow of Control)
빨간색: 소스코드 의존성

모노리틱 앱 구조에서 모듈화 구조로 바꾸고 모듈 간 소스코드 의존성을 역전해서 느슨하게 결합을 하면 얻을 수 있는 장점
1. 확장과 재사용
   - 새 기능 개발, 기존 기능 수정 수월
   - 모듈별 독립적인 재사용 가능
2. 유지보수
   - 모듈의 경계가 명확
   - 수정, 영향 범위 파악이 쉬움
   - 개발 생산성 향상
   - 빌드 시간 단축
3. 병렬 개발
   - 규묘가 큰 팀에게 필수
   - 고립된 개발 환경
   - 미완성 모듈에도 의존할 수 있음
4. 테스트 용이성
   - 테스트 대역으로 치환
   - 빠른 자동화 테스트
  
의존성 역전은 꼭 필요한 곳에만 사용하는 것이 좋음, 여러곳에서 의존역 역전 protocol을 사용하게 된다면 코드의 흐름을 읽기 어려울 수 있기 때문에.

의존성 주입 - 의존성 역전을 실행하기 위한 구체적인 방법
의존성 격전이 쓰인 코드에서는 객체들을 생성하고 주입해 주는 지점이 존재해야 하는데, 이 지점을 컴포지션 루트하고 부름

의존성 주입 방법 3가지
1. 생성자 주입
2. 매서드 주입
3. 프로퍼티 주입

RIBs에서는 빌더가 각 리블렛의 컴포지션 루트 역할을 하고 있음.

의존성 필요 유무
의존성을 주입할지 말지는 외존성이 가지고 있는 동작의 특성에 따라 다름
Volatile Dependency 주입해야하는 의존성
1. 사용하기 전 runtime에 초기화가 필요한 것 ex) 데이터베이스
2. 아직 존재하지 않거나 개발 중인 것
3. 비결정론적 동작 / 알고리즘 ex) 랜덤 함수, Date()등
   
Stable Dependency 주입할 필요 없는 의존성
결정론적 동작 / 알고리즘, 신뢰할만한 하위호환성, Volatile 의존성을 제외한 모든 것
ex) Foundation, 유팅성 코드, Formatter 등


모듈화를 위해선 아래와 같이 진행한다.
1. 코드를 라이브러리로 적절히 분리해서, public과 internal 접근자로 무분별한 개체 참조를 막는다. (Swift Package 사용)
2. 모듈을 느슨하게 결합하여 소스 코드 의존성을 역전시켜, 쓰지 않을 코드를 컴파일을 기다리지 않고도 필요로하는 모듈만 실행한다.

주의 사항 
모듈화를 진행할때에는 앱 최상위에서 가장 먼 곳에서부터 시작, List Node에서 부터 시작해야한다. 
internal protocol -> public 으로 전환할때 리스너, 디펜던시, 빌더블, 빌더를 퍼블릭으로 바꾼다.

모듈화 프로젝트 진행 스텝
1. AddPaymentMethod(최하위) 라이브러리 생성
2. PaymentMehotd는 Finance 패키지 전체에서 사용되는 객체이기 때문에 새로운 라이브러리 FinanceEntity라는 라이브러리를 생성한다.
3. 레포지토리 전용 라이브러리 생성
4. ReadOnlyCurrentValuePublisher는 앱 전반적으로 쓰이는 잔액 publisher이기 때문에 Platform 패키지에 combineUtil이라는 라이브러리를 생성하여 사용하게끔함
5. RIBs관련 유틸도 Platform 패키지에 라이브러리 생성함

의존성 없애기!
예) AppHome 모듈에 import TransportHome 이 있다는것은 TransportHome에 모든 소스 코드 의존성을 가지고 있겠다는것!
리블렛 모듈은 리블렛의 빌더만 직접 만들지 않으면 된다. 
그래서 TransportHome를 인터페이스와 구현부를 분리해서 제공함 -> 사용 모듈 빌드 시간에 영향을 받지 않게 됨

TransportHomeBuildable를 부모로 부터 요청 진행? -> AppHome의 부모 AppRoot는 최상위 부모로 언젠가 빌드가 되어야하는 곳이 이곳이므로
-------
모듈 인터페이스 만들기
모듈을 만들때에는 열림/닫힘 원칙을 반드시 고려!



Test Code

```
func testTopupWithValidAmount() {
        // given - 수행에 앞어서 환경을 셋업
        let paymentMethod = PaymentMethod(id: "id_1", name: "name_1", digits: "8888", color: "#13ABE8FF", isPrimary: false)
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when - 검증하고자 하는 행위
        sut.didTapTopup(with: 1_000_000)
        
        // then - 예상하는 행동을 했는지 검증
        // 멀티스래딩 문제! 네트워킹이 백그라운드에서 진행되고 콜백 결과를 receiveOn 메인 스래드에서 받고 있음
        // receiveOn 때문에 stopLoading과 enterAmountDidFinishTopup이 비동기로 실행이 되어서, XCTAssert 메소드가 불리고 난 다음에 stopLoading과 enterAmountDidFinishTopup 이 호출이 되는 문제가 있다.
        // 가장 간단한 방법으로는 XCTWaiter 사용하는 방법이 있다. -> 최선은 아님!
        _ = XCTWaiter.wait(for: [expectation(description: "wait ... ")], timeout: 0.1)
        
        XCTAssertEqual(presenter.startLoadingCount, 1)
        XCTAssertEqual(presenter.stopLoadingCount, 1)
        XCTAssertEqual(repository.topupCallCount, 1)
        XCTAssertEqual(repository.paymentMethodID, "id_1")
        XCTAssertEqual(repository.topupAmount, 1_000_000)
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 1)
}
```
멀티스레딩 환경에서 테스트하기
멀티스레딩 환경은 유닛 테스트의 재연가능성(Reproducibility)을 저해하는 방해물
-> 해식 로직과 비동기적 특성을 분리하여 테스트는 가능한 한 동기적(Synchronous)으로 작동하게 만들어야 한다.

해결 방법
DispatchQueue.main을 직접 쓰지 않고 주입을 받게 해서 테스트 코드에서는 다른 스케줄을 넣을 수 있도록 한댜.
테스트 코드에서는 ImmediateScheduler(A scheduler for performing synchronous actions)를 사용
스케줄러는 generic protocol 타입이라 직접 선언 못함, combine의 publisher처럼 (그래서 AnyPublisher...) 
```
var mainQueue: AnySchedulerOf<DispatchQueue> { .main }
var mainQueue: AnySchedulerOf<DispatchQueue> { .immediate }
```

Interactor Test
router, presentable, dependencies mock 필요

Router Test
Buildable, ViewControllable mock필요
1. Builable에서 올바른 파라미터를 넘기는지 체크
2. 두번 이상의 Attach 하는 방어 로직 체크
3. ViewControllable의 present, dismiss, push, pop의 정상 작동 체크


Unit Testing
- 객체나 모듈 단위 테스트
- 코드 레벨에서 일부 코드의 행위를 검증하는 방식
- 유닛 테스트에서 검증 대산이 단일 개체일 때는 기능이 조금만 수정되어도 테스트 코드까지 덩달아 바뀌어야한다는 단점이 있었음
  
SnapShot Testing - 뷰 유닛테스트 진행

UI Testing
- End-to-End
- 코드를 모르는 상태를 가정하고 테스트하는 방식
- 앱의 사용자의 입장에서 테스트하는 방식
- 실제 백엔드 응답 값을 모킹해줘야함(swifter 사용)
<img width="400" alt="스크린샷 2024-12-08 오후 9 22 46" src="https://github.com/user-attachments/assets/a3b70c15-4a6a-427b-9f65-f7b1b30e1584">

Integration Testing
- 유닛 테스트보다는 실행 비용이 비싸지만 신뢰도는 더 높다
- 테스트 환경과 실제 환경이 다를때 발생할 수 있는 상황에서 유용..?
- 아직 실험 단계...
<img width="400" alt="스크린샷 2024-12-08 오후 9 36 10" src="https://github.com/user-attachments/assets/9cf25214-3e53-4bdf-8e86-59440ede0e83">

자동화 테스트 운영하기
- 테스트의 효과성
  - 프로그램 오류, 버그를 제대로 포착해 낼 수 있는가?
- 테스트의 신뢰도
  - 간헐적으로 실패하지 않는가? (flakiness, reproducibility)
- 테스트 용이성
  - 개발자가 테스트를 작성하고 관리하는 경험이 쾌적한가?
 
 Feature Flags
 - 코드 변경이나 배포없이 프로그램의 동작을 변경할 수 있게 하는 소프트웨어 개발 기법
 - ex) A/B 테스트

Feature Branch Development
featrue_branch -> release_branch -> main_branch
피처 플래그를 이용하면 미완성된 코드를 완전히 숨길 수 있기 때문에 피처 브랜치가 더 이상 필요가 없어진다..
-> 장기간 통합되지 않은 피처브랜지를 애초에 방지 하는 것, 작은 커밋을 자주 메인 브랜치에 통합하자는 의미

트렁크 기반 개발론
-  Feature Flags + Feature Branch Development
1. 새 리블렛을 생성 후 브랜치에 머지
2. 피처플래그를 선언하고 새로 만든 리블렛을 사용할 곳에서 해당 피처 플래그를 거쳐야만 화면에 보이게끔 코드 작성 후 브랜치에 머지
3. 뷰를 작업하고 스냅샷 테스트를 작성하고 브랜치에 머지
4. 인터랙터의 로직을 추가하고 테스트를 추가하고 브랜치에 머지

실시간 품질 측정
1. 성공률
   - API 성공률
   - 주요 비즈니스 로직 성공률
2. 소요시간 (p50, p90, p95)
   - 앱 실행 시간 
   - 대용량 데이터 불러오는 시간
   - API 응답 시간
3. 에러종류







