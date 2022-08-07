public class ChipSubFeature {
    public unowned Sensors.SubFeature subfeat { private set; get; }
    private ChipFeature feature;

    public ChipSubFeature (ChipFeature feature, Sensors.SubFeature subfeat) {
        this.feature = feature;
        this.subfeat = subfeat;
    }

    public bool equal_to (ChipSubFeature other) {
        return this.feature.equal_to (other.feature) &&
                this.subfeat.name == other.subfeat.name;
    }
}