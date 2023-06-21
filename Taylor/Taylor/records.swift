import UIKit
import SQLite3

class SportSession {
    var image: UIImage
    var date: String
    var distance: Double
    var time: Int
    
    init(image: UIImage, date: String, distance: Double, time: Int) {
        self.image = image
        self.date = date
        self.distance = distance
        self.time = time
    }
}

class records: UITableViewController {
    
    
    var sportSessions: [SportSession] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Call the method to fetch sport sessions from the database
        fetchSportSessions()
        
        // Register custom UITableViewCell class
        tableView.register(SportSessionCell.self, forCellReuseIdentifier: "SportSessionCell")
        
        // Set table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // 添加通知订阅
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("newSportSessionSaved"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    
    // MARK: - UITableView Delegate and DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportSessions.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0  // Or whatever height you want
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportSessionCell", for: indexPath) as! SportSessionCell
        
        let sportSession = sportSessions[indexPath.row]
        
        cell.imageView?.image = sportSession.image
        cell.dateLabel.text = sportSession.date
        cell.distanceLabel.text = "\(sportSession.distance) km"
        cell.timeLabel.text = "\(sportSession.time) min"
        
        return cell
    }
    
    
    

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 // Set the height for the space from the top
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView() // This will be an empty, transparent view
    }

    
    @objc func reloadData() {
        // 重新获取运动会话数据
        fetchSportSessions()
        // 刷新表格
        tableView.reloadData()
    }

    
    
    // MARK: - Database Methods
    
    func fetchSportSessions() {
        // Get the database file path
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to access the document directory")
            return
        }
        
        let dbFileName = "sport.db" // Replace with your database file name
        let dbFilePath = documentsDirectory.appendingPathComponent(dbFileName).path
        
        var db: OpaquePointer?
        
        if sqlite3_open(dbFilePath, &db) != SQLITE_OK {
            print("Unable to open the database")
            return
        }
        
        let query = "SELECT * FROM sport_sessions"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sportSessions = []
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let date = String(cString: sqlite3_column_text(statement, 1))
                let imageBytes = sqlite3_column_blob(statement, 2)
                let imageLength = sqlite3_column_bytes(statement, 2)
                let imageData = Data(bytes: imageBytes!, count: Int(imageLength))

                let image = UIImage(data: imageData)
                let distance = sqlite3_column_double(statement, 3)
                let time = sqlite3_column_int(statement, 4)
                
                let sportSession = SportSession(image: image!, date: date, distance: distance, time: Int(time))
                sportSessions.append(sportSession)
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error querying data: \(errmsg)")
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
    }
}

// Custom UITableViewCell class
class SportSessionCell: UITableViewCell {
    let sessionImageView = UIImageView()
    let dateLabel = UILabel()
    let distanceLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        // Set cell content inset
        self.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        // Configure imageView and add it to the cell's content view
        sessionImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sessionImageView)
        
        // Configure labels and add them to the cell's content view
        for label in [dateLabel, distanceLabel, timeLabel] {
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
        }

        NSLayoutConstraint.activate([
            sessionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sessionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sessionImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2/5),
            sessionImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: sessionImageView.trailingAnchor, constant: 8),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            distanceLabel.leadingAnchor.constraint(equalTo: sessionImageView.trailingAnchor, constant: 8),
            distanceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: sessionImageView.trailingAnchor, constant: 8),
            timeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
