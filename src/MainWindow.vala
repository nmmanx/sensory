public class MainWindow : Gtk.ApplicationWindow {
    private SensorTreeView sensor_view;
    private GraphPanel graph_pannel;

    construct {
        this.default_width = 800;
        this.default_height = 480;
        this.title = "Sensory";

        sensor_view = new SensorTreeView (new SensorTreeStore (SensorChip.get_all_sensor_chips ()));
        graph_pannel = new GraphPanel ();

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        var sensor_panel = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        
        var header = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        header.set_size_request (-1, 30);
        //Debug.set_bg (header, "green");

        var scrolled_wd = new Gtk.ScrolledWindow (null, null);
        scrolled_wd.add (sensor_view);
        
        //sensor_panel.pack_start(header, false, false, 0);
        sensor_panel.pack_start(scrolled_wd, true, true, 0);

        paned.pack1 (sensor_panel, true, false);
        paned.pack2 (graph_pannel, true, false);

        sensor_panel.set_size_request (80, -1);
        graph_pannel.set_size_request (100, -1);

        sensor_view.expand_all ();
        sensor_view.columns_autosize ();
        this.add (paned);
    }

    public MainWindow (Gtk.Application app) {
        Object (
            application: app
        );
    }
}