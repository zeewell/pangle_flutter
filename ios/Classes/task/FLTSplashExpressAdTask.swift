//
//  FLTSplashExpressAdTask.swift
//  pangle_flutter
//
//  Created by nullptrX on 2020/8/16.
//

import BUAdSDK

internal final class FLTSplashExpressAdTask: FLTTaskProtocol {
    private var manager: BUNativeExpressSplashView
    private var delegate: BUNativeExpressSplashViewDelegate?

    internal init(_ manager: BUNativeExpressSplashView) {
        self.manager = manager
    }

    convenience init(_ args: [String: Any?]) {
        let slotId: String = args["slotId"] as! String
        let tolerateTimeout: Double? = args["tolerateTimeout"] as? Double
        let hideSkipButton: Bool? = args["hideSkipButton"] as? Bool
        let frame = UIScreen.main.bounds
        let adSize = CGSize(width: frame.width, height: frame.height)
        let vc = AppUtil.getVC()
        let splashView = BUNativeExpressSplashView(slotID: slotId, adSize: adSize, rootViewController: vc)
        if tolerateTimeout != nil {
            splashView.tolerateTimeout = tolerateTimeout!
        }
        if hideSkipButton != nil {
            splashView.hideSkipButton = hideSkipButton!
        }

        vc.view.addSubview(splashView)
        self.init(splashView)
    }

    func execute() -> (@escaping (FLTTaskProtocol, Any) -> Void) -> Void {
        return { result in
            let delegate = FLTSplashExpressAd(success: { [weak self] _ in
                guard let self = self else { return }
                result(self, ["code": 0])
            }, fail: { [weak self] _, error in
                guard let self = self else { return }
                let e = error as NSError?
                result(self, ["code": e?.code ?? -1, "message": error?.localizedDescription ?? ""])
               })

            self.manager.delegate = delegate
            self.delegate = delegate

            self.manager.loadAdData()
        }
    }
}