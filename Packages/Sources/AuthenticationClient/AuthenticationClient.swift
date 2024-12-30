//
//  AuthenticationClient.swift
//  Main
//
//  Created by Hilal Hakkani on 15/12/2024.
//

import FirebaseAuth
import Foundation
import NodeCryptoCore

public struct VoidResponse: Equatable, Sendable {
    public init() {}
}

@CasePathable
public enum AuthenticationState: Equatable, Sendable {
    case signedIn(user: SharedModels.User)
    case signedOut
}

@DependencyClient
public struct AuthenticationClient: Sendable {
    public var observeAuthenticationStateChange:
    @Sendable () async -> AsyncThrowingStream<AuthenticationState, Error> = { .finished() }
    public var signUp:
    @Sendable (_ email: String, _ password: String) async throws -> SharedModels.User
    public var signIn:
    @Sendable (_ email: String, _ password: String) async throws -> SharedModels.User
    public var signOut: @Sendable () async throws -> VoidResponse

}

extension AuthenticationClient: DependencyKey {
    public static var liveValue: AuthenticationClient {
        return Self(
            observeAuthenticationStateChange: {
                AsyncThrowingStream(AuthenticationState.self) { continuation in
                    let handle = Auth.auth()
                        .addStateDidChangeListener { auth, user in
                            if let userId = user?.uid, let email = user?.email {
                                continuation.yield(
                                    .signedIn(
                                        user: .init(
                                            id: userId,
                                            email: email,
                                            fullName: "",
                                            mobileNumber: "",
                                            profileImage: "",
                                            walletAddress: "",
                                            profileDescription: ""
                                        )
                                    )
                                )
                            } else {
                                continuation.yield(.signedOut)
                            }

                        }

                    let sendableHandle = UncheckedSendable(handle)

                    continuation.onTermination = { @Sendable _ in
                        Auth.auth().removeStateDidChangeListener(sendableHandle.value)
                    }

                }
            },
            signUp: { email, password in
                try await Auth.auth().createUser(withEmail: email, password: password)
                return .mock1
            },
            signIn: { email, password in
                do {
                    try await Auth.auth().signIn(withEmail: email, password: password)
                    return .mock1
                } catch let error as NSError {
                    if error.code == AuthErrorCode.invalidCredential.rawValue {
                        throw AuthenticationError.invalidCredentials
                    } else if error.code == AuthErrorCode.invalidEmail.rawValue {
                        throw AuthenticationError.invalidEmail
                    } else {
                        throw AuthenticationError.unknown(error)
                    }
                } catch {
                    throw AuthenticationError.unknown(error)
                }
            },
            signOut: {
                VoidResponse()
            }
        )
    }

    public static var previewValue: AuthenticationClient {

        return Self(
            observeAuthenticationStateChange: {
                AsyncThrowingStream(AuthenticationState.self) { continuation in
                    continuation.yield(.signedIn(user: .mock1))
                }
            },
            signUp: { email, password in
                return .mock1
            },
            signIn: { email, password in
                return .mock1
            },
            signOut: {
                VoidResponse()
            }
        )
    }

}

extension DependencyValues {
    public var authenticationClient: AuthenticationClient {
        get { self[AuthenticationClient.self] }
        set { self[AuthenticationClient.self] = newValue }
    }
}
