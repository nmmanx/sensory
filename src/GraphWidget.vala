public class GraphWidget : Gtk.DrawingArea {
    private Gee.Set<SensorModel> sensors;
    private Sensors.FeatureType feature_type;

    construct {
        sensors = new Gee.TreeSet<SensorModel> ((a, b) => {
            if (a.get_name () > b.get_name ()) {
                return 1;
            } else if (a.get_name () < b.get_name ()) {
                return -1;
            }
            return 0;
        });
        set_size_request (-1, 200);
        draw.connect (on_draw);
    }

    public GraphWidget (SensorModel first_sensor) {
        sensors.add (first_sensor);
        feature_type = first_sensor.get_feature_type ();
    }

    private bool on_draw (Cairo.Context cr) {
        cr.rectangle (0, 0, this.get_allocated_width (), this.get_allocated_height ());
        cr.set_source_rgb (0.5, 0.5, 0.5);
        cr.fill ();
        return true;
    }

    public Sensors.FeatureType get_feature_type () {
        return feature_type;
    }

    public bool add_sensor (SensorModel ss) {
        if (ss.get_feature_type () != feature_type) {
            return false;
        }
        if (sensors.contains (ss)) {
            return false;
        }
        sensors.add (ss);
        return true;
    }

    public void remove_sensor (SensorModel ss) {
        sensors.remove (ss);
    }

    public uint count_sensors () {
        return sensors.size;
    }
}