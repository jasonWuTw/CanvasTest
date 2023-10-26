//
//  ConvasViewRect.swift
//  CanvasTest
//
//  Created by andy on 2023/10/25.
//


import UIKit

class ConvasViewRect: UIView {
    // 畫筆粗細
    var lineWidth:CGFloat = 8
    // 貝茲曲線 > 紀錄兩點間連接的路徑
    var path: UIBezierPath?
    // 儲存碰觸的點 (線由很多點形成)
    var touchPoint: CGPoint!
    // 儲存開始作畫的點
    var startPoint: CGPoint!
    var endPoint: CGPoint!
    // 所有Points放在array
    var pathPoints: [CGPoint] = []
    var isAddLayer: Bool=true
    var oldLayer: CALayer!
    
    /* 設定開始作畫的func(點擊畫面的當下呼叫) **/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 取得點下去的第一個點，存入startPoint中，self > ConvasView
        startPoint = touches.first?.location(in: self)
        //draw(start: startPoint,end: endPoint,isTouchBdgin: true)
        //Points放在array
        //pathPoints.append(startPoint)
    }
    
    /* 設定結束滑動時的func **/
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 取得目前滑動的點，存入touchPoint中，self > ConvasView
        endPoint =  touches.first?.location(in: self)
        draw(start: startPoint,end: endPoint)
        isAddLayer=true
    }
    
    /* 設定按住滑動時的func **/
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 取得目前滑動的點，存入touchPoint中，self > ConvasView
        touchPoint =  touches.first?.location(in: self)
        /*path = UIBezierPath()   // UIBezierPath()：路徑宣告成物件（初始化）
        /// 1.設定其中一個路徑的端點到startPoint（起點）
        path?.move(to: startPoint)
        /// 2.再拉一條線到touchPoint（另一個端點）
        path?.addLine(to: touchPoint)
        /// 3.將 touchPoint指派給startPoint：如果手拿起來再放下去的話，可以從上次畫的斷點當作起點再繼續畫下去
        startPoint = touchPoint
        //Points放在array
        pathPoints.append(startPoint)*/
        // 呼叫對線條上色的方法
        draw(start: startPoint,end: touchPoint)
        
        
    }
    
    /* 對畫過的路徑上色 **/
    func draw(start: CGPoint,end: CGPoint) {
        /*let shapeLayer = CAShapeLayer()
         /// 將path( 路徑 )的型別轉換為 cgPath
         shapeLayer.path = path?.cgPath
         /// 設定筆鋒(筆畫)的顏色
         shapeLayer.strokeColor = rectColor.cgColor
         /// 設定線條的粗細
         shapeLayer.lineWidth = lineWidth
         /// 設定線條的填色，clear > 無填色，.fillColor的型別為cgColor，所以需要轉型
         shapeLayer.fillColor = UIColor.clear.cgColor
         /// 將設定好的 layer ( 圖層，UIView的子類別 )，設定到 self中( Canvas )。此時還不會顯示在畫面上
         self.layer.addSublayer(shapeLayer)
         /// 顯示線條在畫面上( 重新繪製 )
         self.setNeedsDisplay()
         */
        
        // 建立一個 CAShapeLayer 物件，用來描述繪圖形狀
        let shapeLayer = CAShapeLayer()
        var leftX: Double
        var topY: Double
        // 設定 CAShapeLayer 物件的屬性
        shapeLayer.fillColor = nil //UIColor.red.cgColor
        shapeLayer.strokeColor =   lineColor.cgColor//UIColor.clear.cgColor//UIColor.black.cgColor
        shapeLayer.lineWidth = 5
        if(start.x<end.x){leftX=start.x}
        else {leftX=end.x}
        if(start.y<end.y){topY=start.y}
        else {topY=end.y}
        shapeLayer.path = UIBezierPath(rect: CGRect(x: leftX, y: topY, width: abs(start.x-end.x), height: abs(start.y-end.y))).cgPath
        // 將 CAShapeLayer 物件加入到 UIView 物件中
        if isAddLayer{
            self.layer.addSublayer(shapeLayer)
            oldLayer=shapeLayer
            isAddLayer=false
        }else{
            self.layer.replaceSublayer(oldLayer, with: shapeLayer)
            oldLayer=shapeLayer
        }
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
        isAddLayer=true
    }
    
}
