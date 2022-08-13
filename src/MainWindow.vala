public class MainWindow : Gtk.ApplicationWindow {
    private SensorTreeView sensor_view;
    private GraphPanel graph_pannel;
    private SensorTreeStore model;
    
    private const uint DEFAULT_TIMEOUT_SEC = 2;
    private uint time_tick_sec;
    private bool change_time_tick_requested;

    construct {
        this.default_width = 1024;
        this.default_height = 480;
        this.title = "Sensory";

        model = new SensorTreeStore (SensorChip.get_all_sensor_chips ());
        sensor_view = new SensorTreeView (model);
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

        sensor_panel.set_size_request (50, -1);
        graph_pannel.set_size_request (100, -1);

        sensor_view.expand_all ();
        sensor_view.columns_autosize ();
        this.add (paned);

        set_time_tick_sec (DEFAULT_TIMEOUT_SEC);
        time_tick_func ();

        model.graph_request.connect (graph_pannel.on_graph_request);
    }

    public MainWindow (Gtk.Application app) {
        Object (
            application: app
        );
    }

    private bool time_tick_func () {
        model.update ();
        graph_pannel.update ();

        if (change_time_tick_requested) {
            change_time_tick_requested = false;
            GLib.Timeout.add_seconds (time_tick_sec, time_tick_func, GLib.Priority.HIGH);
            return false;
        }
        return true;
    }

    public void set_time_tick_sec (uint sec) {
        time_tick_sec = sec;
        change_time_tick_requested = true;
    }
}