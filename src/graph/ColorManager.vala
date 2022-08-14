public class ColorManager {
    private Color[] color_pool;

    private const string[] color_specs = {
        "#DC143C", // crimson
        "#4169E1", // royal blue
        "#9ACD32", // yellow green
        "#FF6347", // tomato
        "#FFA500", // orange
        "#7FFFD4", // aquamarine
        "#9370DB", // medium purple
    };

    public struct Color {
        bool available;
        string owner;
        Gdk.RGBA rgba;
    }

    public ColorManager () {
        color_pool = new Color[color_specs.length];
        for (int i = 0; i < color_specs.length; i++) {
            color_pool[i].rgba.parse (color_specs[i]);
            color_pool[i].rgba.alpha = 1;
            color_pool[i].available = true;
            color_pool[i].owner = "";
        }
    }

    public Gdk.RGBA? get_color (string owner) {
        Color* first = null;
        for (int i = 0; i < color_pool.length; i++) {
            if (owner == color_pool[i].owner) {
                return color_pool[i].rgba;
            } else if (first == null && color_pool[i].available) {
                first = &color_pool[i];
            }
        }
        if (first != null) {
            first.available = false;
            first.owner = owner;
            return first.rgba;
        }
        return null;
    }

    public void release_color (string owner) {
        foreach (var color in color_pool) {
            if (owner == color.owner) {
                color.available = false;
                color.owner = "";
                break;
            }
        }
    }
}