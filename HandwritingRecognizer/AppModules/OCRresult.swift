//
//  OCRresult.swift
//  HandwritingRecognizer
//
//  Created by Никита Иванов on 12/10/24.
//
import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct OCRResultView: View {
    let ocrResult: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Результат OCR")
                .font(.headline)
                .padding()
            
            ScrollView {
                Text(ocrResult)
                    .padding()
            }
            .frame(maxHeight: 300)
            .padding()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { shareAsRtf() }) {
                        Label("Share DOCX", systemImage: "doc.text")
                    }
                    
                    Button(action: { shareAsPdf() }) {
                        Label("Share PDF", systemImage: "doc.richtext")
                    }
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
    
    // Создание RTF файла
    private func createRtfFile(with text: String) -> URL {
        let rtfContent = """
        {\\rtf1\\ansi\\deff0
        {\\fonttbl{\\f0\\fswiss Helvetica;}}
        \\f0\\fs24 \(text)
        }
        """
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("ExportedFile.rtf")
        do {
            try rtfContent.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
        return fileURL
    }
    
    private func shareAsRtf() {
        let fileURL = createRtfFile(with: ocrResult)
        shareFile(fileURL: fileURL, contentType: UTType.rtf)
    }
    
    // Создание PDF файла
    private func createPdfFile(with text: String) -> URL {
        let pdfFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("ExportedFile.pdf")
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        do {
            try renderer.writePDF(to: pdfFileURL) { context in
                context.beginPage()
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 18),
                    .paragraphStyle: paragraphStyle
                ]
                let attributedText = NSAttributedString(string: text, attributes: attributes)
                attributedText.draw(in: pageRect.insetBy(dx: 20, dy: 20))
            }
        } catch {
            print(error)
        }
        
        return pdfFileURL
    }
    
    private func shareAsPdf() {
        let fileURL = createPdfFile(with: ocrResult)
        shareFile(fileURL: fileURL, contentType: UTType.pdf)
    }

    // Функция общего доступа
    private func shareFile(fileURL: URL, contentType: UTType) {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
 
