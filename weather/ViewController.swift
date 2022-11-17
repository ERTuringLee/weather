//
//  ViewController.swift
//  weather
//
//  Created by 이재문 on 2022/11/17.
//
import UIKit
import RxSwift
import Moya
import Kingfisher
import Then
import SnapKit

class CityNameTableViewCell: UITableViewCell {
    let cityNameLabel = BaseLabel().then {
        $0.setupView(font: UIFont.systemFont(ofSize: 20, weight: .bold), color: .white)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
    }
    
    func setUpCell() {
        contentView.addSubview(cityNameLabel)
        contentView.backgroundColor = .lightGray
        setAutoLayout()
    }
    
    func setAutoLayout() {
        cityNameLabel.snp.makeConstraints {make in
            make.top.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

class ForecastTableViewCell: UITableViewCell {
    let dateLabel = BaseLabel().then {
        $0.setupView()
    }
    
    let weatherImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let descriptionLabel = BaseLabel().then {
        $0.setupView()
    }

    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let maxDegreeLabel = BaseLabel().then {
        $0.setupView()
    }
    
    let minDegreeLabel = BaseLabel().then {
        $0.setupView()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
        setAutoLayout()
    }
    
    func setUpCell() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(maxDegreeLabel)
        contentView.addSubview(minDegreeLabel)
        contentView.addSubview(seperator)
    }
    
    func setAutoLayout() {
        setAutoLayoutDateLabel()
        setAutoLayoutWeatherImageView()
        setAutoLayoutDescriptionLabel()
        setAutoLayoutMinDegreeLabel()
        setAutoLayoutMaxDegreeLabel()
        setAutoLayoutSeperator()
    }
    
    func setAutoLayoutDateLabel() {
        dateLabel.snp.makeConstraints {make in
            make.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
    }
    
    func setAutoLayoutWeatherImageView() {
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(40)
        }
    }
    
    func setAutoLayoutDescriptionLabel() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(weatherImageView)
            make.leading.equalTo(weatherImageView.snp.trailing).offset(10)
        }
    }
    
    func setAutoLayoutMinDegreeLabel() {
        minDegreeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerY.equalTo(weatherImageView)
        }
    }
    
    func setAutoLayoutMaxDegreeLabel() {
        maxDegreeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(minDegreeLabel.snp.leading).offset(-10)
            make.centerY.equalTo(weatherImageView)
        }
    }
    
    func setAutoLayoutSeperator() {
        seperator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(weatherImageView.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
    }
    
    func setData(data: ForecastData, timestamp: Int) {
        self.dateLabel.text = self.date(timestamp: timestamp)
        self.descriptionLabel.text = data.weather[0].description
        self.weatherImageView.kf.setImage(with: URL(string: String(format: NetworkConstants.Url.icon, data.weather[0].icon))!, placeholder: UIImage())
        self.maxDegreeLabel.text = String(format: Contents.maxDegree, data.temp.maxDegree())
        self.minDegreeLabel.text = String(format: Contents.minDegree, data.temp.minDegree())
    }
    
    

    func date(timestamp: Int) -> String {
        let calendar = Calendar.current
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        guard !calendar.isDateInToday(date) else {
            return Contents.today
        }
        
        guard !calendar.isDateInTomorrow(date) else {
            return Contents.tomorrow
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}


class ViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView().then {
        $0.color = .red
        $0.hidesWhenStopped = true
        $0.style = UIActivityIndicatorView.Style.large
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let disposeBag = DisposeBag()
    
    private var cityForecastVM: CityForecastViewModel = CityForecastViewModel()
    let lock = NSLock()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        registerTableView()
        tableViewDelegate()
        configureActivityIndicaterView()
        fetchData()
       
    }
    
    func configureTableView() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureActivityIndicaterView() {
        self.view.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(50)
        }
    }
    
    func registerTableView() {
        tableView.register(CityNameTableViewCell.classForCoder(), forCellReuseIdentifier: CityNameTableViewCell().name())
        tableView.register(ForecastTableViewCell.classForCoder(), forCellReuseIdentifier: ForecastTableViewCell().name())
    }
    
    func tableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchData() {
        self.activityIndicator.startAnimating()

        CityName.allCases.forEach { cityName in
            DispatchQueue.global().async {
                self.lock.lock()
                ForecastService.shared.daily(cityName: cityName.rawValue) {
                    if cityName == .Chicago {
                        self.activityIndicator.stopAnimating()
                    }
                    
                    

                    if $1 != nil {
                        self.lock.unlock()
                    }
                    
                    guard let response = $0 else {
                        return
                    }
                    
                    let cityForecast = CityForeCastData(cityName: cityName.rawValue, dailyForecastData: response)
                    self.cityForecastVM.cityForecasts.append(cityForecast)
                    
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                    
                    self.lock.unlock()
                }
            }
        }
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityForecastVM.numberOfRowInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell().name(), for: indexPath) as! ForecastTableViewCell
        cell.selectionStyle = .none
        
        let data = cityForecastVM.cityForecasts[indexPath.section].dailyForecastData.list[indexPath.row]
        let timezone = cityForecastVM.cityForecasts[indexPath.section].dailyForecastData.city.timezone
        let timestamp = data.dt + timezone
        
        cell.setData(data: data, timestamp: timestamp)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return cityForecastVM.numberOfSections
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityNameTableViewCell().name()) as! CityNameTableViewCell
        cell.cityNameLabel.text = cityForecastVM.cityForecasts[section].cityName
        return cell.contentView
    }
    
}

