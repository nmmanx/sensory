public class SensorViewModel : GLib.Object {
    private ChipSubFeature sensor;

    public SensorViewModel (ChipSubFeature sensor) {
        Object ();
        this.sensor = sensor;
    }

    public bool equal_to (SensorViewModel other) {
        return this.sensor.equal_to (other.sensor);
    }
}