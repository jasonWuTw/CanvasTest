//
//  ViewController.swift
//  CanvasTest
//
//  Created by 陳暘璿 on 2020/12/25.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var backgroundSwitch: UISwitch!
    @IBOutlet weak var ColorCollectionView: UICollectionView!
    @IBOutlet weak var canvas: ConvasView!
    
    //cell要的顏色
    let colorArray = [ #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ]
    
    /* 此變數用來裝修正後圖片 **/
    var resetImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* 是否限制畫板範圍只能在bounds內 > true **/
        canvas.clipsToBounds = true
        /* 將多點觸控關閉 > 單點觸控 **/
        canvas.isMultipleTouchEnabled = false
        
        ColorCollectionView.dataSource = self
        ColorCollectionView.delegate = self
        
    }
    
    /* 清除畫布 **/
    @IBAction func clear(_ sender: UIButton) {
        canvas.clearCanvas()
        canvas.backgroundColor = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        cell.ColorView.backgroundColor = colorArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 取得點擊collectionView.item的view顏色
        let colorIndex = colorArray[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath)
        // 設定為不能複選
        collectionView.allowsMultipleSelection = false
        cell?.layer.cornerRadius = 25
        cell?.layer.borderWidth = 5
        cell?.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        
        // 將顏色給 color
        lineColor = colorIndex
    }
    /* 沒被選中的item **/
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
        cell?.layer.borderColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0).cgColor
    }
    
    /* 設定畫布背景色 **/
    @IBAction func setBackgroundColor(_ sender: UISwitch) {
        if backgroundSwitch.isOn {
            canvas.backgroundColor = UIColor(patternImage: resetImage)
        } else {
            canvas.backgroundColor = .black
        }
    }
    
    /* 選擇相簿圖片（單張） **/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /* 將圖片修改為與canvas相同大小 **/
        if let image = (info[.originalImage] as? UIImage) {
            resetImage = resizeImage(image: image, width: self.canvas.frame.width, height: self.canvas.frame.height)
        }
        self.canvas.backgroundColor = UIColor(patternImage: resetImage)
        self.canvas.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    /* 選擇照片設為背景 **/
    @IBAction func pickerImage(_ sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    /* 儲存成相片 **/
    @IBAction func saveView(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "分享", message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "輸出", style: .default) { (_) in
            /// 分享器 UIGraphicsRenderer > 分享的view範圍
            let renderer = UIGraphicsImageRenderer(size: self.canvas.bounds.size)
            let image = renderer.image (actions: { (context) in
                                            self.canvas.drawHierarchy(in: self.canvas.bounds, afterScreenUpdates: true)})
            /* UIActivityViewController > 分享介面 */
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(saveAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController {
    /* 修改圖片尺寸 **/
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        /* 設定指定的尺寸 **/
        let size = CGSize(width: width, height: height)
        /* UIGraphicsImageRenderer > 繪製圖型方法 **/
        let renderer = UIGraphicsImageRenderer(size: size)
        /* 重新繪製縮小後的圖片 **/
        let newImage = renderer.image { (context) in
            image.draw(in: renderer.format.bounds)
        }
        return newImage
    }
}

