### 프로젝트 구성

Clean Arcitecture + MVVM 아키 텍쳐 구성입니다.

VC → VM → RP → Network & CoreData 단방향 의존성 을 가집니다.

```jsx
.
├── MyBooks
│   ├── AppDelegate.swift
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   ├── Contents.json
│   │   └── placeholder.imageset
│   │       ├── Contents.json
│   │       └── placeholder.png
│   ├── Base.lproj
│   ├── Entity
│   │   ├── Book.swift
│   │   └── BookList.swift
│   ├── Extension
│   │   ├── Extension + PDFView.swift
│   │   ├── Extension + UIImageView.swift
│   │   └── Extension + UITextField.swift
│   ├── Info.plist
│   ├── Network
│   │   ├── Base
│   │   │   ├── NetworkError.swift
│   │   │   ├── NetworkManager.swift
│   │   │   └── URLSessionProtocol.swift
│   │   └── BookNetwork.swift
│   ├── Presentation
│   │   ├── Book
│   │   │   ├── BookView.swift
│   │   │   ├── BookViewController.swift
│   │   │   ├── BookViewModel.swift
│   │   │   └── Component
│   │   │       └── LinkButton.swift
│   │   └── Search
│   │       ├── Cell
│   │       │   └── SearchTableViewCell.swift
│   │       ├── Component
│   │       │   └── SearchTextField.swift
│   │       ├── SearchViewController.swift
│   │       ├── SearchViewCoordinator.swift
│   │       └── SearchViewModel.swift
│   ├── Repository
│   │   └── SearchBookRepository.swift
│   ├── SceneDelegate.swift
│   └── Util
│       └── CacheManager.swift
└── MyBooksTests
    ├── BookNetworkTests.swift
    ├── BookViewModelTests.swift
    ├── Mock
    │   ├── MockNetworkManager.swift
    │   ├── MockSearchRepository.swift
    │   └── MockURLSession.swift
    ├── NetworkManagerTests.swift
    └── SearchViewModelTests.swift

```

Entity

검색 리스트에 사용되는 BookListItem 과 책 상세 데이터를 다룬 Book를 별도로 나누었습니다.

Network 

NetworkManager 를 사용하여 제너릭한 타입을 받아 네트워크를 사용할수 있습니다.

네트워크를 구현할때 NetworkManager를 사용하여 URL과 필요한 파라미터를 전달하여 네트워킹을 구현합니다. 

```jsx
EX> networkManager.fetchData(urlString: "\(endPoint)/search/\(query)/\(page)", httpMethod: .get, headers: nil)
```

Repository

외부데이터 Network 에 접근 하여 원하는 데이터를 가져오는 역할입니다.

리스트 검색 , 책 상세 검색 기능을 가지고 있습니다

```jsx
func searchBooks(query: String, page: Int) async -> Result<BookList, NetworkError>
func bookDetail(isbn: String) async -> Result<Book, NetworkError>
```

ViewModel

Repository를 가지고 의존 합니다.

Repository 부터 데이터를 가져오며 ViewController의 상태를 관리합니다. 

ViewContoller 과의 이벤트 전달은 input output 으로만 관리 됩니다.

VC → VM 전달은 Input

VM → VC 전달은 Output에 모두 정의 되어 사용됩니다.

```jsx
 struct Input {
      let searchText: AnyPublisher<String,Never>
      let loadMore: AnyPublisher<Void,Never>
  }
  struct Output {
      let bookList: AnyPublisher<[BookListItem],Never>
      let errorMessage: AnyPublisher<String,Never>
  }
```

ViewController

ViewModel과 Coordinator를 가지고 의존합니다

bindViewModel() 함수 내부에서 ViewModel과 이벤트 전달을 합니다.

SearchViewController - 검색과 책 리스트 목록을 표현합니다. 리스트는 TableView로 구현되었습니다. 테이블뷰 데이터소스로 books Subject를 가지고 있습니다.

BookViewController - 책 상세 내용을 표현합니다. 컨텐츠가 많아 BookView 를 따로 분리 했습니다. BookView 에서는 ScrollView를 사용해 전체 내용을 표현했으며 pdfView를 사용해 pdf UI가 구현되었습니다.

Coordinator

네비게이션 & 객체 생성 역할을 합니다.

Pdf , Image Cache

기본적으로 Pdf , Image 를 네트워크 호출하여 다운받아 사용합니다.

각각 Pdf , Image CacheManager 를 통해 이미지를 저장하여 필요시 꺼내 사용하여 중복 호출이 방어 되었습니다.

비교적 빠른 메모리캐시를 우선적으로 사용, 없을시 디스크 캐시를 사용합니다.

둘다 없을시 네트워크 호출을 합니다.

```jsx
func image(forKey key: String) -> UIImage? {
    if let image = cache.object(forKey: key as NSString) {
        return image
    }
    
    if let fileURL = fileURL(for: key),
       let imageData = try? Data(contentsOf: fileURL),
       let image = UIImage(data: imageData) {
        cache.setObject(image, forKey: key as NSString)
        return image
    }
    return nil
    
}
```
