//
//  ChartView.swift
//  YFSMM
//
//  Created by Alvin on 2017/7/8.
//  Copyright © 2017年 Alvin. All rights reserved.
//

import UIKit
import Charts
class ChartView: UIView,ChartViewDelegate,IAxisValueFormatter,IValueFormatter {
    var lineChartView:LineChartView!
    var data1Array:[String] = []
    var data2Array:[String] = []
    var xTitles:[String] = []
    var title:String = ""
    var maxValue:Double = 0;
    var minValue:Double = 0;
    var labelsCount:Int = 0;
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    func setData(data1Array:[String],data2Array:[String],titlesArray:[String],title:String) {
        self.data1Array = data1Array
        self.data2Array = data2Array
        self.xTitles = titlesArray
        self.title = title
    }
    
    func setMaxValue(max:Double,min:Double,count:Int) {
        self.maxValue = max;
        self.labelsCount = count;
        self.minValue = min;
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundColor = UIColor.clear
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        bgView.frame = CGRect(x: CGFloat(0), y: 0, width: CGFloat(kScreenFrameW), height: CGFloat(kScreenFrameH / 2) - 50)
        let titleLabel = UILabel()
        titleLabel.text = self.title
        bgView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 10, y: 12, width: 100, height: 50)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        self.addSubview(bgView)
        let syqIcon = UIImageView(image: UIImage(named: "icon-shiyongqian"))
        syqIcon.frame = CGRect(x: kScreenFrameW - 180, y: (titleLabel.frame.midY - titleLabel.frame.height / 2) , width: 12, height: 12)
        syqIcon.center.y = titleLabel.center.y
        let syqLabel = UILabel()
        syqLabel.text = "使用前"
        bgView.addSubview(syqIcon)
        syqLabel.frame = CGRect(x: syqIcon.frame.maxX + 5, y: syqIcon.frame.origin.y, width: 100, height: 50)
        syqLabel.sizeToFit()
        syqLabel.center.y = titleLabel.center.y
        syqLabel.font = UIFont.systemFont(ofSize: 15)
        syqLabel.textColor = UIColor.white
        bgView.addSubview(syqLabel)
        let syhIcon = UIImageView(image: UIImage(named: "icon-shiyonghou"))
        syhIcon.frame = CGRect(x: kScreenFrameW - 85, y: (titleLabel.frame.midY - titleLabel.frame.height / 2) , width: 12, height: 12)
        syhIcon.center.y = titleLabel.center.y
        let syhLabel = UILabel()
        syhLabel.text = "使用后"
        bgView.addSubview(syhIcon)
        syhLabel.frame = CGRect(x: syhIcon.frame.maxX + 5, y: syhIcon.frame.origin.y, width: 100, height: 50)
        syhLabel.sizeToFit()
        syhLabel.center.y = titleLabel.center.y
        syhLabel.font = UIFont.systemFont(ofSize: 15)
        syhLabel.textColor = UIColor.white
        bgView.addSubview(syhLabel)
        lineChartView = LineChartView(frame: CGRect(x: CGFloat(0), y: CGFloat(50), width: CGFloat(kScreenFrameW), height: CGFloat(kScreenFrameH / 2) - 100))
        lineChartView.backgroundColor = UIColor.clear
        lineChartView.delegate = self
        lineChartView.chartDescription?.text = " "
        lineChartView.scaleYEnabled = false
        //取消Y轴缩放
        lineChartView.doubleTapToZoomEnabled = false
        //取消双击缩放
        lineChartView.dragEnabled = true//启用拖拽图表
        lineChartView.dragDecelerationEnabled = true
        lineChartView.dragDecelerationFrictionCoef = 0.9
        lineChartView.legend.enabled = false
        lineChartView.pinchZoomEnabled = true
        lineChartView.rightAxis.enabled = false //不绘制右边轴
        lineChartView.xAxis.drawGridLinesEnabled = false  //不绘制左边
        lineChartView.leftAxis.labelCount = self.labelsCount //Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        lineChartView.leftAxis.forceLabelsEnabled = true//强制绘制指定数量的label
        lineChartView.leftAxis.axisMinimum = self.minValue //设置Y轴的最小值
        lineChartView.leftAxis.axisMaximum = self.maxValue //设置Y轴的最大值
        lineChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: CGFloat(12.0))
        lineChartView.leftAxis.labelTextColor = UIColor.init(white: 1, alpha: 0.7)
        lineChartView.leftAxis.axisLineColor = UIColor.init(white: 1, alpha: 0.7)
        lineChartView.leftAxis.gridColor = UIColor.init(white: 1, alpha: 0.7)
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom //设置x轴数据在底部
        lineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: CGFloat(11))//设置x文字字体大小
    
        lineChartView.xAxis.labelTextColor = UIColor.init(white: 1, alpha: 0.9)
        lineChartView.xAxis.granularityEnabled = true //设置重复的值不显示
        lineChartView.xAxis.axisLineColor = UIColor.init(white: 1, alpha: 0.7)
        let colorArray = [UIColorHex("#7E72F0"), UIColorHex("#78D7F5")]
        
        //let array: [String] = ["10", "10", "8", "20", "40"]
        //let array1: [String] = ["50", "10", "30", "80", "47"]
        let valueArray:NSMutableArray = []
        valueArray.add(self.data1Array)
        valueArray.add(self.data2Array)
        let dataSets:NSMutableArray = []
        for i in 0..<valueArray.count {
            let values : [String] = (valueArray[i] as! [String])
            let yVals :NSMutableArray = []
            let legendName: String = "第\(i)个图例"
            for i in 0..<values.count {
                let valStr: String = "\(values[i])"
                let val: Double = valStr.double!
                let entry = ChartDataEntry(x: Double(i), y: val)
                yVals.add(entry)
            }
            let dataSet = LineChartDataSet(values: yVals as? [ChartDataEntry], label: legendName)
            dataSet.lineWidth = 2//折线宽度
            dataSet.drawValuesEnabled = false//是否在拐点处显示数据
            dataSet.setColor(UIColor.white)//折线颜色
            dataSet.setCircleColor(colorArray[i]) //设置拐点颜色
            //dataSet.drawSteppedEnabled = false //是否开启绘制阶梯样式的折线图
            dataSet.drawCirclesEnabled = true  //是否绘制拐点
            dataSet.circleRadius = 5.0//拐点半径
            dataSet.axisDependency = YAxis.AxisDependency.left
            dataSet.drawCircleHoleEnabled = false//是否绘制中间的空心
            dataSet.highlightEnabled = false//选中拐点,是否开启高亮效果(显示十字线)
            dataSets.add(dataSet)
        }
        let data = LineChartData(dataSets: dataSets as? [IChartDataSet])
        lineChartView.data = nil
        lineChartView.xAxis.axisMinimum = -0.8
        lineChartView.xAxis.axisMaximum = 5.1
        lineChartView.xAxis.spaceMin = 30;
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 0.3)
        lineChartView.xAxis.valueFormatter = self
        bgView.addSubview(lineChartView)
    }
    
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.f", value)
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index  = Int(value)
        if index >= self.xTitles.count {
            return ""
        }else{
            return self.xTitles[index]
        }

    }
    
    // 数据刷新
    func refresh(){
        let colorArray = [UIColorHex("#7E72F0"), UIColorHex("#78D7F5")]
        //let array: [String] = ["10", "10", "8", "20", "40"]
        //let array1: [String] = ["50", "10", "30", "80", "47"]
        let valueArray:NSMutableArray = []
        valueArray.add(self.data1Array)
        let dataSets:NSMutableArray = []
        for i in 0..<valueArray.count {
            let values : [String] = (valueArray[i] as! [String])
            let yVals :NSMutableArray = []
            let legendName: String = "第\(i)个图例"
            for i in 0..<values.count {
                let valStr: String = "\(values[i])"
                let val: Double = valStr.double!
                let entry = ChartDataEntry(x: Double(i), y: val)
                yVals.add(entry)
            }
            let dataSet = LineChartDataSet(values: yVals as? [ChartDataEntry], label: legendName)
            dataSet.lineWidth = 2//折线宽度
            dataSet.drawValuesEnabled = false//是否在拐点处显示数据
            dataSet.setColor(UIColor.white)//折线颜色
            dataSet.setCircleColor(colorArray[i]) //设置拐点颜色
            //dataSet.drawSteppedEnabled = false //是否开启绘制阶梯样式的折线图
            dataSet.drawCirclesEnabled = true  //是否绘制拐点
            dataSet.circleRadius = 5.0//拐点半径
            dataSet.axisDependency = YAxis.AxisDependency.left
            dataSet.drawCircleHoleEnabled = false//是否绘制中间的空心
            dataSet.highlightEnabled = false//选中拐点,是否开启高亮效果(显示十字线)
            dataSets.add(dataSet)
        }
        let data = LineChartData(dataSets: dataSets as? [IChartDataSet])
        lineChartView.data = nil
        lineChartView.xAxis.axisMinimum = -0.8
        lineChartView.xAxis.axisMaximum = 5.1
        lineChartView.xAxis.spaceMin = 30;
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 0.3)
        lineChartView.xAxis.valueFormatter = self
    }
}
