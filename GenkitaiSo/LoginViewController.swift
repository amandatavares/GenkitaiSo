//
//  LoginViewController.swift
//  GekitaiSo
//
//  Created by Amanda Tavares on 24/03/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var codeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RPCManager.shared.run { (port) in
            DispatchQueue.main.async {
                self.codeLabel.text = String(port)
            }
        }
        
        RPCManager.shared.onStart {
            UserDefaults.standard.set(1, forKey: "number")
            self.start()
        }
        
        self.codeView.layer.cornerRadius = 10
        self.startView.layer.cornerRadius = 10
        self.startButton.isEnabled = false
    }
    
    @IBAction func invite(_ sender: UIButton) {
        
        let name = codeTextField.text!
        
        guard let port = Int(codeTextField.text!) else { return }
        
        RPCManager.shared.client.port = port
        
        RPCManager.shared.client.invite(name: name) { (success) in
            if success {
                UserDefaults.standard.set(name, forKey: "name")
                codeTextField.isEnabled = false
                sender.backgroundColor = .systemPurple
                sender.setTitle("Connection sucessful", for: .normal)
                self.startButton.isEnabled = true
            }
        }
    }
    
    
    @IBAction func start(_ sender: Any) {
        RPCManager.shared.client.start { (success) in
            if success {
                UserDefaults.standard.set(0, forKey: "number")
                self.start()
            }
        }
    }
    
    
    private func start() {
        DispatchQueue.main.async {
            self.startButton.isEnabled = false
            self.startButton.alpha = 0.5
            
            //NotificationCenter.default.post(name: .start, object: nil)
            
            let chat = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameRoom") as! GameViewController
            
            chat.view.frame = self.view.bounds
            
            self.view.addSubview(chat.view)
            
            UIView.transition(from: self.view, to: chat.view, duration: 0.25, options: .transitionCrossDissolve) { _ in
                chat.didMove(toParent: self)
                chat.didStart()
                
            }
            
        }
        
    }

}
