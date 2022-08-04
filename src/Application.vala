public class Application : Gtk.Application {

    public Application () {
        Object (
            application_id: "com.github.nmmanx.temon",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var main_window = new Gtk.ApplicationWindow (this) {
            default_height = 300,
            default_width = 300,
            title = "Temon"
        };
        main_window.show_all ();
    }

    public static int main (string[] args) {
        var info = "libsensors version: %s\napi version: %#x\n".printf (Sensors.version, Sensors.API_VERSION);
        print (info);
        return new Application ().run (args);
    }
}
