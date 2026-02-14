import Foundation

public final class AppResources {
    public static let bundle: Bundle = {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(for: AppResources.self)
#endif
    }()
}
