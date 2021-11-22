//
//  EventDetailsViewController.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 4.11.21.
//

import UIKit

class EventDetailsViewController: UIViewController {

    var eventDetailsContentView: EventDetailsContentView!
    let eventDetails: EventDetailsState
    
    init(eventDetails: EventDetailsState) {
        self.eventDetails = eventDetails
        self.eventDetailsContentView = EventDetailsContentView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = eventDetailsContentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        eventDetailsContentView.update(state: eventDetails)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if newCollection.verticalSizeClass == .regular {
            eventDetailsContentView.activateConstraitsForRegular()
        } else if newCollection.verticalSizeClass == .compact {
            eventDetailsContentView.activateConstraitsForCompact()
        }
    }
}
