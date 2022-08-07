public class SensorChip {
    public unowned Sensors.ChipName chip { private set; get; }
    private Gee.List<ChipFeature> features;

    public SensorChip (Sensors.ChipName chip) {
        this.chip = chip;
        build();
    }

    private void build () {
        features = new Gee.ArrayList<ChipFeature> ((a ,b) => a.equal_to (b));
        var nr = 0;
        unowned Sensors.Feature? feature = null;

        stdout.printf ("SensorChip %s:\n", chip.prefix);
        while ((feature = Sensors.get_features (chip, ref nr)) != null) {
            features.add (new ChipFeature (this, feature));
        }
    }

    public bool equal_to (SensorChip other) {
        return this.chip.path == other.chip.path &&
                this.chip.prefix == other.chip.prefix;
    }

    public static Gee.List<SensorChip> get_all_sensor_chips () {
        var all_chips = new Gee.ArrayList<SensorChip> ((a, b) => a.equal_to (b));
        var nr = 0;
        unowned Sensors.ChipName? chip = null;

        while ((chip = Sensors.get_detected_chips (null, ref nr)) != null) {
            all_chips.add (new SensorChip (chip));
        }

        return all_chips;
    }
}