public class Application : Gtk.Application {

    public Application () {
        Object (
            application_id: "com.github.nmmanx.sensory",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var main_window = new Gtk.ApplicationWindow (this) {
            default_height = 300,
            default_width = 300,
            title = "Sensory"
        };
        main_window.show_all ();
    }

    public static int main (string[] args) {
        var info = "libsensors version: %s\napi version: %#x\n".printf (Sensors.version, Sensors.API_VERSION);
        print (info);
        Sensors.init (null);
        int nr = 0;
        unowned Sensors.ChipName? chip = null;
        while ((chip = Sensors.get_detected_chips (null, ref nr)) != null) {
            stdout.printf("Chip: %s\n", chip.prefix);
        }
        Sensors.cleanup ();
        return new Application ().run (args);
    }
}
