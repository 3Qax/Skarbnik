import Foundation
import UIKit



let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

class LoginViewController: UIViewController {
    var coordinator: LoginCoordinator?
    let loginModel: LoginModel
    let loginView: LoginView
    
    
    
    override func loadView() {
        view = loginView
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        loginView = LoginView(frame: UIScreen.main.bounds)
        loginModel = LoginModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        loginView.delegate = self
        loginView.loginInput.delegate = self
        loginView.passwordInput.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if loginModel.isLoggedIn {
//            coordinator?.didRequestStudentChange()
//        }
    }
    
    func tryToLogin() {
        loginModel.login { (successful) in
            guard successful else {
                DispatchQueue.main.async { self.coordinator?.loginRequireCredentials() ;(self.view as! LoginView).showUI() }
                return
            }
            DispatchQueue.main.async {
                self.coordinator!.didLoginSuccessfully()
            }
            
        }
    }
}

extension LoginViewController: LoginViewDelegate {
    
    func didTappedOutside() {
        loginView.shouldResignAnyResponder()
    }
    
    func tryToLoginWith(login: String?, pass: String?) {
        notificationFeedbackGenerator.prepare()
        loginView.startLoginAnimation()
        loginView.shouldResignAnyResponder()
        
        loginModel.login(login: login, password: pass) { (successful) in
            guard successful else {
                DispatchQueue.main.async {
                    self.loginView.stopLoginAnimation()
                    AlertBuilder()
                        .basicAlert(withTitle: NSLocalizedString("incorrect_credentials_header", comment: ""))
                        .setMessage(NSLocalizedString("incorrect_credentials_description", comment: ""))
                        .show(in: self)
                    notificationFeedbackGenerator.notificationOccurred(.error)
                }
                return
            }
            DispatchQueue.main.async {
                    notificationFeedbackGenerator.notificationOccurred(.success)
                    self.coordinator!.didLoginSuccessfully()
            }
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.loginInput as UITextField {
            _ = loginView.passwordInput.becomeFirstResponder()
            return false
        }
        loginView.loginButton.sendActions(for: .touchUpInside)
        return false
    }
}

