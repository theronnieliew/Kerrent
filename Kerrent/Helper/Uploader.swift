import Foundation
import Firebase
import FirebaseStorage

class Uploader{
    static func uploadImage(_ image : UIImage, of user :FIRUser?){
        let frStorageRef = FIRStorage.storage().reference()
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else{
            return
        }

        //To let storage know, the data uploaded is JPEG
        let newMetaData = FIRStorageMetadata()
        newMetaData.contentType = "image/jpeg"
        
        //THIS IS to modify saved pic file with userId string
        let firUser = user!
        let userID = firUser.uid
        let path = "\(userID)/carImg.jpeg"
        
        frStorageRef.child(path).put(imageData, metadata: newMetaData, completion : { (storageMeta, error) in
            if let uploadError = error{
                print(uploadError)
                // For debug only
                assertionFailure("Failed to upload") //! dont do this on production
            }
        })
    }
}
