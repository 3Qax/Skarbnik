import Foundation
import UIKit



let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

class LoginViewController: UIViewController {
    var coordinator: LoginCoordinator?
    let loginModel: LoginModel
    let loginView: LoginView
    let incorrectCredentialsAlert: UIAlertController = {
        var alert = UIAlertController(title: NSLocalizedString("incorrect_credentials_header", comment: ""),
                                      message: NSLocalizedString("incorrect_credentials_description", comment: ""),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        return alert
    }()
    
    
    
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
        
            loginModel.login { (successful) in
                guard successful else {
                    DispatchQueue.main.async {
                        (self.view as! LoginView).showUI()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.coordinator!.didLoginSuccessfully()
                }
                
            }
        
        (self.view as! LoginView).delegate = self
        (self.view as! LoginView).loginInput.delegate = self
        (self.view as! LoginView).passwordInput.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if loginModel.isLoggedIn {
//            coordinator?.didRequestStudentChange()
//        }
    }
}

extension LoginViewController: LoginViewDelegate {
    
    func didTappedOutside() {
        (self.view as! LoginView).shouldResignAnyResponder()
    }
    
    func tryToLoginWith(login: String?, pass: String?) {
        notificationFeedbackGenerator.prepare()
        (self.view as! LoginView).startLoginAnimation()
        (self.view as! LoginView).shouldResignAnyResponder()
        
        loginModel.login(login: login, password: pass) { (successful) in
            guard successful else {
                DispatchQueue.main.async {
                    (self.view as! LoginView).stopLoginAnimation()
                    self.present(self.incorrectCredentialsAlert, animated: true)
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
        if textField == (self.view as! LoginView).loginInput as UITextField {
            _ = (self.view as! LoginView).passwordInput.becomeFirstResponder()
            return false
        }
        (self.view as! LoginView).loginButton.sendActions(for: .touchUpInside)
        return false
    }
}

