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
            if (wg.get_feature_type () == sensor.get_feature_type ()) {
                g = wg;
                break;
            }
        }
        if (g != null) {
            if (enabled) {
                g.add_sensor (sensor);
            } else {
                g.remove_sensor (sensor);
                if (g.count_sensors () == 0) {
                    graph_box.remove (g);
                    graphs.remove (g);
                }
            }
        } else if (enabled) {
            g = new GraphWidget (sensor);
            graphs.add (g);

            g.margin_top = 6;
            g.margin_start = 6;
            g.margin_end = 6;

            graph_box.pack_start (g, false, false, 0);
            graph_box.show_all ();
        }
    }
}