//
//  ActivityView.swift
//  SUILesson5
//
//  Created by Григоренко Александр Игоревич on 22.01.2023.
//

import SwiftUI

/// Представление активити контроллера.
struct ActivityView: UIViewControllerRepresentable {

    // MARK: - Public properties

    typealias UIViewControllerType = UIActivityViewController
    public var activityItems: [Any]
    public var applicationActivities: [UIActivity]?

    // MARK: - Public methods

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
