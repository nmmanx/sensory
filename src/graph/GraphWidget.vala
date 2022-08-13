public class GraphWidget : Gtk.DrawingArea {
    public GraphProfile profile { private set; get; }
    private Gee.Set<TimeSeriesData> line_data;

    construct {
        line_data = new Gee.TreeSet<TimeSeriesData> ((a, b) => {
            if (a.name > b.name) {
                return 1;
            } else if (a.name < b.name) {
                return -1;
            }
            return 0;
        });
        set_size_request (-1, 200);
        draw.connect (on_draw);
    }

    public GraphWidget (GraphProfile profile) {
        this.profile = profile;
    }

    private void draw_graph_meta (Cairo.Context cr, Cairo.Rectangle rec) {

    }

    private void draw_line (Cairo.Context cr, Cairo.Rectangle rec, TimeSeriesData tsd) {
        cr.set_line_width (2);
        cr.set_source_rgba (1, 0, 0, 1);

        double hor_step = rec.width / (profile.time_window / tsd.interval);
        double x = rec.x + rec.width;

        for (int i = tsd.size () - 1; i >= 0; i--) {
            double val = 0;
            tsd.get_at (i, out val);
            double y = (1 - val / (profile.x_upper - profile.x_lower)) * rec.height;
            if (i == tsd.size () - 1) {
                cr.move_to (x, y);
            } else {
                cr.line_to (x, y);
            }
            x -= hor_step;
        }

        cr.stroke ();
    }

    private void draw_graph (Cairo.Context cr, Cairo.Rectangle rec) {
        // Draw graph area
        cr.set_line_width (0.5);
        cr.set_source_rgba (0, 0, 0, 1);
        cr.rectangle (rec.x, rec.y, rec.width, rec.height);
        cr.stroke ();

        // Draw horizontal lines
        int num_lines = (int)((profile.x_upper - profile.x_lower) / profile.x_step);
        double line_offset = rec.height / num_lines;
        double line_start = line_offset;

        while (num_lines - 1 > 0) {
            cr.move_to (rec.x, rec.y + line_start);
            cr.line_to (rec.x + rec.width, rec.y + line_start);
            cr.stroke ();
            line_start += line_offset;
            num_lines--;
        }

        // Draw vertical lines
        num_lines = (int)(profile.time_window / profile.time_window_step);
        line_offset = rec.width / num_lines;
        line_start = line_offset;

        while (num_lines - 1 > 0) {
            cr.move_to (rec.x + line_start, rec.y);
            cr.line_to (rec.x + line_start, rec.y + rec.height);
            cr.stroke ();
            line_start += line_offset;
            num_lines--;
        }

        foreach (var tsd in line_data) {
            draw_line (cr, rec, tsd);
        }   
    }   

    private bool on_draw (Cairo.Context cr) {
        cr.rectangle (0, 0, this.get_allocated_width (), this.get_allocated_height ());
        cr.set_source_rgb (0.5, 0.5, 0.5);
        cr.fill ();

        draw_graph (cr, Cairo.Rectangle () { 
            x = 10,
            y = 10,
            width = this.get_allocated_width () - 20,
            height = this.get_allocated_height () - 20
        });

        return true;
    }

    public bool add (TimeSeriesData tsd) {
        line_data.add (tsd);
        return true;
    }

    public void remove (TimeSeriesData tsd) {
        line_data.remove (tsd);
    }

    public uint count () {
        return line_data.size;
    }
}