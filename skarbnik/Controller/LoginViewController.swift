import Foundation
import UIKit

var userModel: UserModel?

class LoginViewController: UIViewController {
    
    lazy var paymentViewController = PaymentViewController()
    
    override func loadView() {
        view = LoginView(frame: UIScreen.main.bounds)
    }
    
    func loginSuccessfull() {
        self.navigationController?.pushViewController(self.paymentViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userModel = UserModel(completion: { (succeed) in
            guard succeed else {
                DispatchQueue.main.async {
                    (self.view as! LoginView).showUI()
                }
                return
            }
            DispatchQueue.main.async {
                self.loginSuccessfull()
            }
        })
        
        (self.view as! LoginView).delegate = self
        (self.view as! LoginView).loginInput.delegate = self
        (self.view as! LoginView).passwordInput.delegate = self
    }
}

extension LoginViewController: LoginViewProtocol {
    
    func didTappedOutside() {
        (self.view as! LoginView).shouldResignAnyResponder()
    }
    
    func tryToLoginWith(login: String?, pass: String?) {
        (self.view as! LoginView).startLoginAnimation()
        (self.view as! LoginView).shouldResignAnyResponder()
        
        userModel = UserModel(login: login, password: pass, initCompletion: { succeed in
            guard succeed else {
                DispatchQueue.main.async {
                    (self.view as! LoginView).stopLoginAnimation()
                }
                return
            }
            DispatchQueue.main.async {
                self.loginSuccessfull()
            }
        })
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

