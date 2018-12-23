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
                print("login unsuccessfull dupa321")
                DispatchQueue.main.async {
                    (self.view as! LoginView).showUI()
                }
                return
            }
            print("login successfull dupa123")
            DispatchQueue.main.async {
                self.loginSuccessfull()
            }
        })
        
        (self.view as! LoginView).delegate = self
    }
}

extension LoginViewController: LoginViewProtocol {
    func tryToLoginWith(login: String?, pass: String?) {
        
        (self.view as! LoginView).startLoginAnimation()
        
        userModel = UserModel(login: login, password: pass, completion: { succeed in
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
        textField.resignFirstResponder()
        return true
    }
}

