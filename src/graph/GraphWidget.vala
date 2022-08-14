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
        var ver_label_width = 40;
        var hor_label_height = 20;
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

        var label_font_size = 10;
        var label_value = profile.x_upper; 
        draw_label_text (cr, label_value.to_string (), label_font_size, rec.x + rec.width + 6, rec.y, true);
        label_value -= profile.x_step;

        cr.set_line_width (0.5);
        cr.set_source_rgba (0.5, 0.5, 0.5, 0.8);
        while (num_lines - 1 > 0) {
            cr.move_to (rec.x, rec.y + line_start);
            cr.line_to (rec.x + rec.width, rec.y + line_start);
            cr.stroke ();
            draw_label_text (cr, label_value.to_string (),
                label_font_size, rec.x + rec.width + 6, rec.y + line_start, true);
            line_start += line_offset;
            label_value -= profile.x_step;
            num_lines--;
        }

        draw_label_text (cr, profile.x_lower.to_string (),
            label_font_size, rec.x + rec.width + 6, rec.y + rec.height, true);

        // Draw vertical lines
        num_lines = (int)(profile.time_window / profile.time_window_step);
        line_offset = rec.width / num_lines;
        line_start = line_offset;
        label_value = profile.time_window;

        draw_label_text (cr, label_value.to_string () + "s",
            label_font_size, rec.x, rec.y + rec.height + 6, false);
        label_value -= profile.time_window_step;

        cr.set_source_rgba (0, 0, 0, 0.5);
        while (num_lines - 1 > 0) {
            cr.move_to (rec.x + line_start, rec.y);
            cr.line_to (rec.x + line_start, rec.y + rec.height);
            cr.stroke ();
            draw_label_text (cr, label_value.to_string (),
                label_font_size, rec.x + line_start, rec.y + rec.height + 6, false);
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

        var title_font_size = 14;

        cr.set_source_rgb (0.2, 0.2, 0.2);
        cr.select_font_face ("inter", Cairo.FontSlant.NORMAL, Cairo.FontWeight.NORMAL);
        cr.set_font_size (title_font_size);
        var title_extents = calculate_text_extents (cr, profile.graph_title);

        cr.move_to (10 + title_extents.x_bearing, title_extents.height);
        cr.show_text (profile.graph_title);

        draw_graph (cr, Cairo.Rectangle () { 
            x = 6,
            y = title_extents.height + 2,
            width = this.get_allocated_width () - 12,
            height = this.get_allocated_height () - (title_extents.height + 2) - 12
        });

        return true;
    }

    private void draw_label_text (Cairo.Context cr, string txt, int size, double x, double y, bool vertical) {
        cr.select_font_face ("inter", Cairo.FontSlant.NORMAL, Cairo.FontWeight.NORMAL);
        cr.set_font_size (size);
        var extents = calculate_text_extents (cr, txt);
        if (vertical) {
            y = y + extents.height / 2;
        } else {
            x = x - extents.width / 2;
            y = y + extents.height;
        }
        cr.set_source_rgb (0.2, 0.2, 0.2);
        cr.move_to (x, y);
        cr.show_text (txt);
    }

    private Cairo.TextExtents calculate_text_extents (Cairo.Context cr, string text) {
        Cairo.TextExtents extents;
        cr.text_extents (text, out extents);
        return extents;
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