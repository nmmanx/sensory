public class ChipSubFeature {
    public unowned Sensors.SubFeature subfeat { private set; get; }
    private SensorChip sensor_chip;
    private ChipFeature feature;

    public ChipSubFeature (SensorChip sensor_chip, ChipFeature feature, Sensors.SubFeature subfeat) {
        this.sensor_chip = sensor_chip;
        this.feature = feature;
        this.subfeat = subfeat;
    }

    public bool equal_to (ChipSubFeature other) {
        return this.feature.equal_to (other.feature) &&
                this.subfeat.name == other.subfeat.name;
    }

    public bool get_value (out double val) {
        if (Sensors.get_value (sensor_chip.chip, subfeat.number, out val) != 0) {
            return false;
        }
        return true;
    }

    public bool is_input_subfeat () {
        return (int)subfeat.type == ((int)feature.feature.type << 8);
    }

    public string get_name () {
        return feature.get_name () + "/" + subfeat.name;
    }

    public Sensors.FeatureType get_feature_type () {
        return feature.feature.type;
    }
}