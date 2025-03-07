package tom.package

import android.content.Context
import android.view.View
import com.tomtom.sdk.maps.display.TomTomMap
import com.tomtom.sdk.maps.display.ui.MapFragment
import io.flutter.plugin.platform.PlatformView

class TomTomMapView(context: Context) : PlatformView {

    private val mapFragment: MapFragment
    private var tomTomMap: TomTomMap? = null

    init {
        mapFragment = MapFragment.newInstance()
        mapFragment.getMapAsync { tomTomMap = it }
    }

    override fun getView(): View {
        return mapFragment.requireView()
    }

    override fun dispose() {}
}
