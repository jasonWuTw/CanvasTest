//
//  ViewController.swift
//  CanvasTest
//
//  Jason Wu

import UIKit
import PhotosUI

// 設為全域變數，可被呼叫
var brushType = "Paintbrush"
/*捏合手勢*/
var isPinch = true
var canvas_diagonal_length:Float = 0    //對角線長度
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var paintSwitch: UISwitch!
    @IBOutlet weak var ColorCollectionView: UICollectionView!
    @IBOutlet weak var canvas: ConvasView!
    
    //cell要的顏色
    let colorArray = [ #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ]
    
    /* 此變數用來裝修正後圖片 **/
    var resetImage = UIImage()
    
    /** 宣告一個array莊每一個顏色是諷是否被選取，被選取時為true 否則為false */
    var selectedCheck: [Bool] = []
    
    var scaleNew: CGFloat = 1
        
    override func viewDidLoad() {
        super.viewDidLoad()
        /* 是否限制畫板範圍只能在bounds內 > true **/
        canvas.clipsToBounds = true
        /* 將多點觸控關閉 > 單點觸控 **/
        canvas.isMultipleTouchEnabled = true
        
        ColorCollectionView.dataSource = self
        ColorCollectionView.delegate = self
        ColorCollectionView.allowsMultipleSelection = false
        
        /** 預設顏色為第一個顏色 */
        lineColor = colorArray[0]
                
        // 添加拖動手勢
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panImage))
//        canvas.addGestureRecognizer(panGestureRecognizer)
                
        //添加縮放手勢
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage))
        canvas.addGestureRecognizer(pinchGestureRecognizer)
        
        let rightBottomCorner = CGPoint(x: view.frame.origin.x + view.frame.size.width, y: view.frame.origin.y + view.frame.size.height)
        let canvas_diagonal_length = distance(between:canvas.frame.origin,and:rightBottomCorner)
        //print("canvas_diagonal_length : ",canvas_diagonal_length)
    }
    
    //捏合手勢
    @objc func pinchImage(_ gesture: UIPinchGestureRecognizer) {
        //print("paintSwitch.isOn:",paintSwitch.isOn)
        if(paintSwitch.isOn==false){
            if gesture.state == .began {
                // 捏合手勢開始
                gesture.scale = scaleNew
            }else if gesture.state == .changed {
                // 获取手势的缩放比例
                let scale = gesture.scale
                let tmpScale = scaleNew * scale
                if(tmpScale > 1 && tmpScale < 10){
                    // 缩放图像
                    canvas.transform = canvas.transform.scaledBy(x: scale, y: scale)
                    scaleNew = tmpScale
                    // 重置缩放比例，以便下次手势开始时从上一次的缩放比例继续
                    gesture.scale = 1.0
                }
            }else if gesture.state == .ended {
                // 捏合手勢結束
                //gesture.scale = scaleNew
            }
        }
    }

    
//    @objc func panImage(_ sender: UIPanGestureRecognizer) {
//        // 計算拖動手勢的移動距離
//        let translation = sender.translation(in: canvas)
//        // 更新 UIView 的位置
//        canvas.center = CGPoint(x: canvas.center.x + translation.x, y: canvas.center.y + translation.y)
////        // 限制圖片的移動範圍
////        canvas.center.x = max(canvas.center.x, canvas.bounds.minX)
////        canvas.center.x = min(canvas.center.x, canvas.bounds.maxX)
////        canvas.center.y = max(canvas.center.y, canvas.bounds.minY)
////        canvas.center.y = min(canvas.center.y, canvas.bounds.maxY)
//        // 清除拖動手勢的移動距離
//        sender.setTranslation(CGPoint.zero, in: canvas)
//    }

    
    /* 清除畫布 **/
    @IBAction func clear(_ sender: UIButton) {
        canvas.clearCanvas()
        // 缩放图像
        canvas.transform = canvas.transform.scaledBy(x: 1/scaleNew, y: 1/scaleNew)
        paintSwitch.isOn = true
        isPinch=true
        scaleNew=1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        cell.ColorView.backgroundColor = colorArray[indexPath.item]
                
        /** 初始設定 */
        // 初始先設定第一個 item 為已選取
         if selectedCheck == [] {             // Array為空時(一開始未選擇顏色時)
             selectedCheck.append(true)       // 預設已選取第一格顏色 先將第一個加入true
             
             for _ in 1...colorArray.count {
                 selectedCheck.append(false)  // 依序將後續的顏色加入false：為未被選取
             }
         }
        // 判斷collection view 是否已被選取
        if selectedCheck[indexPath.item] == true {    // "== true" 亦可省略
            cell.layer.cornerRadius = 50
            cell.layer.borderWidth = 8
            cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        } else {
            cell.layer.cornerRadius = 50
            cell.layer.borderWidth = 0
            cell.layer.borderColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0).cgColor
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 取得點擊collectionView.item的view顏色
        // 將顏色給 color
        let colorIndex = colorArray[indexPath.item]
        lineColor = colorIndex
        
        /** 點選item時操作 */
        for i in 0...(selectedCheck.count - 1)  {
            selectedCheck[i] = false              // 1. 先將Bool陣列轉為false：重置選取狀態
         }
        
        selectedCheck[indexPath.item] = true      // 2. 再將選取的item轉為true
        ColorCollectionView.reloadData()            // 3. reloadData(重新變更cell狀態)
    }
    
    /* 設定畫布背景色 **/
    @IBAction func setBackgroundColor(_ sender: UISwitch) {
        if paintSwitch.isOn {
            //canvas.isMultipleTouchEnabled = false
            // remove捏合手勢
            //canvas.removeGestureRecognizer(pinchGestureRecognizer)
            isPinch=true
            //print("paintSwitch.isOn")
            //canvas.backgroundColor = UIColor(patternImage: resetImage)
            //brushType="Paintbrush"
        } else {
            //canvas.isMultipleTouchEnabled = true
            // 添加捏合手勢
            //canvas.addGestureRecognizer(pinchGestureRecognizer)
            isPinch=false
            //print("paintSwitch.isOFF")
            //canvas.backgroundColor = .black
            //brushType="Rectangle"
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
        controller.isEditing = true
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    /* 儲存所有Points **/
    @IBAction func saveView(_ sender: UIBarButtonItem) {
        //顯示所有Points
        if(canvas.rectPoints.isEmpty){
            print("沒有長方形\n")
        }else{
            print("長方形:\n")
            print(canvas.rectPoints)
            print("\n")
        }
        if(canvas.pathPoints.isEmpty){
            print("沒有畫筆\n")
        }else{
            var index=0
            var count=1
            for element in canvas.countPaintbrushArray {
                print("畫筆",count)
                //print(element, terminator: " ")
                for j in index..<element {
                    print(canvas.pathPoints[j], terminator: " ")
                }
                print("")
                index=element
                count+=1
            }
        }
        
        //todo 將canvas轉為image物件
        //mage物件轉為png檔案
        //png檔案存到本地的相簿
        // 建立 UIGraphicsImageRenderer 物件
        let renderer = UIGraphicsImageRenderer(size: canvas.bounds.size)
        // 使用 UIGraphicsImageRenderer 物件來繪製 canvas
        let image = renderer.image { (context) in
            canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: true)
        }
        // 将 UIImage 转成 png 数据
        guard let pngData = image.pngData() else {
          print("无法转换成 PNG 格式")
          return
        }
        // 將 PNG 數據保存到相冊
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: pngData, options: nil)
        }) { (success, error) in
            if success {
                print("圖像已保存到相冊")
            } else if let error = error {
                print("錯誤：\(error.localizedDescription)")
            }
        }
        
        
//        let controller = UIAlertController(title: "分享", message: nil, preferredStyle: .actionSheet)
//        let saveAction = UIAlertAction(title: "輸出", style: .default) { (_) in
//            /// 分享器 UIGraphicsRenderer > 分享的view範圍
//            let renderer = UIGraphicsImageRenderer(size: self.canvas.bounds.size)
//            let image = renderer.image (actions: { (context) in
//                                            self.canvas.drawHierarchy(in: self.canvas.bounds, afterScreenUpdates: true)})
//            /* UIActivityViewController > 分享介面 */
//            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//            self.present(activityViewController, animated: true, completion: nil)
//        }
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        controller.addAction(saveAction)
//        controller.addAction(cancelAction)
//        present(controller, animated: true, completion: nil)
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


