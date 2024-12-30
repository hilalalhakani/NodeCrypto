//
//  AuthError.swift
//  Main
//
//  Created by Hilal Hakkani on 15/12/2024.
//

public enum AuthenticationError: Error {
    case invalidCredentials
    case invalidEmail
    case userNotFound
    case unknown(Error)
}
