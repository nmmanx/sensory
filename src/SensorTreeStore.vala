public class SensorTreeStore : Gtk.TreeStore {

    construct {
        GLib.Type columnTypes[] = {
            GLib.Type.STRING,
            GLib.Type.STRING,
            GLib.Type.BOOLEAN
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

                foreach (ChipSubFeature subfeat in feature.subfeats) {
                    if (subfeat.is_input_subfeat ()) {
                        double val = 0;
                        if (subfeat.get_value (out val)) {
                            set_value (iter2, 1, val.to_string ());
                        }
                        break;
                    }
                }
            }
        }
    }

    public void setup_view (SensorTreeView view) {
        view.on_graph_cell_toggled.connect ((path) => {
            var iter = Gtk.TreeIter ();
            GLib.Value val;
            this.get_iter_from_string (out iter, path);
            this.get_value (iter, 2, out val);
            this.set_value (iter, 2, !val.get_boolean ());
        });
    }
}