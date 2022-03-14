//
//  ViewController.swift
//  PDFKitDemo
//
//  Created by Hiloliddin on 11/03/22.
//
import PDFKit
import UIKit

class EOPDFReaderViewController: UIViewController, PDFViewDelegate, URLSessionDelegate {
    
    // Views
    let pdfView = PDFView()
    var pdfURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        
        guard let url = pdfURL else {return}
        guard let document = PDFDocument(url: url) else {return}
        pdfView.document = document
        pdfView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.frame
    }
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    func downloadPDF(urlStr: String, completionHandler: @escaping CompletionHandler) {
        
        let fileName = fileNameFromUrlString(urlString: urlStr)
        
        var ifExistsPath: String?
        
        if fileName != nil {
            ifExistsPath = filePathIfExists(fileName: fileName!)
        }
        
        if ifExistsPath != nil {
            print("FILE EXISTS!!!!")
            self.pdfURL = URL(fileURLWithPath: ifExistsPath!)
            completionHandler(true)
            
        } else {
            print("FILE DOES NOT EXIST, DOWNLOADING...")
            
            guard let url = URL(string: urlStr) else { return }
            
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            
            let downloadTask = urlSession.downloadTask(with: url) { fileURL, response, error in
                
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    completionHandler(false)
                } else {
                    print("Downloaded URL: \(String(describing: fileURL))")
                    
                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
                    //delete original copy
                    try? FileManager.default.removeItem(at: destinationURL)
                    //copy from temp to Document
                    do {
                        try FileManager.default.copyItem(at: fileURL!, to: destinationURL)
                        self.pdfURL = destinationURL
                        print("downloaded Document Address:", self.pdfURL ?? "")
                        completionHandler(true)
                    } catch let error {
                        print("Copy Error: \(error.localizedDescription)")
                        completionHandler(false)
                    }
                }
            }
            downloadTask.resume()
        }
    }
    
    func fileNameFromUrlString(urlString: String) -> String? {
        guard let index = urlString.lastIndex(of: "/") else {return nil}
        let nextIndex = urlString.index(after: index)
        let fileName = String(urlString[nextIndex...])
        print("FILE NAME: \(fileName)")
        return fileName
    }
    
    
    func filePathIfExists(fileName: String) -> String? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE, Path: \(filePath)")
                return filePath
            } else {
                print("FILE NOT AVAILABLE")
                return nil
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
            return nil
        }
    }
    
}

