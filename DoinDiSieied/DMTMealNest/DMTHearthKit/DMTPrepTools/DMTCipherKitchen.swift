import Foundation

enum DMTCipherKitchen {
    private static let mealSpice: [UInt8] = [
        0x44, 0x69, 0x6D, 0x65, 0x65, 0x74, 0x2D, 0x46,
        0x6C, 0x61, 0x76, 0x6F, 0x72, 0x2D, 0x43, 0x68
    ]

    static func reveal(_ sealedCourse: Data) -> Data {
        let platedBytes = sealedCourse.enumerated().map { courseIndex, sealedByte in
            sealedByte ^ spiceByte(for: courseIndex)
        }
        return Data(platedBytes)
    }

    private static func spiceByte(for courseIndex: Int) -> UInt8 {
        let mealByte = mealSpice[courseIndex % mealSpice.count]
        let swirlByte = UInt8(((courseIndex * 29) + 113) & 0xFF)
        return mealByte ^ swirlByte
    }
}
