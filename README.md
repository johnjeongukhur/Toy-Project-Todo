# TODO App_toy_project

### Overview
* Todo App 프로젝트는 UIKit Codebase에 기반한 RxSwift와 MVVM 디자인 패턴을 활용하여 간단한 할 일 목록을 관리하는 앱 입니다. 

### 사용 기술 스택(iOS), 그 외 아래 기술
* Swift, UIKit(Codebase), RxSwift, RxCocoa, Alamofire
  
### Team
- 개발자: 허정욱
  
### 개발 소요 기간
* 총 한 달(iOS)

### Description
* Todo 추가, 수정, 삭제
* 로그인 및 로그아웃, Token Keychain 관리


### Screenshots

|스플래시 화면|로그인|아이디 비밀번호 입력 알람|
|:-:|:-:|:-:|
|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/bdbd9f95-201f-422c-9208-1650aa8a6748" width = "75%" heigth = "75%"></img><br/>|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/990606db-e01b-4fb7-8790-69e60ed6f123" width = "75%" heigth = "75%"></img><br/>|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/930666e4-00a3-410c-aeeb-8ef5d3172221" width = "75%" heigth = "75%"></img><br/>|

|메인화면|새로운 Todo 등록|Todo 등록되었음 알람|
|:-:|:-:|:-:|
|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/784c76b4-f887-4456-b7de-bb77acdff630" width = "75%" heigth = "75%"></img><br/>|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/de8d878f-abf1-4671-aa7b-9a94a671b960" width = "75%" heigth = "75%"></img><br/>|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/541d8a5a-53eb-4c1b-bbcc-bc8ad8889c11" width = "75%" heigth = "75%"></img><br/>|

|메인 하단에 새로 등록된 Todo|새로운 Todo 상세보기|Todo 수정|
|:-:|:-:|:-:|
|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/d373fa1d-7411-4a96-8603-243670c95e71" width = "75%" heigth = "75%"></img><br/>|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/56fd3a90-bc1e-48b5-a5c1-076c6fda6470" width = "75%" heigth = "75%"></img><br/>|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/eacc5d4e-e4f6-4d46-8a68-f955335d2e41" width = "75%" heigth = "75%"></img><br/>|

|수정된 Todo|Todo 삭제|
|:-:|:-:|
|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/497554d3-90c2-483c-b5f7-871bf563efa8" width = "75%" heigth = "75%"></img><br/>|<img src = "https://github.com/johnjeongukhur/Toy-Project-Todo/assets/47841046/215d0fa5-306f-4981-addb-cf1791feaeef" width = "75%" heigth = "75%"></img><br/>|

### 코드 구조
- ViewController : 앱의 여러 ViewController를 개발할 때, 일관된 구조를 사용하도록 노력하였습니다.  
아래 예시를 통하여 간단한 구조를 볼 수 있습니다.
  
```swift
...VC 구조 예시
viewDidLoad() {
  setupUI()  
}
action()
...

class HomeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        refreshAfterEdited()
    }

    //MARK: - Setup UI
    func setupUI() {
        title = "Todo List"
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        setupNaviView()
        setupTableView()
        setupAddButton()
    }

    // Navi Icon
    func setupNaviView() {
        // Navigation Right Bar Array
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        deleteButton.tintColor = UIColor(hex: "#676767")
        
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutButtonTapped)
        )
        logoutButton.tintColor = UIColor(hex: "#676767")
        
        navigationItem.rightBarButtonItems = [logoutButton, deleteButton]
    }


    //MARK: - Actions
    // This called when DetailVC is closed
    func refreshAfterEdited() {
        NotificationCenter.default.addObserver(self, selector: #selector(todoEdited), name: NSNotification.Name("todoEdited"), object: nil)
    }
    
    @objc func addButtonTapped() {
        let homeCreateTodoVC = HomeCreateTodoVC()
        navigationController?.pushViewController(homeCreateTodoVC, animated: true)
    }
    
    @objc func refreshData() {
        viewModel.getTodoAll() {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

}
```

- ViewModel : todoItem이 사용되지 않을떄 자동으로 메모리에서 해제될 수 있도록 옵셔널 처리하였습니다.
subscribe를 통하여 이벤트 성공 후 네트워크에서 응답된 데이터를 받아 볼 수 있습니다.  
action 매개변수를 통해 비동기 작업이 완료된 후 클로저를 실행합니다.
```swift
class HomeDetailVM {
    
    let disposeBag = DisposeBag()
    
    var todoItem = BehaviorRelay<TodoAllData?>(value: nil)
    
    var id: Int = 0
    
    func getTodoDetail(action: @escaping () -> Void) {
        TodoAPI.getTodoDetail(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                print("Todo Detail Model: \(event)")
                switch event {
                case .next(let todo):
                    print("\(todo)")
                    self?.todoItem.accept(todo)
                    action()
                case .error(let error):
                    print("Error: \(error.localizedDescription)")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
```


### 그 외 기술 사용
#### iOS
- Swift
- UIKit (Programmatically-Codebase)
- RxSwift
- RxCocoa
- Alamofire

#### Backend
- FastAPI
- MySql

#### Server Infra
- AWS: EC2, Route53
- NGinX, SSH 설정

#### Domain
- 내도메인.한국
