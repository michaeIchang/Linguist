import ImagePlayground
import Playgrounds

#if canImport(ImagePlayground)
#Playground {
 if #available(iOS 18.0, *) {
   let creator = try await ImageCreator()
   let images = creator.images(
     for: [.text("A dog in the park")],
     style: .illustration,
     limit: 1
   )
   for try await image in images {
     image.cgImage
   }
 } else {
   "Image Playground not supported on this device or OS."
 }
}
#endif // canImport(ImagePlayground)
