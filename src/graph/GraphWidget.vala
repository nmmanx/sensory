public class GraphWidget : Gtk.DrawingArea {
    public GraphProfile profile { private set; get; }
    private Gee.List<TimeSeriesData> line_data;
    private ColorManager color_mgr;

    private const int SMALL_PADDING = 6;
    private const int LEGEND_COLUMN_COUNT = 3;
    private const int GRAPH_REQUEST_HEIGHT = 200;

    construct {
        line_data = new Gee.ArrayList<TimeSeriesData> ((a, b) => {
            return a.name == b.name;
        });
        color_mgr = new ColorManager ();
        draw.connect (on_draw);
    }

    public GraphWidget (GraphProfile profile) {
        this.profile = profile;
    }

    private void draw_line (Cairo.Context cr, Cairo.Rectangle rec, TimeSeriesData tsd) {
        cr.set_line_width (2);
        var color = color_mgr.get_color (tsd.name);
        cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);

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
        var ver_label_width = 40;
        var hor_label_height = 20;
        rec.width -= ver_label_width + SMALL_PADDING;
        rec.height -= hor_label_height + SMALL_PADDING;
        rec.x += SMALL_PADDING;
        rec.y += SMALL_PADDING;

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

    private void draw_legend (Cairo.Context cr, Cairo.Rectangle rec, int row_count, int cell_height) {
        var cell_width = rec.width / LEGEND_COLUMN_COUNT;

        for (int i = 0; i < line_data.size; i++) {
            var tsd = line_data.get (i);
            var row = i / LEGEND_COLUMN_COUNT;
            var col = i % LEGEND_COLUMN_COUNT;

            var color = get_line_color (tsd);
            var x = rec.x + SMALL_PADDING + col * cell_width;
            var y = rec.y + row * cell_height + cell_height / 2;
            cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);
            cr.set_line_width (6);
            cr.set_line_cap (Cairo.LineCap.ROUND);
            cr.move_to (x, y);
            cr.line_to (x + 25, y);
            cr.stroke ();
            draw_label_text (cr, tsd.name.replace ("/", " - "), 12, x + 25 + SMALL_PADDING, y, true);
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

        var legend_cell_height = 20;
        var legend_row_count = line_data.size % LEGEND_COLUMN_COUNT == 0 ?
                                line_data.size / LEGEND_COLUMN_COUNT : line_data.size / LEGEND_COLUMN_COUNT + 1;
        var legend_height = legend_row_count * legend_cell_height;

        var graph_rec = Cairo.Rectangle () { 
            x = SMALL_PADDING,
            y = title_extents.height + 2,
            width = this.get_allocated_width () - SMALL_PADDING * 2,
            height = GRAPH_REQUEST_HEIGHT - (title_extents.height + 2) - SMALL_PADDING * 2
        };
        
        var legend_rec = Cairo.Rectangle () { 
            x = SMALL_PADDING,
            y = graph_rec.y + graph_rec.height + 2,
            width = this.get_allocated_width () - SMALL_PADDING * 2,
            height = legend_height
        };

        set_size_request (-1, (int)(legend_rec.y + legend_rec.height));
        
        draw_graph (cr, graph_rec);
        draw_legend (cr, legend_rec, legend_row_count, legend_cell_height);
        
        return true;
    }

    private void draw_label_text (Cairo.Context cr, string txt, int size, double x, double y, bool vertical) {
        cr.select_font_face ("inter", Cairo.FontSlant.NORMAL, Cairo.FontWeight.NORMAL);
        cr.set_font_size (size);
        var extents = calculate_text_extents (cr, txt);
        if (vertical) {
            y = y - (extents.height / 2 + extents.y_bearing);
        } else {
            x = x - (extents.width / 2 + extents.x_bearing);
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

    private Gdk.RGBA get_line_color (TimeSeriesData tsd) {
        return color_mgr.get_color (tsd.name);
    }

    public bool add (TimeSeriesData tsd) {
        if (!line_data.contains (tsd)) { 
            line_data.add (tsd);
            queue_draw ();
            return true;
        }
        return false;
    }

    public void remove (TimeSeriesData tsd) {
        line_data.remove (tsd);
        color_mgr.release_color (tsd.name);
        queue_draw ();
    }

    public uint count () {
        return line_data.size;
    }
}