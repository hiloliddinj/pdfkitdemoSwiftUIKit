//
//  ButtonVCViewController.swift
//  PDFKitDemo
//
//  Created by Hiloliddin on 11/03/22.
//

import UIKit

class ButtonVC: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GO TO PDF Reader", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc func onButtonPress() {
        let pdfLink: String = "https://carlosicaza.com/swiftbooks/SwiftLanguage.pdf"
        //let pdf1Link: String = "https://makon.app/pdf_for_download_testing.pdf"
        //let pdf2Link: String = "https://makon.app/pdf_for_download_testing2.pdf"
        
        let vc = EOPDFReaderViewController()
        vc.downloadPDF(urlStr: pdfLink, completionHandler: { success in
            //showLoading
            if success {
                //closeLoading
                print("success: \(success). ==> Navigating")
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } else {
                //closeLoading
                print("success: \(success)")
            }
        })
    }
}
