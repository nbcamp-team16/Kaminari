//
//  DetailViewController.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit

// Custom UIView를 상속받는 클래스로서, 라인 그래프를 그리기 위한 클래스
class LineGraphView: UIView {
    // data 배열은 그래프에 표시될 데이터 포인트를 포함
    var data: [CGFloat] = []
    
    // draw 메서드는 UIView가 화면에 그려질 때 호출
    // 이 메서드 내에서 그래프를 그리기
    override func draw(_ rect: CGRect) {
        let graphBackgroundColor = UIColor(hex: "#34B2F9")
        graphBackgroundColor.setFill() // 그래프의 배경색을 설정
        UIRectFill(rect) // 지정된 색상으로 영역 채우기
        
        // 데이터가 없다면 그래프를 그릴 필요가 없으므로 반환
        guard !data.isEmpty else { return }
        
        let path = UIBezierPath() // 그래프 라인을 그리기 위한 경로 객체를 생성
        let scale: CGFloat = rect.height / (data.max() ?? 1) // 그래프의 높이에 대한 스케일을 계산

        // X축 라벨
        let xAxisLabels = ["오전 12시", "오전 6시", "오후 12시", "오후 6시"]
        for (index, labelText) in xAxisLabels.enumerated() {
            let x = rect.width * CGFloat(index) / CGFloat(xAxisLabels.count - 1)
            let label = UILabel(frame: CGRect(x: x - 30, y: rect.height + 5, width: 60, height: 20))
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .center
            self.addSubview(label)
        }

        // Y축 라벨
        let yAxisLabels = ["30℃", "25℃", "20℃", "15℃", "12℃"]
        for (index, labelText) in yAxisLabels.enumerated() {
            let y = rect.height * CGFloat(index) / CGFloat(yAxisLabels.count - 1)
            let label = UILabel(frame: CGRect(x: rect.width + 5, y: y - 10, width: 35, height: 20))
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .right
            self.addSubview(label)
        }

        // 데이터 포인트
        for (index, value) in data.enumerated() {
            let x = rect.width * CGFloat(index) / CGFloat(data.count - 1)
            let y = rect.height - value * scale
            let point = CGPoint(x: x, y: y)
            
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
            
            // 각 데이터 포인트를 원형으로 표시
            let circlePath = UIBezierPath(ovalIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6))
            UIColor.white.setFill()
            circlePath.fill()
        }
        
        // 그래프 라인의 스타일을 설정
        path.lineWidth = 2
        UIColor.white.setStroke()
        path.stroke()
    }
}

// UIColor의 확장
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            let red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            let green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            let blue = CGFloat(hexNumber & 0x0000ff) / 255
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            self.init()
        }
    }
}

class DetailViewController: UIViewController {
    // UI 요소를 선언
    let testButton = CustomButton(frame: .zero) // 커스텀 버튼
    let titleLabel = UILabel() // 타이틀 라벨
    let descriptionLabel = UILabel() // 설명 라벨
    let selectedDateLabel = UILabel() // 선택된 날짜를 표시
    var selectedDateView: UIView? // 선택된 날짜를 표시하는 뷰
    let daysStackView = UIStackView() // 날짜를 표시하는 스택 뷰
    let lineGraphView = LineGraphView() // 라인 그래프 뷰
    let weatherForecastLabel = UILabel() // 날씨 예보 라벨
    let forecastDescriptionTextView: UITextView = {       /*  날씨 예보 텍스트 뷰  */
        let textView = UITextView()
        textView.backgroundColor = UIColor(hex: "#34B2F9")
        textView.textAlignment = .center
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "현재 기온은 24℃이며 흐린 상태입니다. 오후 9시쯤 강우 상태가 예상됩니다. 오늘 기온은 17℃에서 25℃ 사이입니다."
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    // DetailViewController가 메모리에서 해제될 때 호출
    deinit {
        print("### DetailViewController deinitialized")
    }
}

// DetailViewController의 메서드 확장
extension DetailViewController {
    // 뷰가 로드되었을 때 호출
    override func viewDidLoad() {
        super.viewDidLoad()
        // 여러 UI 요소 설정
        view.backgroundColor = UIColor(red: 108.0/255.0, green: 202.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        setupNewUIElements()
    }
    
    // 새로운 UI 요소 설정
    func setupNewUIElements() {
        // 타이틀 라벨 설정
        titleLabel.text = "🌡️ 기온"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 36)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        // 타이틀 라벨의 제약 조건 설정
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 스크롤 뷰 설정
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        // 스크롤 뷰의 제약 조건 설정
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(90)
        }
        
        // 요일 스택 뷰 설정
        let daysStackView = UIStackView()
        daysStackView.axis = .horizontal
        daysStackView.spacing = 30
        scrollView.addSubview(daysStackView)
        
        // 요일 스택 뷰의 제약 조건 설정
        daysStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        let dayFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "d"
        dayFormatter.dateFormat = "E"
        
        // 5일간의 날짜 설정 (무료버전은 5일만 된다고 해서 5일로 설정)
        for i in 0..<5 {
            let date = Calendar.current.date(byAdding: .day, value: i, to: currentDate)!
            
            let dayLabel = UILabel()
            dayLabel.text = dayFormatter.string(from: date)
            dayLabel.textAlignment = .center
            dayLabel.textColor = .white
            
            let dateLabel = UILabel()
            dateLabel.text = dateFormatter.string(from: date)
            dateLabel.textAlignment = .center
            dateLabel.textColor = .white
            
            let dateButton = UIButton()
            dateButton.tag = i
            dateButton.addTarget(self, action: #selector(dateTapped(_:)), for: .touchUpInside)
            dateButton.backgroundColor = UIColor.clear
            
            let containerView = UIView()
            containerView.backgroundColor = UIColor.clear
            
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 10
            stackView.addArrangedSubview(dayLabel)
            stackView.addArrangedSubview(dateLabel)
            
            containerView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            containerView.addSubview(dateButton)
            dateButton.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            daysStackView.addArrangedSubview(containerView)
            containerView.snp.makeConstraints { make in
                make.width.equalTo(50)
            }
        }
        
        // 선택된 날짜 라벨 설정
        selectedDateLabel.textAlignment = .center
        selectedDateLabel.textColor = .white
        view.addSubview(selectedDateLabel)
        
        // 선택된 날짜 라벨의 제약 조건 설정
        selectedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // 설명 라벨 설정
        // 설명 라벨 설정
        let fontSize1: CGFloat = 36.0
        let fontSize2: CGFloat = 16.0

        let currentTemp = WeatherManager.shared.temp
        let lowerTemp = WeatherManager.shared.weather?.dailyForecast.forecast[0].lowTemperature
        let higherTemp = WeatherManager.shared.weather?.dailyForecast.forecast[0].highTemperature
        let string = "\(currentTemp) \n 최고 \(Int(higherTemp?.value ?? 0))º 최저 \(Int(lowerTemp?.value ?? 0))º"
        let attributedString = NSMutableAttributedString(string: string)

        let range1 = (string as NSString).range(of: currentTemp)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize1), range: range1)

        let tempRange = "\(Int(higherTemp?.value ?? 0))º 최저 \(Int(lowerTemp?.value ?? 0))º"
        let range2 = (string as NSString).range(of: tempRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize2), range: range2)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.attributedText = attributedString
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        view.addSubview(descriptionLabel)

        
        // 설명 라벨 제약 조건 설정
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(40)
        }
        
        // 라인 그래프 뷰 설정
        view.addSubview(lineGraphView)
        lineGraphView.data = [50, 75, 100, 60, 80, 45, 70]
        
        // 라인 그래프 뷰 제약 조건 설정
        lineGraphView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-10)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(150)
        }

        // 날씨 예보 라벨 설정
        weatherForecastLabel.text = "일기 예보"
        weatherForecastLabel.textColor = .white
        weatherForecastLabel.font = UIFont.systemFont(ofSize: 20)
        weatherForecastLabel.textAlignment = .center
        view.addSubview(weatherForecastLabel)
        
        // 날씨 예보 라벨 제약 조건 설정
        weatherForecastLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(lineGraphView.snp.bottom).offset(60)
        }
        
        // 날씨 예보 설명
        view.addSubview(forecastDescriptionTextView)
        
        // 날씨 예보 설명 텍스트 필드 제약 조건 설정
        forecastDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(weatherForecastLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(80)
        }

        
        // 오늘 버튼 설정
        if let todayButton = daysStackView.arrangedSubviews.first?.subviews.last as? UIButton {
            dateTapped(todayButton)
        }
    }
    
    @objc func dateTapped(_ sender: UIButton) {
        selectedDateView?.removeFromSuperview()
        
        guard let containerView = sender.superview else {
            return
        }
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        selectedView.layer.cornerRadius = 17
        containerView.insertSubview(selectedView, at: 0)
        selectedView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(-3)
        }
        selectedDateView = selectedView
        
        let selectedDateIndex = sender.tag
        let selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateIndex, to: Date())!
        let isToday = Calendar.current.isDateInToday(selectedDate)
        
        let lowerTempValue = WeatherManager.shared.weather?.dailyForecast.forecast[selectedDateIndex].lowTemperature.value ?? 0
        let higherTempValue = WeatherManager.shared.weather?.dailyForecast.forecast[selectedDateIndex].highTemperature.value ?? 0
        var currentTemp = Int(WeatherManager.shared.weather?.currentWeather.temperature.value ?? 0)
        if !isToday {
            currentTemp = Int((lowerTempValue + higherTempValue) / 2)
        }
        
        let string = "\(Int(currentTemp))º \n 최고 \(Int(higherTempValue))º 최저 \(Int(lowerTempValue))º"
        let attributedString = NSMutableAttributedString(string: string)

        let range1 = (string as NSString).range(of: "\(Int(currentTemp))º")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 36.0), range: range1)

        let tempRange = "\(Int(higherTempValue))º 최저 \(Int(lowerTempValue))º"
        let range2 = (string as NSString).range(of: tempRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16.0), range: range2)

        descriptionLabel.attributedText = attributedString
    }



}
