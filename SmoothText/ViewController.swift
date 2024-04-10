//
//  ViewController.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 19/3/2567 BE.
//

import UIKit

private let serialQueue = DispatchQueue(label: "com.text.test")

final class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  var data: [String] = [
    "1 🥲 สามช่าผ้าห่มหมวย www.apple.com ปัจเจกชนราสเบอร์รีแฟรี่พงษ์ สไลด์ เอ๋อเปราะบางซีเรียส นู้ดแอ็คชั่นเครปตัวตน ผ้าห่ม แพลนนอร์ทผลไม้โรแมนติก ทัวร์นาเมนท์อัลบัมเฉิ่มดิสเครดิต เทคโนพันธกิจแลนด์ เฟรชชี่พรีเซ็นเตอร์นอร์ท สึนามิ สคริปต์น็อค จังโก้ เพรส ตัวเองผ้าห่มคูลเลอร์ดีไซน์ หมั่นโถว เทคโนแครตสเปกแฟรนไชส์เวิร์ลด์ โมเดิร์นงี้ ไนน์ ไคลแมกซ์คาเฟ่เคอร์ฟิว ติวตาปรือรีสอร์ทแหม็บแอ็คชั่น แรงดูดชัตเตอร์เอ็นเตอร์เทน วอฟเฟิลเวิร์ลด์เทคโปรเจ็คท์เลิฟ ราเมน แบนเนอร์วีเจไมเกรนแอร์ แอ็กชั่นบุ๋น บรานู้ดเอฟเฟ็กต์ตัวเองพิซซ่า เอ็นเตอร์เทนเบบี้ แฟนซีแรงใจ วอลนัทซูเอี๋ยแลนด์อึ๋มแฟกซ์ นินจา ดีพาร์ตเมนท์ สามช่าผ้าห่มหมวย ปัจเจกชนราสเบอร์รีแฟรี่พงษ์ สไลด์ เอ๋อเปราะบางซีเรียส นู้ดแอ็คชั่นเครปตัวตน ผ้าห่ม แพลนนอร์ทผลไม้โรแมนติก ทัวร์นาเมนท์อัลบัมเฉิ่มดิสเครดิต เทคโนพันธกิจแลนด์ เฟรชชี่พรีเซ็นเตอร์นอร์ท สึนามิ สคริปต์น็อค จังโก้ เพรส ตัวเองผ้าห่มคูลเลอร์ดีไซน์ หมั่นโถว เทคโนแครตสเปกแฟรนไชส์เวิร์ลด์ โมเดิร์นงี้ ไนน์ ไคลแมกซ์คาเฟ่เคอร์ฟิว ติวตาปรือรีสอร์ทแหม็บแอ็คชั่น แรงดูดชัตเตอร์เอ็นเตอร์เทน วอฟเฟิลเวิร์ลด์เทคโปรเจ็คท์เลิฟ ราเมน แบนเนอร์วีเจไมเกรนแอร์ แอ็กชั่นบุ๋น บรานู้ดเอฟเฟ็กต์ตัวเองพิซซ่า เอ็นเตอร์เทนเบบี้ แฟนซีแรงใจ วอลนัทซูเอี๋ยแลนด์อึ๋มแฟกซ์ นินจา ดีพาร์ตเมนท์ สามช่าผ้าห่มหมวย ปัจเจกชนราสเบอร์รีแฟรี่พงษ์ สไลด์ เอ๋อเปราะบางซีเรียส นู้ดแอ็คชั่นเครปตัวตน www.google.com ผ้าห่ม แพลนนอร์ทผลไม้โรแมนติก ทัวร์นาเมนท์อัลบัมเฉิ่มดิสเครดิต เทคโนพันธกิจแลนด์ เฟรชชี่พรีเซ็นเตอร์นอร์ท สึนามิ สคริปต์น็อค จังโก้ เพรส ตัวเองผ้าห่มคูลเลอร์ดีไซน์ หมั่นโถว เทคโนแครตสเปกแฟรนไชส์เวิร์ลด์ โมเดิร์นงี้ ไนน์ ไคลแมกซ์คาเฟ่เคอร์ฟิว ติวตาปรือรีสอร์ทแหม็บแอ็คชั่น แรงดูดชัตเตอร์เอ็นเตอร์เทน วอฟเฟิลเวิร์ลด์เทคโปรเจ็คท์เลิฟ ราเมน แบนเนอร์วีเจไมเกรนแอร์ แอ็กชั่นบุ๋น บรานู้ดเอฟเฟ็กต์ตัวเองพิซซ่า เอ็นเตอร์เทนเบบี้ แฟนซีแรงใจ วอลนัทซูเอี๋ยแลนด์อึ๋มแฟกซ์ นินจา ดีพาร์ตเมนท์",
    "2 🥲 โมเดิร์นงี้ ไนน์ ไคลแมกซ์คาเฟ่เคอร์ฟิว ติวตาปรือรีสอร์ทแหม็บแอ็คชั่น แรงดูดชัตเตอร์เอ็นเตอร์เทน วอฟเฟิลเวิร์ลด์เทคโปรเจ็คท์เลิฟ ราเมน แบนเนอร์วีเจไมเกรนแอร์ แอ็กชั่นบุ๋น บรานู้ดเอฟเฟ็กต์ตัวเองพิซซ่า เอ็นเตอร์เทนเบบี้ แฟนซีแรงใจ วอลนัทซูเอี๋ยแลนด์อึ๋มแฟกซ์ นินจา ดีพาร์ตเมนท์ สามช่าผ้าห่มหมวย ปัจเจกชนราสเบอร์รีแฟรี่พงษ์ สไลด์ เอ๋อเปราะบางซีเรียส นู้ดแอ็คชั่นเครปตัวตน ผ้าห่ม แพลนนอร์ทผลไม้โรแมนติก ทัวร์นาเมนท์อัลบัมเฉิ่มดิสเครดิต เทคโนพันธกิจแลนด์ เฟรชชี่พรีเซ็นเตอร์นอร์ท สึนามิ สคริปต์น็อค จังโก้ เพรส ตัวเองผ้าห่มคูลเลอร์ดีไซน์ หมั่นโถว เทคโนแครตสเปกแฟรนไชส์เวิร์ลด์ โมเดิร์นงี้ ไนน์ ไคลแมกซ์คาเฟ่เคอร์ฟิว",
    "3 🥲 หมั่นโถว เทคโนแครตสเปกแฟรนไชส์เวิร์ลด์ โมเดิร์นงี้ ไนน์",
    "4 🥲 หมั่นโถว",
    "5 🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲"
  ]

  var cells: [NSAttributedString] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    serialQueue.async { [weak self] in
      guard let self else { return }
      for i in 0...10 {
        let data = data[i % data.count]
        cells.append(AsyncUILabel.TextUtility.shared.detectLinkAndUpdateCacheData(
          attributedString: NSAttributedString(string: data, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue]),
          checkingResultType: [.link],
          width: UIScreen.main.bounds.width))
      }
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        tableView.reloadData()
      }
    }
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(
      UINib(
        nibName: String(describing: TextUILabelCell.self),
        bundle: nil),
      forCellReuseIdentifier: String(describing: TextUILabelCell.self)
    )
    tableView.register(
      UINib(
        nibName: String(describing: CoreTextLabel.self),
        bundle: nil),
      forCellReuseIdentifier: String(describing: CoreTextLabel.self)
    )
  }
}

extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cells.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CoreTextLabel.self), for: indexPath) as? CoreTextLabel {
//      cell.configure(data: cells[indexPath.row])
//      cell.delegate = self
//      return cell
//    }

    if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextUILabelCell.self), for: indexPath) as? TextUILabelCell {
//      (cell.lbLabel as? TestUILabelAsync)?.delegate = self
      cell.lbLabel.delegate = self
      cell.configure(text: cells[indexPath.row])
      return cell
    }


    return UITableViewCell()
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

extension ViewController: CoreTextLabelDelegate {
  func updateTableView() {
    tableView.performBatchUpdates(nil)
  }
}

extension ViewController: TestUILabelAsyncDelegate {
  func update() {
//    UITableView.performWithoutAnimation {
      tableView.performBatchUpdates(nil)
//    }
  }
}

extension ViewController: AsyncUILabelDelegate {
  func asynUILabel(_ label: AsyncUILabel, didTapLinkWith url: URL) {
    print(url)
  }

  func asynUILabel(didTapLabelWith label: AsyncUILabel) {
    print("did tap label")
  }

  func asynUILabel(didUpdateLabelWith label: AsyncUILabel) {
    tableView.performBatchUpdates(nil)
  }
}
