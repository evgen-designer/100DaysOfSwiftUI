//
//  ContentView.swift
//  Instafilter
//
//  Created by Mac on 09/10/2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var currentFilterName: String = "Sepia tone"
    
    let context = CIContext()
    
    let filterNames: [String: CIFilter] = [
        "Crystallize": CIFilter.crystallize(),
        "Edges": CIFilter.edges(),
        "Gaussian blur": CIFilter.gaussianBlur(),
        "Pixellate": CIFilter.pixellate(),
        "Sepia tone": CIFilter.sepiaTone(),
        "Unsharp mask": CIFilter.unsharpMask(),
        "Vignette": CIFilter.vignette(),
        "Motion blur": CIFilter.motionBlur(),
        "Comic effect": CIFilter.comicEffect(),
        "Color invert": CIFilter.colorInvert()
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                if processedImage != nil {
                    HStack {
                        Button(currentFilterName) {
                            changeFilter()
                        }
                        Spacer()
                        if let processedImage {
                            ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                        }
                    }
                    .padding(.vertical, 20)
                    
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) ||
                       currentFilter.inputKeys.contains(kCIInputRadiusKey) ||
                       currentFilter.inputKeys.contains(kCIInputScaleKey) {
                        
                        VStack {
                            if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                                HStack {
                                    Text("Intensity")
                                    Slider(value: $filterIntensity, in: 0...1)
                                        .onChange(of: filterIntensity, applyProcessing)
                                }
                                .padding(.vertical, 10)
                            }
                            
                            if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                                HStack {
                                    Text("Radius")
                                    Slider(value: $filterRadius, in: 0...1)
                                        .onChange(of: filterRadius, applyProcessing)
                                }
                                .padding(.vertical, 10)
                            }
                            
                            if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                                HStack {
                                    Text("Scale")
                                    Slider(value: $filterScale, in: 0...1)
                                        .onChange(of: filterScale, applyProcessing)
                                }
                                .padding(.vertical, 10)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select filter", isPresented: $showingFilters) {
                ForEach(filterNames.keys.sorted(), id: \.self) { filterName in
                    Button(filterName) { setFilter(filterName) }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filterName: String) {
        if let filter = filterNames[filterName] {
            currentFilter = filter
            currentFilterName = filterName
        }
        loadImage()
        
        filterCount += 1
        
        if filterCount >= 20 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
