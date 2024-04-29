//
//  DateDecoderExtension.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 22/03/24.
//

import Foundation

extension Formatter {
   static var customISO8601DateFormatter: ISO8601DateFormatter = {
      let formatter = ISO8601DateFormatter()
       formatter.timeZone = TimeZone.current
      return formatter
   }()
}

extension JSONDecoder.DateDecodingStrategy {
   static var iso8601local = custom { decoder in
      let dateStr = try decoder.singleValueContainer().decode(String.self)
      let customIsoFormatter = Formatter.customISO8601DateFormatter
      if let date = customIsoFormatter.date(from: dateStr) {
         return date
      }
      throw DecodingError.dataCorrupted(
               DecodingError.Context(codingPath: decoder.codingPath,
                                     debugDescription: "Invalid date"))
   }
}

extension JSONEncoder.DateEncodingStrategy {
    static var iso8601local = custom { date, encoder in
        let isoFormatter = DateFormatter.customISO8601DateFormatter
        let dateString = isoFormatter.string(from: date)
        var container = encoder.singleValueContainer()
        try container.encode(dateString)
    }
}

extension Date {
    func timeDifference(date: Date) -> String {
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .full
        form.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        let difference = form.string(from: date, to: self)
        let result = difference!
        return result
    }
}

extension Date {
    func localDate(_ date: Date) -> Date {
        let nowUTC = date
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        return localDate
    }
}
