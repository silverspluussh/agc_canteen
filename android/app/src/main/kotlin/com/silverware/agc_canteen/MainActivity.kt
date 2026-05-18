package com.silverware.agc_canteen

import com.silverware.agc_canteen.plugins.PosPlugin
import com.silverware.agc_canteen.plugins.PrintPlugin
import com.silverware.agc_canteen.plugins.FingerprintPlugin
import com.silverware.agc_canteen.plugins.ScannerPlugin
import com.silverware.agc_canteen.plugins.CardPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(PosPlugin())
        flutterEngine.plugins.add(PrintPlugin())
        flutterEngine.plugins.add(FingerprintPlugin())
        flutterEngine.plugins.add(ScannerPlugin())
        flutterEngine.plugins.add(CardPlugin())
    }
}
