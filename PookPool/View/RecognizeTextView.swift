//
//  RecognizeTextView.swift
//  PookPool
//
//  Created by Assa Bentzur on 03/08/2022.
//

import SwiftUI
import Vision
import PhotosUI
import CoreData

struct RecognizeTextView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var photoPicker: PhotoPickerManager
    @EnvironmentObject var recognizeTextManager: RecognizeTextManager
    
    // MARK: Properties
    let parentProtocol: ProtocolPook
    
    var body: some View {
        VStack {
            Text("Steps from Picture")
                .font(.title)
                .underline()
                .bold()
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .background(.tertiary)
                
            // MARK: Select Photo from library
            Button(action: {
                photoPicker.source = .library
                photoPicker.showPhotoPicker()
            }) {
            Text("Photo from Library")
                    .font(.title2)
                    .bold()
                    .padding()
                    .background(.blue)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
            }
            // MARK: Select Photo from camera
            Button(action: {
                photoPicker.source = .camera
                photoPicker.showPhotoPicker()
            }) {
                Text("Camera")
                    .font(.title2)
                    .bold()
                    .padding()
                    .background(.blue)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
            }
            // TODO: Enable user to Crop image before processing
                Spacer(minLength: 20)
                // MARK: Show selected image
                if let image = photoPicker.image {
                    Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.4)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                }
                // MARK: Show recognized text
            ScrollView {
                VStack {
                    if (photoPicker.image != nil) {
                        Text("Recognized Text:")
                            .underline()
                            .frame(alignment: .center)
                    }
                    Text((photoPicker.image != nil) ? recognizeTextManager.recognizeText(image: photoPicker.image) : "No Image Selected")
                    .padding()
                    .font((photoPicker.image != nil) ? .body : .title3)
                    
                    // MARK: add the text to a new step
                    if (photoPicker.image != nil) {
                        Button(action: {
                            if (photoPicker.image != nil) {
                                recognizeTextManager.divideIntoSteps(text: recognizeTextManager.recognizeText(image: photoPicker.image), protocolName: parentProtocol.name!, context: managedObjectContext)
                                
                                self.presentationMode.wrappedValue.dismiss()
                            } //: if
                        }) {
                            Text(photoPicker.image != nil ? "Add Steps to Protocol" : "Load Image to\n Create Steps")
                                .font(.title3)
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(photoPicker.image != nil ? .blue : .gray)
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    } //: if
                    Spacer()
              } //: Vstack
             } //: Scroll
        } //: Vstack
        .sheet(isPresented: $photoPicker.showPicker) {
            ImagePicker(sourceType: photoPicker.source == .library ? .photoLibrary : .camera, selectedImage: $photoPicker.image)
                .ignoresSafeArea()
        }
    }
}

//struct RecognizeTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecognizeTextView(parentProtocol: ProtocolPook())
//    }
//}
