
import Foundation
import Dispatch

let op = BlockOperation {
   print("Operation")
}
let opQueue = OperationQueue()
opQueue.addOperations([op], waitUntilFinished: true)

let sema = DispatchSemaphore(value: 0)

let queue = DispatchQueue(label: "queueName")
queue.async {
   print("XYZ")
   sema.signal()
}

if sema.wait(timeout: .now() + 10) == .timedOut {
   print("~~~~~~")
}

let config = URLSessionConfiguration()
let session = URLSession(configuration: config)
if let url = URL(string: "https://www.example.com") {
   let sema2 = DispatchSemaphore(value: 0)
   let task = session.dataTask(with: url) { data, response, error in
      if let response = response {
         print(response)
      }
      if let error = error {
         print(error)
      }
      if let data = data {
         print(data)
      }
      sema2.signal()
   }
   print(task)
   task.resume()
   if sema2.wait(timeout: .now() + 10) == .timedOut {
      print("~~~~~~")
   }
} else {
   print("bad url")
}

let json = ["name": "Sveta"]
do {
   let data = try JSONSerialization.data(withJSONObject: json, options: [])
   struct Person: Decodable {
      let name: String
   }

   let person = try JSONDecoder().decode(Person.self, from: data)
   print(person.name)

} catch {
   print(error)
}
