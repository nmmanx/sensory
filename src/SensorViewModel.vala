public class SensorViewModel : GLib.Object {
    private ChipSubFeature sensor;

    public signal void value_changed (ChipSubFeature sensor, double val);

    public SensorViewModel (ChipSubFeature sensor) {
        Object ();
        this.sensor = sensor;
    }

    public bool equal_to (SensorViewModel other) {
        return this.sensor.equal_to (other.sensor);
    }

    public void update () {
        double val = 0;
        if (sensor.get_value (out val)) {
            value_changed (sensor, val);
        }
    }
}