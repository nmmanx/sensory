public class SensorTreeView : Gtk.TreeView {

    construct {
        insert_column_with_attributes (-1, "Sensor", new Gtk.CellRendererText (), "text", 0, null);
        insert_column_with_attributes (-1, "Value", new Gtk.CellRendererText (), "text", 1, null);
    }

    public SensorTreeView (Gtk.TreeModel? m) {
        Object (
            model: m
        );
    }
}