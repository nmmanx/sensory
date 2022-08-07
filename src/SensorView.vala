public class SensorView : Gtk.Box {
    private Gtk.TreeView tree_view;

    construct {
        this.orientation = Gtk.Orientation.VERTICAL;
        Debug.set_bg (this, "red");

        var header = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        header.set_size_request (-1, 30);
        Debug.set_bg (header, "green");

        tree_view = new Gtk.TreeView ();

        this.pack_start (header, false, false, 0);
        this.pack_start (tree_view, true, true, 0);
    }
}