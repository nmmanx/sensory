public class MainWindow : Gtk.ApplicationWindow {
    private SensorView sensor_view;
    private GraphPanel graph_pannel;

    construct {
        this.default_width = 680;
        this.default_height = 400;
        this.title = "Sensory";

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        sensor_view = new SensorView ();
        graph_pannel = new GraphPanel ();

        paned.pack1 (sensor_view, true, false);
        paned.pack2 (graph_pannel, true, false);

        sensor_view.set_size_request (50, -1);
        graph_pannel.set_size_request (100, -1);

        this.add (paned);
    }

    public MainWindow (Gtk.Application app) {
        Object (
            application: app
        );
    }
}