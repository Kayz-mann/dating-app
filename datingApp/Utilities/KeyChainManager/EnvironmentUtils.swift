//
//  EnvironmentUtils.swift
//  datingApp
//
//  Created by Balogun Kayode on 12/08/2024.
//

import Foundation

/// Function to load an environment variable by name.
func loadEnvironmentVariable(named name: String) -> String? {
    return ProcessInfo.processInfo.environment[name]
}


