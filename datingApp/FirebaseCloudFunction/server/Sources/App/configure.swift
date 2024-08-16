import Vapor
import JWT

// configures your application
public func configure(_ app: Application, signer: Any) async throws {
    // RSA private key
    let rsaPrivateKey = """
    -----BEGIN PRIVATE KEY-----
    -----END PRIVATE KEY-----
    """

    // Convert the private key to RSAKey
    guard let privateKey = try? Insecure.RSA.PrivateKey(pem: rsaPrivateKey) else {
        fatalError("Failed to load RSA private key")
    }
    
 

    // Add the RS256 signer to the JWT signers
    let signer =  try await app.jwt.keys.add(rsa: privateKey, digestAlgorithm: .sha256)

    // register routes
    try routes(app)
}



