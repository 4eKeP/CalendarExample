//
//  OnBoardingController.swift
//  CalendarExample
//
//  Created by admin on 31.01.2024.
//

import UIKit

final class OnBoardingController: UIPageViewController {
    
    private let spacing: CGFloat = 20
    
    private let buttonHeight: CGFloat = 60
    
    private let centerOffset: CGFloat = 60
    
    private let bottomSpacing: CGFloat = 86
    
  //  private let bottomPageControlOffset: CGFloat = 135
    
    private let ButtonTitle: String = "Example text"
    
    private let firstControllerTitle: String = "First controller title"
    
    private let lastControllerTitle: String = "Last controller title"
    
    private lazy var firstPageController = {
        let controller = UIViewController()
        controller.view.backgroundColor = .red
        return controller
    }()
    private lazy var lastPageController = {
        let controller = UIViewController()
        controller.view.backgroundColor = .blue
        return controller
    }()
    
    private lazy var pages: [UIViewController] = [firstPageController, lastPageController]
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        
        setupPageControl()
    }
    
    @objc private func buttonPressed() {
        print("Button pressed")
    }
}

extension OnBoardingController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
    
    
}

extension OnBoardingController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if
            let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

private extension OnBoardingController {
    
    func setupControllers() {
        setupPageControl()
        
        addTitle(firstControllerTitle, to: firstPageController.view)
        addButton(to: firstPageController.view)
        
        addTitle(lastControllerTitle, to: lastPageController.view)
        addButton(to: lastPageController.view)
    }
    
    func addTitle(_ title: String, to view: UIView) {
        let lable = UILabel()
        lable.numberOfLines = 2
        lable.textAlignment = .center
        lable.textColor = .black
        lable.text = title
        lable.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lable)
        
        NSLayoutConstraint.activate([
            lable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            lable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            lable.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: centerOffset),
            lable.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addButton(to view: UIView) {
        let button = OnBoardingButton()
        
        button.setTitle(ButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing)
        ])
    }
    
    func setupPageControl() {
        view.addSubview(pageControl)
        
        let bottomPageControlOffset = buttonHeight + spacing * 2
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomPageControlOffset)
        ])
    }
}

