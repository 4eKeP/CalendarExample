//
//  OnBoardingController.swift
//  CalendarExample
//
//  Created by admin on 31.01.2024.
//

import UIKit

final class OnBoardingController: UIPageViewController {
    
    private let spacing = Constants.OnBoardingConstants.spacing
    
    private let buttonHeight = Constants.OnBoardingConstants.buttonHeight
    
    private let centerOffset = Constants.OnBoardingConstants.centerOffset
    
    private let bottomSpacing = Constants.OnBoardingConstants.bottomSpacing
    
    private let buttonTitle = Constants.OnBoardingConstants.buttonTitle
    
    private let controller1Title = Constants.OnBoardingConstants.controller1Title
    
    private let controller2Title = Constants.OnBoardingConstants.controller2Title
    
    private let controller3Title = Constants.OnBoardingConstants.controller3Title
    
    private let page1Image = Constants.OnBoardingConstants.page1Image
    
    private let page2Image = Constants.OnBoardingConstants.page2Image
    
    private let page3Image = Constants.OnBoardingConstants.page3Image
    
    private lazy var page1Controller = {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }()
    
    private lazy var page2Controller = {
        let controller = UIViewController()
        
        controller.view.backgroundColor = .clear
        return controller
    }()
    
    private lazy var page3Controller = {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }()
    
    private lazy var pages: [UIViewController] = [page1Controller,page2Controller, page3Controller]
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    //MARK: - init
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    
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
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return assertionFailure("Faild to get window in OnBoardingController") }
        let viewController = ForkPageViewController()
        UserDefaults.standard.isOnBoarded = true
        window.rootViewController = viewController
    }
}

//MARK: - UIPageViewControllerDataSource

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

//MARK: - UIPageViewControllerDelegate

extension OnBoardingController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if
            let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

//MARK: - make UI

private extension OnBoardingController {
    
    func setupControllers() {
        setupPageControl()
        addBackgroundImage(page1Image, to: page1Controller.view)
        addTitle(controller1Title, to: page1Controller.view)
        
        addBackgroundImage(page2Image, to: page2Controller.view)
        addTitle(controller2Title, to: page2Controller.view)
        
        addBackgroundImage(page3Image, to: page3Controller.view)
        addTitle(controller3Title, to: page3Controller.view)
        addButton(to: page3Controller.view)
    }
    
    func addBackgroundImage(_ image: UIImage?, to view: UIView) {
        let imageView = UIImageView()
        
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addTitle(_ title: String, to view: UIView) {
        let lable = UILabel()
        lable.numberOfLines = 4
        lable.textAlignment = .center
        lable.textColor = .black
        lable.text = title
        lable.font = UIFont.systemFont(ofSize: 25, weight: .bold)
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
        
        button.setTitle(buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buttonHeight)
        ])
    }
    
    func setupPageControl() {
        view.addSubview(pageControl)
        
        let bottomPageControlOffset = buttonHeight * 2 + spacing
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomPageControlOffset)
        ])
    }
}

