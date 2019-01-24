//
//  InicioViewController.swift
//  FirebaseCrude
//
//  Created by Fernando Jt on 18/4/18.
//  Copyright © 2018 Fernando Jumbo Tandazo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class InicioViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var cargador: UIActivityIndicatorView!
    @IBOutlet weak var juego: UITextField!
    @IBOutlet weak var genero: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    var plataforma:String = ""
    var imagen = UIImage()
    let plataformas = ["PLAYSTATION 4","XBOX ONE","NINTENDO SWITCH","PC"]
    var ref:DatabaseReference!
    var idFirebase = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
        let correo = Auth.auth().currentUser?.email
        idFirebase = (Auth.auth().currentUser?.uid)!
        print(idFirebase)
        print("El correo de usuario es: ,\(correo!)")
        ref = Database.database().reference()
       
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return plataformas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return plataformas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        plataforma = plataformas[row]
        
    }

    
    @IBAction func guardar(_ sender: UIButton) {
        let id = ref.childByAutoId().key // para generar un id
        
        let storage = Storage.storage().reference()
        let nombreImagen = UUID()
        let directorio = storage.child("imagenes/\(nombreImagen)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        directorio.putData(imagen.pngData()!, metadata: metaData) { (data, error) in
            if error == nil{
                print("Imagen cargada")
                self.cargador.stopAnimating()
                self.cargador.isHidden = true
            }else{
                if let error = error?.localizedDescription{
                    print("Error al subir imagen ", error)
                }else{
                    print("error en el codigo")
                }
            }
        }
        
        let campos = ["nombre":juego.text!,"genero":genero.text!,"id":id,"portada": String(describing:directorio)]
        
        ref.child(idFirebase).child(plataforma).child(id).setValue(campos)
        cargador.isHidden = false
        cargador.startAnimating()
        print("guardo")
        limpiar()
        
    }
    
    
    
   
    @IBAction func salir(_ sender: UIButton) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "login", sender: self)
    }
    
    func limpiar(){
        juego.text = ""
        genero.text = ""
    }
    
    
    @IBAction func tomarFoto(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let imagenTomada = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        imagen = imagenTomada!
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
