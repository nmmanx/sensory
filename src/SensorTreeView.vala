public class SensorTreeView : Gtk.TreeView {

    public signal void on_graph_cell_toggled (string path);

    construct {
        var sensor_cell_renderer = new Gtk.CellRendererText ();
        var value_cell_renderer = new Gtk.CellRendererText ();
        var graph_cell_renderer = new Gtk.CellRendererToggle ();

        insert_column_with_attributes (-1, "Sensor", sensor_cell_renderer, "text", 0, null);
        insert_column_with_attributes (-1, "Value", value_cell_renderer, "text", 1, null);
        insert_column_with_attributes (-1, "Graph", graph_cell_renderer, "active", 2, null);

        graph_cell_renderer.set_property ("activatable", true);
        graph_cell_renderer.toggled.connect ((path) => {
            this.on_graph_cell_toggled (path);
        });
    }

    public SensorTreeView (SensorTreeStore? tree_store) {
        Object (
            model: tree_store
        );
        tree_store.setup_view (this);
    }
}