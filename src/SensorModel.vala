public class SensorModel : TimeSeriesData {
    private ChipSubFeature subfeat;

    public signal void on_value_changed (SensorModel sensor, double val);

    public SensorModel (ChipSubFeature subfeat) {
        base (subfeat.feature.get_name (), 1, 120); // TODO: fix hardcode
        this.subfeat = subfeat;
    }

    public void update () {
        double val = 0;
        if (subfeat.get_value (out val)) {
            this.on_value_changed (this, val);
        }
    }

    public Sensors.FeatureType get_feature_type () {
        return subfeat.get_feature_type ();
    }
}