public class ChipFeature {
    public unowned Sensors.Feature feature { private set; get; }
    private SensorChip sensor_chip;
    public Gee.List<ChipSubFeature> subfeats { private set; get; }

    public ChipFeature (SensorChip sensor_chip, Sensors.Feature feature) {
        this.sensor_chip = sensor_chip;
        this.feature = feature;
        build ();
    }

    private void build () {
        subfeats = new Gee.ArrayList<ChipSubFeature> ((a ,b) => a.equal_to (b));
        var nr = 0;
        unowned Sensors.SubFeature? subfeat = null;

        stdout.printf ("\tChipFeature %s:\n", feature.name);
        while ((subfeat = Sensors.get_all_subfeatures (sensor_chip.chip, feature, ref nr)) != null) {
            stdout.printf ("\t\tChipSubFeature %s\n", subfeat.name);
            subfeats.add (new ChipSubFeature (sensor_chip, this, subfeat));
        }
    }

    public bool equal_to (ChipFeature other) {
        return this.sensor_chip.equal_to (other.sensor_chip) &&
                this.feature.name == other.feature.name;
    }

    public bool is_supported () {
        return ChipFeature.is_supported_feature (feature);
    }

    public static bool is_supported_feature (Sensors.Feature feature) {
        switch (feature.type) {
            case Sensors.FeatureType.IN:
            case Sensors.FeatureType.FAN:
            case Sensors.FeatureType.TEMP:
            case Sensors.FeatureType.POWER:
                return true;
            default:
                return false;
        }
    }
}