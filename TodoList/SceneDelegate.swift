//
//  SceneDelegate.swift
//  TodoList
//
//  Created by Amin  on 5/31/21.
//  Copyright © 2021 AhmedAmin. All rights reserved.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    let dataModel = DataModel()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let navigationController = window?.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! ToDoListViewController
        controller.dataModel = dataModel
        
        // Local Notification
        notificationCenter.delegate = self
        requestNotificationAuthorization()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        // Saving Data
        saveData()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Saving Data
        saveData()
    }
    
    
    
    // MARK: - Helper methods
    private func saveData() {
        dataModel.saveToDoList()
    }
    
    private func requestNotificationAuthorization() {
        
        // Ask the user permission
        let authOptions = UNAuthorizationOptions(
            arrayLiteral: [.alert, .sound])
        notificationCenter.requestAuthorization(
        options: authOptions) {
            (granted, errors) in
            if granted {
                print("We have permission")
            } else {
                print("Permission denied")
            }
        }
        
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        print("Received local notification \(notification)")
    }
}

