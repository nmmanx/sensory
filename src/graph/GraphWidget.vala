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
        set_size_request (-1, 180);
        draw.connect (on_draw);
    }

    public GraphWidget (GraphProfile profile) {
        this.profile = profile;
    }

    private void draw_line (Cairo.Context cr, Cairo.Rectangle rec, TimeSeriesData tsd) {
        cr.set_line_width (2);
        cr.set_source_rgba (1, 0, 0, 1);

        double hor_step = rec.width / (profile.time_window / tsd.interval);
        double x = rec.x + rec.width;
        int max_points = (int)(profile.time_window / tsd.interval) + 1;

        for (int i = tsd.size () - 1; i >= 0 && max_points-- > 0; i--) {
            double val = 0;
            tsd.get_at (i, out val);
            double y = rec.y + (1 - val / (profile.x_upper - profile.x_lower)) * rec.height;
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
        var padding = 6;
        var ver_label_width = 30;
        var hor_label_height = 30;
        rec.width -= ver_label_width + padding;
        rec.height -= hor_label_height + padding;
        rec.x += padding;
        rec.y += padding;

        // Draw graph area
        cr.set_line_width (2);
        cr.set_source_rgba (0.5, 0.5, 0.5, 1);
        cr.rectangle (rec.x, rec.y, rec.width, rec.height);
        cr.stroke ();

        // Draw horizontal lines
        int num_lines = (int)((profile.x_upper - profile.x_lower) / profile.x_step);
        double line_offset = rec.height / num_lines;
        double line_start = line_offset;
        double val = profile.x_upper;

        var label_font_size = 10;
        var label_value = profile.x_upper; 
        draw_text_mono (cr, label_value.to_string (), label_font_size, rec.x + rec.width + 6, rec.y + label_font_size / 2);
        label_value -= profile.x_step;

        cr.set_line_width (0.5);
        cr.set_source_rgba (0.5, 0.5, 0.5, 0.8);
        while (num_lines - 1 > 0) {
            cr.move_to (rec.x, rec.y + line_start);
            cr.line_to (rec.x + rec.width, rec.y + line_start);
            cr.stroke ();
            draw_text_mono (cr, label_value.to_string (), label_font_size, rec.x + rec.width + 6, rec.y + line_start+ label_font_size / 2);
            line_start += line_offset;
            label_value -= profile.x_step;
            num_lines--;
        }

        draw_text_mono (cr, profile.x_lower.to_string (), label_font_size, rec.x + rec.width + 6, rec.y + rec.height + label_font_size / 2);

        // Draw vertical lines
        num_lines = (int)(profile.time_window / profile.time_window_step);
        line_offset = rec.width / num_lines;
        line_start = line_offset;

        label_value = profile.time_window;
        // TODO: must not use label_font_size / 2, calculate text width instead
        draw_text_mono (cr, label_value.to_string (), label_font_size, rec.x - label_font_size / 2, rec.y + rec.height + label_font_size + 6);
        label_value -= profile.time_window_step;

        cr.set_source_rgba (0, 0, 0, 0.5);
        while (num_lines - 1 > 0) {
            cr.move_to (rec.x + line_start, rec.y);
            cr.line_to (rec.x + line_start, rec.y + rec.height);
            cr.stroke ();
            draw_text_mono (cr, label_value.to_string (), label_font_size, rec.x + line_start - label_font_size / 2, rec.y + rec.height + label_font_size + 6);
            line_start += line_offset;
            label_value -= profile.time_window_step;
            num_lines--;
        }

        foreach (var tsd in line_data) {
            draw_line (cr, rec, tsd);
        }   
    }   

    private bool on_draw (Cairo.Context cr) {
        //  cr.set_source_rgb (0.5, 0.5, 0.5);
        //  cr.rectangle (0, 0, this.get_allocated_width (), this.get_allocated_height ());
        //  cr.fill ();

        var title_font_size = 13;
        var padding = 2;

        draw_text (cr, profile.graph_title, title_font_size, padding, title_font_size);

        draw_graph (cr, Cairo.Rectangle () { 
            x = padding,
            y = title_font_size + 6 + padding,
            width = this.get_allocated_width () - padding * 2,
            height = this.get_allocated_height () - (title_font_size + 6) - padding * 2
        });

        return true;
    }

    private void draw_text (Cairo.Context cr, string txt, int size, double x, double y, string font = "inter") {
        cr.set_source_rgb (0.2, 0.2, 0.2);
        cr.move_to (x, y);
        cr.select_font_face ("inter", Cairo.FontSlant.NORMAL, Cairo.FontWeight.NORMAL);
        cr.set_font_size (size);
        cr.show_text (txt);
    }

    private void draw_text_mono (Cairo.Context cr, string txt, int size, double x, double y) {
        // TODO: is this mono font?
        draw_text (cr, txt, size, x, y, "inter mono");
    }

    public bool add (TimeSeriesData tsd) {
        line_data.add (tsd);
        queue_draw ();
        return true;
    }

    public void remove (TimeSeriesData tsd) {
        line_data.remove (tsd);
        queue_draw ();
    }

    public uint count () {
        return line_data.size;
    }
}