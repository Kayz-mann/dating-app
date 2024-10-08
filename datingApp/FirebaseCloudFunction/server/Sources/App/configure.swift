import Vapor
import JWT

// configures your application
public func configure(_ app: Application, signer: Any) async throws {
    // RSA private key
    let rsaPrivateKey = """
    -----BEGIN PRIVATE KEY-----
    MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDYgMkgNmh3XG56
    86mfmyi/wZp5P9srl1WpJRXcDv4XZPV6JHz37mfuTQSsJkSBlqmVmML7S8llEfZ8
    A47rQKC+MrQQu9AWAmReikbUdWNl00Ij4s4vwz0wB2vIE/bGyTf+6bylhZcanjyw
    XQB7Us4kbkOSr1C8d0+XB/hIrxQdt96lvoqU4xL+xWGglCYbwI51BGU5P8yjM379
    TpcC7pZpsq8CsId5WlvieK35CjMhJctacWCLq5ztDq3jNsIs5vKyOjZo6nTFUKm8
    zb/YSh60OuQbURJtBQTlEVSTN8t7cz1x6AA1lXpbS3Uvms+Fmn9rOIPbxgTQheqw
    woM4NTttAgMBAAECggEAJ/iS6V8SJ2NJxGpi+SQYwFpajiMjcCdW+czufbvI3oHV
    rlC5P77kskLG54+DG1e5BHT5HpMN4hqQYrH3e2hppOPQibxa/Q1BAZFO5V+s07pO
    njh776aAj/L2y7Af4fB5ZZc6rGZ/ELuBIeBxu9L8Ww5+bEDwy3LNn2kpxiWItbmL
    IaNuujKmkgCQxAhSzB3WxGsgJvzoxUIsKo6CTdSpEo+pq0+qH3bCBie7M/KQXy68
    MyyzOTgZLTeAaHAeC6PCZMQFI4IK6U7vHSxHQKCE55aOrCNfeMi/lQJJQrsRa1xG
    lGQwpuGpo295Rq8ATnVJuJ3LnnoVVZBEgH2C5K4+oQKBgQD1MK8k3qdOpnR/dx/c
    RALhtsYuLHLKk741ebzxcAmAi+hrzcxAegyMcnlWPJNHIyNAP6zAmQBdrCXAfK3u
    MpkfKNZ5q3Bx5HTlh7j48DJCzBmvBJRe8kLmHe+X5IUiv0lY65Gtzg4R3tK8IjvN
    FCp+lq4s3kp8VT7tVZIwDpqpXQKBgQDiDFPC5iifvRPbv79cOu/VAEzdigMPnnnm
    s6LPC/NWWdgt9vHk0mjO24Q3osil5sa7hAfd466tR05uApWDNm2lp74P9tI9y7F5
    M0j26ne8QJTELPD9kje9ZKe2tyzdLSc9FpNRtxuTlTE0ZkKa8zqIj2gXPFPrQQxx
    wvJjN6DpUQKBgB+zGKHCq4zOlnc4VoUqwdiewcaMdpbcPRY61AO/AWt+KyFs7QBV
    BzRNRISytjPXRiJzWQlZfqOdsw/Mzsvh/Mv7gqceVB5VdAuM3YxJuaXLL3LiO7B+
    z8lii2xu3gudAYWehyoaXtVOop4yKtsbxVaycnhYkPa8KrOSgaD28mX9AoGAc1cW
    5jvKPrebimUsn0LzXRvqHKBvL2kNikneqQbQAx+Uzt9STg+Oqv4XWMwW1ZALl2Kn
    IPEsD/5yZm+rGmiLShttP3gRjraAt/cTI+o/bi8FuZO0463YAyt46CJPIgwIGYOL
    aAama4eUs8f59FZnZ4bE9hYyO7fVQbbXNwkLcgECgYBtEHQMqV6sAoPHkRU3jfRc
    MfaAVpgtGyW0wjUKQb/B36+2RLeY7EpfBkjRbVCUh3rkqdba+VgPJwxvEV8T7jWV
    y9eMXaW2JW+iCzwxqbcmgsYfMYdfOHo2+3Tt+/AI+TBFOqtQVjFhuFx2Nnq48gxp
    yTxhzu8wOGpX8dnklzK+dA==
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



