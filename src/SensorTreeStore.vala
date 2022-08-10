public class SensorTreeStore : Gtk.TreeStore {
    private Gee.Map<string, Sensor> sensors;

    public class GraphColumnData : GLib.Object {
        public bool visible { set; get; }
        public bool active { set; get; }
    }

    construct {
        GLib.Type columnTypes[] = {
            GLib.Type.STRING,
            GLib.Type.STRING,
            GLib.Type.OBJECT
        };
        set_column_types(columnTypes);
        sensors = new Gee.HashMap<string, Sensor> ();
    }

    public SensorTreeStore (Gee.List<SensorChip> chips) {
        build_tree (chips);
    }

    private void build_tree (Gee.List<SensorChip> chips) {
        Gtk.TreeIter iter;

        foreach (SensorChip chip in chips) {
            append (out iter, null);
            set_value (iter, 0, chip.get_name ());
            set_value (iter, 2, new GraphColumnData () { visible = false, active = false });

            Gtk.TreeIter iter2;
            foreach (ChipFeature feature in chip.features) {
                append (out iter2, iter);
                set_value (iter2, 0, feature.feature.name);
                set_value (iter2, 2, new GraphColumnData () { visible = true, active = false });

                foreach (ChipSubFeature subfeat in feature.subfeats) {
                    if (subfeat.is_input_subfeat ()) {
                        double val = 0;
                        if (subfeat.get_value (out val)) {
                            Sensor ss = create_new_sensor (iter2, subfeat);
                            stdout.printf ("map: %s -> %s\n", get_string_from_iter (iter2), subfeat.get_name ());
                            sensors.set (get_string_from_iter (iter2), ss);
                            ss.update ();
                        }
                        break;
                    }
                }
            }
        }
    }

    private Sensor create_new_sensor (Gtk.TreeIter iter, ChipSubFeature subfeat) {
        Sensor sensor = new Sensor (subfeat);
        sensor.on_value_changed.connect ((s, val) => {
            set_value (iter, 1, val);
        });
        return sensor;
    }

    public void setup_view (SensorTreeView view) {
        view.on_graph_cell_toggled.connect ((path) => {
            var iter = Gtk.TreeIter ();
            get_iter_from_string (out iter, path);
            var graph_col_data = get_column_object<GraphColumnData> (this, iter, 2);
            graph_col_data.active = !graph_col_data.active;
            set_value (iter, 2, graph_col_data);
        });
    }

    public static T? get_column_object<T> (Gtk.TreeModel model, Gtk.TreeIter iter, int col) {
        GLib.Value val;
        model.get_value (iter, col, out val);
        if (val.holds (GLib.Type.OBJECT)) {
            return (T)val.get_object ();
        }
        return null;
    }

    public void update () {
        foreach (var entry in sensors) {
            entry.value.update ();
        }
    }
}