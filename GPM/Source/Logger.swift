// SPDX-License-Identifier: MIT

import Foundation
import os

enum Logger {
    static let standard = os.Logger(subsystem: Bundle.main.bundleIdentifier!, category: "main")
}
