//
//  DelegateAndDataSourceForContent.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 6.12.21.
//

import Foundation
import UIKit

class DelegateAndDataSourceForContent: NSObject, UICollectionViewDataSource {
    
    var controller: EventListViewController?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return EventListDataSource.shared.filteredEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.reuseIdentifier, for: indexPath) as! ContentCollectionViewCell
        cell.setupCell(selectedIndex: indexPath.row)
        cell.controller = controller
        return cell
    }
}

extension DelegateAndDataSourceForContent: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

// MARK: - UICollectionView Delegate
extension DelegateAndDataSourceForContent: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let controller = controller else { return }
        let selectedIndex = controller.eventListContentView.contentView.getCurrentPage()
        controller.eventListContentView.contentView.selectedIndex = selectedIndex
        controller.eventListContentView.menuBar.selectedIndex = selectedIndex
        controller.eventListContentView.menuBar.refreshIndicator()
        controller.eventListContentView.menuBar.menuCollection.selectItem(at: IndexPath(row: selectedIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
    }
}

extension ContentView {
    func getCurrentPage() -> Int {
        let visibleRect = CGRect(origin: contentCollection.contentOffset, size: contentCollection.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = contentCollection.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        return selectedIndex
    }
}
