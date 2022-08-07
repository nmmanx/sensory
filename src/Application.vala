public class Application : Gtk.Application {

    construct {
        this.shutdown.connect (() => {
            stdout.printf ("libsensors clean-up\n");
            Sensors.cleanup ();
        });
    }

    public Application () {
        Object (
            application_id: "com.github.nmmanx.sensory",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        stdout.printf ("libsensors init\n");
        Sensors.init (null);

        var tmp = SensorChip.get_all_sensor_chips ();
        
        var main_window = new MainWindow (this);
        main_window.show_all ();
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }
}
