//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by MAC04 on 21/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase
class ImagenViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion:nil)
    }
    @IBAction func camaraTaped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func elegirContactoTapped(_ sender: Any) {
        elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = UIImagePNGRepresentation(imageView.image!)!
        let imagen = imagenesFolder.child("\(imagenID).jpg")
        imagen.putData(imagenData,metadata: nil) {(metadata, error) in
                                                        if error != nil {
                                                            self.mostrarAlerta(title: "Error", message: "Se produjo un error al subir la imagen. Vuelva a intentarlo", action: "Cancelar")
                                                            self.elegirContactoBoton.isEnabled = true
                                                            print("Ocurrio un error al subir imagen: \(error)")
                                                            return
                                                        }else{
                imagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(title: "Error", message: "Se produjo un error al obtener la informacion de la imagen", action: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion de imagen\(error)")
                        return
                    }
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                })
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        
    }
    func mostrarAlerta(title: String, message: String, action: String) {
        let alertGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelok = UIAlertAction(title: action, style: .default, handler: nil)
        alertGuia.addAction(cancelok)
        present(alertGuia, animated: true, completion: nil)
    }
}
