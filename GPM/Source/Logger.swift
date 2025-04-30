// SPDX-License-Identifier: MIT

import Foundation
import os

public enum Logger {
    public static let standard = os.Logger(subsystem: Bundle.main.bundleIdentifier!, category: "main")
}
