//
//  ConvasView.swift
//  CanvasTest
//
//

import UIKit

// 畫筆顏色 > 設為全域變數，可被呼叫
var lineColor = UIColor()
class ConvasView: UIView {
    // 畫筆粗細
    var lineWidth:CGFloat = 8
    // 貝茲曲線 > 紀錄兩點間連接的路徑
    var path: UIBezierPath?
    // 儲存碰觸的點 (線由很多點形成)
    var touchPoint: CGPoint!
    // 儲存開始作畫的點
    var startPoint: CGPoint!
    // 所有Points放在array
    var pathPoints: [CGPoint] = []

    /* 設定開始作畫的func(點擊畫面的當下呼叫) **/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 取得點下去的第一個點，存入startPoint中，self > ConvasView
        startPoint = touches.first?.location(in: self)
        //Points放在array
        pathPoints.append(startPoint)
    }
    
    /* 設定按住滑動時的func **/
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 取得目前滑動的點，存入touchPoint中，self > ConvasView
        touchPoint =  touches.first?.location(in: self)
        path = UIBezierPath()   // UIBezierPath()：路徑宣告成物件（初始化）
        /// 1.設定其中一個路徑的端點到startPoint（起點）
        path?.move(to: startPoint)
        /// 2.再拉一條線到touchPoint（另一個端點）
        path?.addLine(to: touchPoint)
        /// 3.將 touchPoint指派給startPoint：如果手拿起來再放下去的話，可以從上次畫的斷點當作起點再繼續畫下去
        startPoint = touchPoint
        //Points放在array
        pathPoints.append(startPoint)
        // 呼叫對線條上色的方法
        draw()
    }
    
    /* 對畫過的路徑上色 **/
    func draw() {
        let shapeLayer = CAShapeLayer()
        /// 將path( 路徑 )的型別轉換為 cgPath
        shapeLayer.path = path?.cgPath
        /// 設定筆鋒(筆畫)的顏色
        shapeLayer.strokeColor = lineColor.cgColor
        /// 設定線條的粗細
        shapeLayer.lineWidth = lineWidth
        /// 設定線條的填色，clear > 無填色，.fillColor的型別為cgColor，所以需要轉型
        shapeLayer.fillColor = UIColor.clear.cgColor
        /// 將設定好的 layer ( 圖層，UIView的子類別 )，設定到 self中( Canvas )。此時還不會顯示在畫面上
        self.layer.addSublayer(shapeLayer)
        /// 顯示線條在畫面上( 重新繪製 )
        self.setNeedsDisplay()
    }
    
    /* 清除所有的點 **/
    func clearCanvas() {
        // 清除所有的點
        path?.removeAllPoints()
        // 清空設定的shapeLayer（路徑）
        self.layer.sublayers = nil
        // 顯示線條在畫面上( 重新繪製 )
        self.setNeedsDisplay()
        //清空Points array
        pathPoints.removeAll()
    }
    
}
