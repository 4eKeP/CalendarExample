//
//  ForkPageViewController.swift
//  CalendarExample
//
//  Created by admin on 04.02.2024.
//

import UIKit
import EventKit
import EventKitUI

final class ForkPageViewController: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        var view = UIImageView()
        let image = logoImage
        view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateBase = DateBase.shared
    
    private let logoImage = Constants.ForkPageConstants.logoImage
    
    private let logoSide = Constants.ForkPageConstants.logoSide
    
    private let errorTitle = Constants.ForkPageConstants.errorTitle
    
    private let errorMessage = Constants.ForkPageConstants.errorMessage
    
    private let errorButtonTitle = Constants.ForkPageConstants.errorButtonTitle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addConstraints()
        UIBlockingProgressHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chekAccessStatus()
    }
    
    override func viewDidLayoutSubviews() {
        switch view.window?.windowScene?.screen.traitCollection.userInterfaceStyle {
                case .light:
                    view.backgroundColor = .white
                case .dark:
                    view.backgroundColor = .black
                case .unspecified:
                    view.backgroundColor = .white
                case .none:
                    view.backgroundColor = .white
                @unknown default:
                    assertionFailure("Unknown interface style")
                }
    }
    
   private func chekAccessStatus() {
       let completionHandler: EKEventStoreRequestAccessCompletionHandler = {
           [weak self] granted, error in
           // почему то complition handler не запускаеться на главном потоке автоматически
           switch granted {
           case true:
               DispatchQueue.main.async {
                   guard let self = self else { return }
                   self.goToMonthController()
                   UIBlockingProgressHUD.dismiss()
               }
           case false:
               DispatchQueue.main.async {
                   guard let self = self else { return }
                   UIBlockingProgressHUD.dismiss()
                   self.showErrorAlert(message: self.errorMessage, buttonTitle: self.errorButtonTitle, completion: self.chekAccessStatus)
               }
           }
       }
       askAccessToEvents(completion: completionHandler)
       
       UIBlockingProgressHUD.dismiss()
    }
    
    private func showErrorAlert(message: String, buttonTitle: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: errorTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: completion)
    }
    
    private func askAccessToEvents(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        if #available(iOS 17.0, *) {
            dateBase.eventStore.requestFullAccessToEvents(completion: completion)
        } else {
            dateBase.eventStore.requestAccess(to: .event, completion: completion)
        }
    }
    
    private func goToMonthController() {
        let viewModel = MonthViewModel()
        let nextController = MonthViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: nextController)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        
        let navigationBar = navigationController.navigationBar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

private extension ForkPageViewController {
    
     func addConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: logoSide),
            logoImageView.widthAnchor.constraint(equalToConstant: logoSide),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupView() {
        view.addSubview(logoImageView)
        view.backgroundColor = .clear
    }
    
}
