# Promise

Closure 패턴을 사용하다 보면 어쩔 수 없이 콜백헬이라는 것을 마주하게 됩니다.
콜백 헬은 가독성을 해치며 유지보수를 어렵게 만드는 요인중 하나입니다.

Promise의 전체 소스코드는 [여기](https://github.com/CoreKit/Promises)에서 볼수 있습니다. (하나의 파일만 존재하며 전체 450줄의 간단한 코드입니다.)

```swift
extension URLSession {

    enum HTTPError: LocalizedError {
        case invalidResponse
        case invalidStatusCode
        case noData
    }

    func dataTask(url: URL) -> Promise<Data> {
        return Promise<Data> { [unowned self] fulfill, reject in
            self.dataTask(with: url) { data, response, error in
                if let error = error {
                    reject(error)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    reject(HTTPError.invalidResponse)
                    return
                }
                guard response.statusCode <= 200, response.statusCode > 300 else {
                    reject(HTTPError.invalidStatusCode)
                    return
                }
                guard let data = data else {
                    reject(HTTPError.noData)
                    return
                }
                fulfill(data)
            }.resume()
        }
    }
}

```

우선 `URLSession` 을 extension해서 `Promise`를 사용할 수 있도록 `dataTask` 를 만듭니다.

```swift
enum TodoError: LocalizedError {
    case missing
}

let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
URLSession.shared.dataTask(url: url)
.thenMap { data in
    return try JSONDecoder().decode([Todo].self, from: data)
}
.thenMap { todos -> Todo in
    guard let first = todos.first else {
        throw TodoError.missing
    }
    return first
}
.then { first in
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(first.id)")!
    return URLSession.shared.dataTask(url: url)
}
.thenMap { data in
    try JSONDecoder().decode(Todo.self, from: data)
}
.onSuccess { todo in
    print(todo)
}
.onFailure(queue: .main) { error in
    print(error.localizedDescription)
}
```

위의 코드를 보면 아까 extesion해서 만들었던 dataTask를 이용해 Promise\<Data> 를 반환하는 새로운 메소드를 만들었습니다.
이를 이용해 chaining을 할 수 있습니다.

chaining은 Promise의 존재이유이자 장점입니다. 소스코드는 더 이상 callbackHell을 걱정하지 않아도 됩니다.
아래는 Promise의 메서드와 설명입니다.

* `thenMap`

  Promise의 map입니다.

* `then`

  Promise의 flatMap 입니다.

* `onSuccess`

  제대로된 결과(성공)를 받았을 때만 호출됩니다.

* `onFailure`

  오류가 발생한 경우에만 호출됩니다.

* `always`

  결과에 관계없이 항상 실행됩니다.



## Reference

* https://medium.com/@paabrown/the-hardest-thirty-lines-of-code-ive-ever-written-implementing-the-promise-class-in-js-ae7a36d77ed6
* https://p-iknow.netlify.com/js/custom-promise
* https://theswiftdev.com/promises-in-swift-for-beginners/
* https://github.com/CoreKit/Promises