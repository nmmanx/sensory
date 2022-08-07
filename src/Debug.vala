public class Debug {
    
    public static void set_bg(Gtk.Widget wg, string color_spec) {
        var color = Gdk.RGBA ();
        color.parse(color_spec);
        wg.override_background_color (Gtk.StateFlags.NORMAL, color);
    }
}