import Vapor
import JWT

// Define the private key as a global constant
let rsaPrivateKey = """
-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDYgMkgNmh3XG56
... [rest of the key] ...
yTxhzu8wOGpX8dnklzK+dA==
-----END PRIVATE KEY-----
"""

// Extend String to add URL percent encoding
extension String {
    var urlQueryPercentEncoded: String? {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

func routes(_ app: Application) throws {
    app.post("nextRandom") { req -> EventLoopFuture<Response> in
        do {
            // JWT Claims
            let issuedTime = Date()
            let timeToLive: TimeInterval = 60 * 30 // 30 minutes
            let expirationTime = issuedTime.addingTimeInterval(timeToLive)

            let claims = OAuthClaims(
                iss: "firebase-adminsdk-notoj@vaporfirebasedemo.iam.gserviceaccount.com",
                scope: "https://www.googleapis.com/auth/datastore",
                aud: "https://www.googleapis.com/oauth2/v4/token",
                exp: Int(expirationTime.timeIntervalSince1970),
                iat: Int(issuedTime.timeIntervalSince1970)
            )

            // Sign the JWT using the RS256 signer
            guard let privateKey = try? Insecure.RSA.PrivateKey(pem: rsaPrivateKey) else {
                throw Abort(.internalServerError, reason: "Failed to create RSA private key")
            }
            let signer = app.jwt.keys.add(rsa: privateKey, digestAlgorithm: .sha256)
            let jwt = try signer.sign(claims)
            debugPrint("Using JWT: \(jwt)")

            // OAuth - Authenticate with Google using the JWT
            guard let oAuthParams = "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(jwt)".urlQueryPercentEncoded else {
                throw Abort(.internalServerError, reason: "Failed to encode OAuth parameters")
            }
            debugPrint("OAuth Params: \(oAuthParams)")

            return req.client.post(URI(string: "https://www.googleapis.com/oauth2/v4/token")) { clientReq in
                clientReq.headers.contentType = .urlEncodedForm
                clientReq.body = .init(string: oAuthParams)
            }.flatMapThrowing { authResponse in
                debugPrint("Google auth response: \(authResponse)")

                // Handle Google OAuth response
                guard authResponse.status == .ok,
                      let json = try? authResponse.content.decode([String: String].self),
                      let accessToken = json["access_token"] else {
                    throw Abort(.internalServerError, reason: "Google auth response did not include an access token")
                }

                // Generate a random number
                let randomNumber = UInt32.random(in: 1...100)

                // Build Firestore resource name
                let projectId = "vaporfirebasedemo"
                let databaseId = "(default)"
                let documentPath = "randomNumbers/theRandomNumber"
                let resourceName = "projects/\(projectId)/databases/\(databaseId)/documents/\(documentPath)"

                // Create a Firestore document object to represent the random number
                let firestoreDocument = FirestoreDocument(name: resourceName, number: randomNumber)

                let firestoreDocumentURL = "https://firestore.googleapis.com/v1beta1/\(resourceName)"

                // Patch the Firestore document
                return req.client.patch(URI(string: firestoreDocumentURL)) { firestoreReq in
                    firestoreReq.headers.bearerAuthorization = BearerAuthorization(token: accessToken)
                    firestoreReq.headers.contentType = .json
                    try firestoreReq.content.encode(firestoreDocument)
                }.flatMapThrowing { firestoreResponse in
                    guard firestoreResponse.status == .ok else {
                        throw Abort(.internalServerError, reason: "Error saving document to Firestore: \(firestoreResponse)")
                    }
                    return Response(status: .ok, body: firestoreResponse.body ?? .init(string: "Success"))
                }
            }

        } catch {
            debugPrint("\(error)")
            return req.eventLoop.makeFailedFuture(error)
        }
    }
}

struct OAuthClaims: JWTPayload {
    let iss: String
    let scope: String
    let aud: String
    let exp: Int
    let iat: Int

    func verify(using signer: JWT.JWTSigner) throws {
        // Additional verification logic if needed
    }
}

struct FirestoreDocument: Content {
    let name: String
    let fields: [String: [String: Int]]

    init(name: String, number: UInt32) {
        self.name = name
        self.fields = ["number": ["integerValue": Int(number)]]
    }
}

// configures your application
public func configure(_ app: Application) async throws {
    // Add the RS256 signer to the JWT signers
    if let privateKey = try? Insecure.RSA.PrivateKey(pem: rsaPrivateKey) {
        app.jwt.keys.sign(JWTPayload, kid: "a")
    } else {
        fatalError("Failed to load RSA private key")
    }

    // register routes
    try routes(app)
}
