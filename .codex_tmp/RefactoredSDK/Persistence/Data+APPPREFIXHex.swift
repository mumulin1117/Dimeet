import Foundation

extension Data {
    func APPPREFIX_hexString() -> String {
        map { String(format: HNONWCcasualChic.Format.hexByte, $0) }.joined()
    }

    init?(APPPREFIX_hexist hex: String) {
        guard hex.count.isMultiple(of: 2) else { return nil }

        var data = Data()
        data.reserveCapacity(hex.count / 2)
        var index = hex.startIndex

        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            let byteString = hex[index..<nextIndex]
            guard let byte = UInt8(byteString, radix: 16) else { return nil }
            data.append(byte)
            index = nextIndex
        }

        self = data
    }

    func APPPREFIX_utf8ArtString() -> String? {
        String(data: self, encoding: .utf8)
    }
}
