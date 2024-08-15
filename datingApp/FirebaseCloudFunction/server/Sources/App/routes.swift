import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.post("nextRandom"){ req async in
        do {
            
        } catch {
            debugPrint("\(error)")
            return Response(status: .internalServerError, body: "\(error)")
        }
    }
}
