//
//  EditarViewController.swift
//  FirebaseCrude
//
//  Created by Fernando Jt on 2/5/18.
//  Copyright © 2018 Fernando Jumbo Tandazo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
class EditarViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var genero: UITextField!
    
    var ref: DatabaseReference!
    var editarJuegos: Juegos!
    var plataforma:String!
    var id = ""
    var portada = ""
    var imagen = UIImage()
    var idFirebase = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
       nombre.text = editarJuegos.nombre
       genero.text = editarJuegos.genero
       id = editarJuegos.id!
        portada = editarJuegos.imagen!
         idFirebase = (Auth.auth().currentUser?.uid)!
        
        
    }

    
    @IBAction func editar(_ sender: UIButton) {
        
        let storage = Storage.storage().reference()
        let nombreImagen = UUID()
        let directorio = storage.child("imagenes/\(nombreImagen)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        directorio.putData(imagen.pngData()!, metadata: metaData) { (data, error) in
            if error == nil{
                print("Imagen cargada")
                let borrarImagen = Storage.storage().reference(forURL: self.portada)
                borrarImagen.delete(completion: nil)
                
                
                
                let campos = ["nombre":self.nombre.text!,
                              "genero":self.genero.text!,
                              "id":self.id, "portada":String(describing:directorio)]
                self.ref.child(self.idFirebase).child(self.plataforma).child(self.id).setValue(campos)
                self.dismiss(animated: true, completion: nil)
                
            }else{
                if let error = error?.localizedDescription{
                    print("Error al subir imagen ", error)
                }else{
                    print("error en el codigo")
                }
            }
        }
        
        
    }
    
    
    @IBAction func camara(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelar(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
