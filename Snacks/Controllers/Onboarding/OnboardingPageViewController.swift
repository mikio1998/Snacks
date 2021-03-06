//
//  OnboardingPageViewController.swift
//  Snacks
//
//  Created by Mikio Nakata on 4/10/20.
//  Copyright © 2020 Mikio Nakata. All rights reserved.
//

import UIKit

protocol OnboardingPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Properties
    
    weak var onboardingDelegate: OnboardingPageViewControllerDelegate?
    
    var pageHeadings = ["Onboarding Heading 1", "Onboarding Heading 2", "Onboarding Heading 3"]
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    var pageSubheadings = ["Onboarding subHeading 1", "Onboarding subHeading 2", "Onboarding subHeading 3"]
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set datasource and delegate of UIPageViewController to self.
        dataSource = self
        delegate = self
        
        // - Create the first Onboarding screen.
        if let startingViewController = contentViewController(at: 0) {
            print("creating first screen")
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
            
        
    }

    // MARK: - PageViewController DataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let onboardingViewController = viewController as? OnboardingContentViewController
        guard var currentIndex = onboardingViewController?.index else {
            return nil
        }
        if currentIndex == 0 {
            return nil
        }
        currentIndex -= 1
        
        return contentViewController(at: currentIndex)
        
        
        
//        var index = (viewController as! OnboardingContentViewController).index
//        index -= 1
//        return contentViewController(at: index)
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        let onboardingViewController = viewController as? OnboardingContentViewController
        guard var currentIndex = onboardingViewController?.index else {
            return nil
        }
        if currentIndex == 3 {
            return nil
        }
        currentIndex += 1
        
        return contentViewController(at: currentIndex)

//        var index = (viewController as! OnboardingContentViewController).index
//        index += 1
//
//
//
//        return contentViewController(at: index)
    }
    
    // MARK: - Helper
    // With an index, returns the corresponding page.
    func contentViewController(at index: Int) -> OnboardingContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            print("called")
            return nil
        }
        print("I got called!")
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        // - Instantiate the OnboardingContentViewController.
        if let pageContentViewController = storyboard.instantiateViewController(identifier: "OnboardingContentViewController") as? OnboardingContentViewController {
            print("got the storyboard")
            pageContentViewController.imagefile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subheading = pageSubheadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    
    // Next button helper function.
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - OnboardingPageViewControllerDelegate
    // First check if page transition is completed.
    // Then find the current page index.
    // Then call delegate method .didUpdatePageIndex to inform the delegate.
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
                currentIndex = contentViewController.index
                
                onboardingDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
    
    
    
}
    





