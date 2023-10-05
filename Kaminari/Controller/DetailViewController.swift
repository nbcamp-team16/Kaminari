//
//  DetailViewController.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit

var date: Date?

// Custom UIView를 상속받는 클래스로서, 라인 그래프를 그리기 위한 클래스
class LineGraphView: UIView {
    var data: [CGFloat] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    private var graphMaxTemperature: CGFloat?
    private var graphMinTemperature: CGFloat?

    var yAxisLabels: [String] {
        let fahrenheitToCelsius: (CGFloat) -> CGFloat = { fahrenheit in
            fahrenheit
        }

        let minTemp = fahrenheitToCelsius(graphMinTemperature ?? 0)
        let maxTemp = fahrenheitToCelsius(graphMaxTemperature ?? 0)
        let midTemp = (minTemp + maxTemp) / 2
        let labels = ["\(Int(maxTemp))℃", "\(Int(midTemp))℃", "\(Int(minTemp))℃"]
        return labels
    }

    func setTemperatureRange(min: CGFloat, max: CGFloat) {
        graphMinTemperature = min
        graphMaxTemperature = max
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        for subview in subviews {
            if subview is UILabel {
                subview.removeFromSuperview()
            }
        }

        let graphBackgroundColor = UIColor.gray.withAlphaComponent(200)
        graphBackgroundColor.setFill()
        UIRectFill(rect)

        guard !data.isEmpty else { return }

        let path = UIBezierPath()
        let minY = data.min() ?? 0
        let maxY = data.max() ?? 0
        _ = maxY - minY

        // 조정된 X축 라벨들
        let xAxisLabels = ["오전 12시", "오전 6시", "오후 12시", "오후 6시"]
        for (index, labelText) in xAxisLabels.enumerated() {
            let x = rect.width * CGFloat(index) / CGFloat(xAxisLabels.count - 1)
            let label = UILabel(frame: CGRect(x: x - 30, y: rect.height + 3, width: 60, height: 20))
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 10)
            label.textAlignment = .center
            label.backgroundColor = .clear
            addSubview(label)
        }

        // 조정된 Y축 라벨들
        for (index, labelText) in yAxisLabels.enumerated() {
            let y = rect.height * CGFloat(index) / CGFloat(yAxisLabels.count - 1)
            let label = UILabel(frame: CGRect(x: rect.width + 10, y: y - 12, width: 40, height: 20))
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 10)
            label.textAlignment = .left
            label.backgroundColor = .clear
            addSubview(label)
        }

        for (index, value) in data.enumerated() {
            let x = rect.width * CGFloat(index) / CGFloat(data.count - 1)

            let paddingFactor: CGFloat = 0.15
            let paddedHeight = rect.height * (1.0 - 2 * paddingFactor)

            let rawNormalizedY = (value - (graphMinTemperature ?? 0)) / ((graphMaxTemperature ?? 0) - (graphMinTemperature ?? 0))
            let normalizedY = min(max(rawNormalizedY, 0.0), 1.0)
            let y = paddedHeight * (1.0 - normalizedY) + rect.height * paddingFactor

            let point = CGPoint(x: x, y: y)

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }

            let circlePath = UIBezierPath(ovalIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6))
            UIColor.white.setFill()
            circlePath.fill()
        }

        path.lineWidth = 2
        UIColor.white.setStroke()
        path.stroke()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 17
//        self.clipsToBounds = false
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
    var defaultSelectedIndex: Int? = nil

    // UI 요소를 선언
    let testButton = CustomButton(frame: .zero) // 커스텀 버튼
    let titleLabel = UILabel() // 타이틀 라벨
    let descriptionLabel = UILabel() // 설명 라벨
    let selectedDateLabel = UILabel() // 선택된 날짜를 표시
    var selectedDateView: UIView? // 선택된 날짜를 표시하는 뷰
    let daysStackView = UIStackView() // 날짜를 표시하는 스택 뷰
    let lineGraphView = LineGraphView() // 라인 그래프 뷰
    let weatherForecastLabel = UILabel() // 날씨 예보 라벨
    let forecastDescriptionTextView: UITextView = { /*  날씨 예보 텍스트 뷰  */
        let textView = UITextView()
        textView.backgroundColor = .gray
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 17
        textView.text = ""
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
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        setupNewUIElements()
    }

    // 새로운 UI 요소 설정
    func setupNewUIElements() {
        // 타이틀 라벨 설정
        titleLabel.text = "🌡️ 기온"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 36)
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

        for i in 0..<9 {
            let date = Calendar.current.date(byAdding: .day, value: i, to: currentDate)!

            let dayLabel = UILabel()
            dayLabel.text = dayFormatter.string(from: date)
            dayLabel.textAlignment = .center

            let dateLabel = UILabel()
            dateLabel.text = dateFormatter.string(from: date)
            dateLabel.textAlignment = .center

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
        view.addSubview(selectedDateLabel)

        // 선택된 날짜 라벨의 제약 조건 설정
        selectedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

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

        if let dateButton = daysStackView.arrangedSubviews[defaultSelectedIndex!].subviews.last as? UIButton {
            dateTapped(dateButton)
        }
    }

    @objc func dateTapped(_ sender: UIButton) {
        print("dateTapped function called")

        // Check and log the view hierarchy
        var currentView: UIView? = sender
        var hierarchy: [String] = []
        while let unwrappedView = currentView {
            hierarchy.append(String(describing: type(of: unwrappedView)))
            currentView = unwrappedView.superview
        }
        print(hierarchy.joined(separator: " -> "))

        selectedDateView?.removeFromSuperview()

        guard let containerView = sender.superview else {
            return
        }

        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.gray
        selectedView.layer.cornerRadius = 17
        containerView.insertSubview(selectedView, at: 0)
        selectedView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(-3)
        }
        selectedDateView = selectedView

        let selectedDateIndex = sender.tag
        let selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateIndex, to: Date())!

        // 선택된 날짜를 `selectedDateLabel`에 표시
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
        selectedDateLabel.text = dateFormatter.string(from: selectedDate)

        // 날씨 아이콘 가져오기
        let symbolName = WeatherManager.shared.weather?.dailyForecast.forecast[selectedDateIndex].symbolName ?? "sun.max"

        // 다이나믹 컬러 설정
        let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .white // 다크 모드에서는 흰색으로 설정
            default:
                return .black // 라이트 모드나 기타 경우에는 검은색으로 설정
            }
        }

        let imageWithDynamicTintColor = UIImage(systemName: symbolName)?.withTintColor(dynamicColor, renderingMode: .alwaysOriginal)

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = imageWithDynamicTintColor
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: imageAttachment.image!.size.width * 1.8, height: imageAttachment.image!.size.height * 1.8)
        let attachmentString = NSAttributedString(attachment: imageAttachment)

        let boldTextAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 30)]
        let boldAttributedString = NSAttributedString(string: " 기온", attributes: boldTextAttributes)

        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        completeText.append(boldAttributedString)
        titleLabel.attributedText = completeText

        let lowerTempValue = WeatherManager.shared.weather?.dailyForecast.forecast[selectedDateIndex].lowTemperature.value ?? 0
        let higherTempValue = WeatherManager.shared.weather?.dailyForecast.forecast[selectedDateIndex].highTemperature.value ?? 0
        let isToday = Calendar.current.isDateInToday(selectedDate)
        var currentTemp = Int(WeatherManager.shared.weather?.currentWeather.temperature.value ?? 0)
        if !isToday {
            currentTemp = Int((lowerTempValue + higherTempValue) / 2)
        }

        // 선택된 버튼의 위치로 스크롤
        if let scrollView = sender.superview?.superview?.superview as? UIScrollView {
            let buttonPosition = sender.frame.origin.x - (scrollView.frame.width / 2) + (sender.frame.width / 2)
            print("Button frame: \(sender.frame)")
            print("ScrollView contentSize: \(scrollView.contentSize)")
            print("ScrollView contentOffset: \(scrollView.contentOffset)")
            print("ScrollView frame: \(scrollView.frame)")
            print("Calculated buttonPosition: \(buttonPosition)")
            scrollView.setContentOffset(CGPoint(x: max(0, buttonPosition), y: 0), animated: true)
        }

        // Y축 범위 조정 로직 추가
        let adjustedLowerTempValue = lowerTempValue - 3
        let adjustedHigherTempValue = higherTempValue + 3
        lineGraphView.setTemperatureRange(min: adjustedLowerTempValue, max: adjustedHigherTempValue)

        let string = "\(Int(currentTemp))º \n 최고 \(Int(higherTempValue))º 최저 \(Int(lowerTempValue))º"
        let attributedString = NSMutableAttributedString(string: string)

        let range1 = (string as NSString).range(of: "\(Int(currentTemp))º")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 36.0), range: range1)

        let tempRange = "\(Int(higherTempValue))º 최저 \(Int(lowerTempValue))º"
        let range2 = (string as NSString).range(of: tempRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16.0), range: range2)

        descriptionLabel.attributedText = attributedString

        // 선택된 날짜의 시간별 기온 데이터 가져오기
        var hourlyTemperatures: [CGFloat] = []
        for hourIndex in 0..<24 {
            let temperatureString = WeatherManager.shared.hourlyForecastTemperature(indexPath: selectedDateIndex * 24 + hourIndex)
            if let temperature = Double(temperatureString.trimmingCharacters(in: CharacterSet(charactersIn: "°C"))) {
                hourlyTemperatures.append(CGFloat(temperature))
            }
        }

        let weatherDescription = WeatherManager.shared.weather?.dailyForecast.forecast[selectedDateIndex].symbolName
        forecastDescriptionTextView.text = "현재 기온은 \(currentTemp)℃이며 \n 오늘 기온은 \(Int(lowerTempValue))℃에서 \n \(Int(higherTempValue))℃ 사이입니다."

        lineGraphView.data = hourlyTemperatures
    }
}
