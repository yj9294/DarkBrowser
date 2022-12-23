//
//  FirebaseCommand.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/20.
//

import Foundation
import Firebase

struct FirebasePropertyCommand: Command {
    let property: AppState.Firebase.Property
    let value: String?
    init(_ property: AppState.Firebase.Property, _ value: String?) {
        self.property = property
        self.value = value
    }
    func execute(in store: Store) {
        var value = value
        
        if property.first {
            if UserDefaults.standard.string(forKey: property.rawValue) != nil {
                value = UserDefaults.standard.string(forKey: property.rawValue)!
            } else {
                UserDefaults.standard.set(Locale.current.regionCode ?? "us", forKey: property.rawValue)
            }
        }
#if DEBUG
#else
        Analytics.setUserProperty(value, forName: property.rawValue)
#endif
        NSLog("[ANA] [Property] \(property.rawValue) \(value ?? "")")
    }
}

struct FirebaseEvnetCommand: Command {
    let event: AppState.Firebase.Event
    let params: [String:String]?
    init(_ event: AppState.Firebase.Event, _ params: [String:String]?) {
        self.event = event
        self.params = params
    }
    func execute(in store: Store) {
        if event.first {
            if UserDefaults.standard.bool(forKey: event.rawValue) == true {
                return
            } else {
                UserDefaults.standard.set(true, forKey: event.rawValue)
            }
        }
        
        if event == .homeShow, store.state.home.isNavigation {
            store.dispatch(.loE(.homeShowNavigation))
        }
        
        if event == .homeSearchClick {
            if store.state.home.searchText.count == 0 {
                return
            }
            
            if !store.state.home.isNavigation {
                return
            }
        }
        
        #if DEBUG
        #else
        Analytics.logEvent(event.rawValue, parameters: params)
        #endif
        
        NSLog("[ANA] [Event] \(event.rawValue) \(params ?? [:])")
    }
}
