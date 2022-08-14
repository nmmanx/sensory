public class GraphPanel : Gtk.Bin {
    private Gee.List<GraphWidget> graphs;
    private Gtk.Box graph_box;

    construct {
        graph_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        var scrolled_wd = new Gtk.ScrolledWindow (null, null);
        scrolled_wd.add (graph_box);
        this.child = scrolled_wd;
    }

    public GraphPanel () {
        graphs = new Gee.ArrayList<GraphWidget> ();
    }

    public void on_graph_request (SensorModel sensor, bool enabled) {
        GraphWidget? g = null;
        
        foreach (GraphWidget wg in graphs) {
            if (wg.profile.feature_name == sensor.get_feature_type ().to_string ()) {
                g = wg;
                break;
            }
        }
        if (g != null) {
            if (enabled) {
                g.add (sensor);
            } else {
                g.remove (sensor);
                if (g.count () == 0) {
                    graph_box.remove (g);
                    graphs.remove (g);
                }
            }
        } else if (enabled) {
            var pf = build_graph_profile (sensor.get_feature_type ());
            g = new GraphWidget (pf);
            g.add (sensor);
            graphs.add (g);

            g.margin_top = 6;
            g.margin_start = 12;
            g.margin_end = 12;

            graph_box.pack_start (g, false, false, 0);
            graph_box.show_all ();
        }
    }

    private GraphProfile build_graph_profile (Sensors.FeatureType type) {
        var time_window = 60;
        var time_window_step = 5;

        switch (type) {
            case Sensors.FeatureType.TEMP:
                return new GraphProfile.Builder (type.to_string ())
                    .set_graph_title ("Temperature")
                    .set_x_title ("")
                    .set_x_unit("")
                    .set_x_limit (120, 0, 20)
                    .set_time_window (time_window)
                    .set_time_window_step (time_window_step)
                    .build ();
            case Sensors.FeatureType.IN:
                return new GraphProfile.Builder (type.to_string ())
                    .set_graph_title ("Voltage input")
                    .set_x_title ("")
                    .set_x_unit("")
                    .set_x_limit (20, 0, 5)
                    .set_time_window (time_window)
                    .set_time_window_step (time_window_step)
                    .build ();
            default:
                return new GraphProfile.Builder (type.to_string ()).build ();
        }
    }

    public void update () {
        foreach (var g in graphs) {
            g.queue_draw ();
        }
    }
}