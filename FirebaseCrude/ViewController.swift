//
//  ViewController.swift
//  FirebaseCrude
//
//  Created by Fernando Jt on 16/4/18.
//  Copyright © 2018 Fernando Jumbo Tandazo. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var control: UISegmentedControl!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       login()
    }

    @IBAction func entrar(_ sender: UIButton) {
        
        if control.selectedSegmentIndex == 0{
            iniciarSesion(correo: correo.text!, password: password.text!)
        }else{
            registrarse(correo: correo.text!, password: password.text!)
        }
        
    }
    
    func iniciarSesion(correo:String, password:String){
        Auth.auth().signIn(withEmail: correo, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "inicio", sender: self)
            }else{
                if let error = error?.localizedDescription{
                    print("error firebase de iniciar sesion", error)
                }else{
                    print("error de codigo", error!)
                }
            }
        }
    }

    func registrarse(correo:String, password:String){
        
        Auth.auth().createUser(withEmail: correo, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "inicio", sender: self)
            }else{
                if let error = error?.localizedDescription{
                    print("error firebase de registro", error)
                }else{
                    print("error de codigo", error!)
                }
            }
        }
    }
    
    func login(){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                print("no esta logeado")
            }else{
                self.performSegue(withIdentifier: "inicio", sender: self)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

