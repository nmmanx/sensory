public class SensorTreeStore : Gtk.TreeStore {
    private Gee.List<SensorViewModel> view_models;

    construct {
        GLib.Type columnTypes[2] = {
            typeof(string),
            typeof(string)
        };
        set_column_types(columnTypes);
    }

    public SensorTreeStore (Gee.List<SensorChip> chips) {
        build_tree (chips);
    }

    private void build_tree (Gee.List<SensorChip> chips) {
        Gtk.TreeIter iter;

        foreach (SensorChip chip in chips) {
            append (out iter, null);
            set_value (iter, 0, chip.chip.prefix);

            Gtk.TreeIter iter2;
            foreach (ChipFeature feature in chip.features) {
                append (out iter2, iter);
                set_value (iter2, 0, feature.feature.name);

                Gtk.TreeIter iter3;
                foreach (ChipSubFeature subfeat in feature.subfeats) {
                    append (out iter3, iter2);
                    set_value (iter3, 0, subfeat.subfeat.name);
                    double val = 0;
                    if (subfeat.get_value (out val)) {
                        set_value (iter3, 1, val.to_string ());
                    }
                }
            }
        }
    }
}