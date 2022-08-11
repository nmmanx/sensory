public class SensorModel : GLib.Object {
    private ChipSubFeature subfeat;

    public signal void on_value_changed (SensorModel sensor, double val);

    public SensorModel (ChipSubFeature subfeat) {
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

    public string get_name () {
        return subfeat.get_name ();
    }
}