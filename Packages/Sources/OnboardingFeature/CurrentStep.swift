//
//  CurrentStep.swift
//  Main
//
//  Created by Hilal Hakkani on 21/12/2024.
//

import NodeCryptoCore

extension SharedKey where Self == InMemoryKey<OnboardingStep>.Default {
  public static var currentStep: Self {
      Self[.inMemory("currentStep"), default: .step1]
  }
}

