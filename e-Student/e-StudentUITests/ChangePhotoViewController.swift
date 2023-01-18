//
//  ChangePhotoViewController.swift
//  e-Student
//
//  Created by Lyubomir on 15.01.23.
//

import UIKit

class ChangePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var changePhotoButton: UIButton!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImage()
        
        
        
    }
    
    func setupImage() {
        photo.image = Model.currentUserImage
        photo.layer.borderWidth = 1
        photo.layer.masksToBounds = false
        photo.layer.borderColor = UIColor.black.cgColor
        photo.layer.cornerRadius = photo.frame.height/2 - 11
        photo.clipsToBounds = true
        photo.contentMode = .scaleAspectFill
    }


    @IBAction func changePhotoButtonTapped(_ sender: UIButton) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Смяна на профилна снимка", message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Отвори камера", style: .default) { _ in
            self.openCamera()
        }

        let secondAction: UIAlertAction = UIAlertAction(title: "Избери от галерията", style: .default) { _ in
            self.openImagePicker()
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Отказ", style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            photo.image = image
        }
    }

    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let imageData = photo.image?.jpegData(compressionQuality: 1)
        // Convert image Data to base64 encodded string
        let imageBase64String = imageData?.base64EncodedString()
        //print(imageBase64String ?? "Could not encode image to Base64")
        guard let imageString = imageBase64String else { return }
        DataApiManager.updateProfilePhoto(idn: Model.currentStudent.idn, imageData: imageString) { result in
            switch result {
            case .success(_):
                print("Photo Updated")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                NotificationCenter.default.post(name: NSNotification.Name("PhotoUpdated"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
