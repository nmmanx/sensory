public class TimeSeriesData : GLib.Object {
    public string name { private set; get; }
    public uint interval { private set; get; }
    public uint duration { private set; get; }

    private int max_size;

    private Gee.List<double?> values;

    public TimeSeriesData (string name, uint interval, uint duration) {
        this.name = name;
        this.interval = interval;
        this.duration = duration;
        this.values = new Gee.ArrayList<double?> ();

        max_size = (int)(duration / interval + 1);
        assert (max_size > 0);
    }

    public double push (double value) {
        values.add (value);
        if (values.size > max_size) {
            values.remove_at (0);
        }
        return value;
    }

    public int size () {
        return values.size;
    }

    public int capacity () {
        return max_size;
    }

    public bool get_at (int index, out double val) {
        if (index < values.size) {
            val = values.get (index);
            return true;
        }
        val = 0;
        return false;
    }
}