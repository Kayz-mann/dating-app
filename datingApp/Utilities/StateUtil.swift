//
//  StateUtil.swift
//  datingApp
//
//  Created by Balogun Kayode on 12/08/2024.
//

import SwiftUI

// Utility function to access AppState from any view
func withAppState<T: View>(
    _ content: @escaping (AppState) -> T
) -> some View {
    // Return a view with the AppState environment object
    EnvironmentReader {
        content($0)
    }
}

// Helper view to read environment values
private struct EnvironmentReader<T: View>: View {
    @EnvironmentObject var appState: AppState
    let content: (AppState) -> T
    
    var body: some View {
        content(appState)
    }
}


