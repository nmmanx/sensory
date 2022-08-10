public class SensorChip {
    public unowned Sensors.ChipName chip { private set; get; }
    public Gee.List<ChipFeature> features { private set; get; }
    private string name;

    public SensorChip (Sensors.ChipName chip) {
        this.chip = chip;

        // Get full chip name
        char[] str = new char[50];
        var n = Sensors.snprintf_chip_name (str, chip);
        if (n > 0) {
            var sb = new GLib.StringBuilder ();
            for (var i = 0; i < n; i++) {
                sb.append_c (str[i]);
            }
            name = sb.str;
        } else {
            name = chip.prefix;
        }

        build();
    }

    private void build () {
        features = new Gee.ArrayList<ChipFeature> ((a ,b) => a.equal_to (b));
        var nr = 0;
        unowned Sensors.Feature? feature = null;

        stdout.printf ("SensorChip %s:\n", chip.prefix);
        while ((feature = Sensors.get_features (chip, ref nr)) != null) {
            if (ChipFeature.is_supported_feature (feature)) {
                features.add (new ChipFeature (this, feature));
            } else {
                stdout.printf ("Unsupported feature %s\n", feature.type.to_string ());
            }
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

    public string get_name () {
        return name;
    }
}