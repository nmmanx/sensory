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
            g.margin_start = 6;
            g.margin_end = 6;

            graph_box.pack_start (g, false, false, 0);
            graph_box.show_all ();
        }
    }

    private GraphProfile build_graph_profile (Sensors.FeatureType type) {
        switch (type) {
            case Sensors.FeatureType.TEMP:
                return new GraphProfile.Builder (type.to_string ())
                    .set_graph_title ("Temperature History")
                    .set_x_title ("")
                    .set_x_unit("C")
                    .set_x_limit (100, 0, 20)
                    .set_time_window (60)
                    .set_time_window_step (10)
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