public class Sensor : GLib.Object {
    private ChipSubFeature subfeat;

    public Sensor (ChipSubFeature subfeat) {
        this.subfeat = subfeat;
    }
}