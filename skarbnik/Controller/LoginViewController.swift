import Foundation
import UIKit



class LoginViewController: UIViewController {
    
    let loginController = LoginController()
    lazy var paymentViewController = PaymentViewController()
    
    override func loadView() {
        view = LoginView(frame: UIScreen.main.bounds)
    }
    
    func loginSuccessfull() {
        self.navigationController?.pushViewController(self.paymentViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.view as! LoginView).delegate = self
        
        //should start with trying to log in with localy stored JWT
        //while still acting like launch screen is being shown
        loginController.login { (succeed) in
            guard succeed else {
                //if log in attempt fails show UI so a user can log in
                (self.view as! LoginView).showUI()
                return
            }
            self.loginSuccessfull()
        }
    }    
}

extension LoginViewController: LoginViewProtocol {
    func tryToLoginWith(login: String?, pass: String?) {
        (self.view as! LoginView).startLoginAnimation()
        loginController.login(login: login, password: pass, completition: { succeed in
            guard succeed else {
                (self.view as! LoginView).stopLoginAnimation()
                return
            }
            self.loginSuccessfull()
        })
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

